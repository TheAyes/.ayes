# mc-world-sync: sync Minecraft world/content between a live server and its dev
# counterpart. SSH-aware: each endpoint (live/dev) may be local or a remote host.
#
# Config is read from the JSON file pointed to by $MC_WORLD_SYNC_CONFIG, which is
# baked in by the home-manager module. Shape:
#   { "worldPaths": [...], "contentPaths": [...],
#     "servers": { "<name>": { "live": {"host": "user@h"|null, "dataDir": "..."},
#                              "dev":  {"host": ...,          "dataDir": "..."} } } }

CONFIG="${MC_WORLD_SYNC_CONFIG:?MC_WORLD_SYNC_CONFIG not set}"

die() {
  echo "mc-world-sync: error: $*" >&2
  exit 1
}

# --- endpoint helpers -------------------------------------------------------
# An endpoint's host is either empty (local) or an ssh destination.

# run_at HOST CMD  -> run CMD (a single shell string) locally or over ssh
run_at() {
  local host="$1" cmd="$2"
  if [[ -z "$host" ]]; then
    bash -c "$cmd"
  else
    ssh -o BatchMode=yes "$host" "$cmd"
  fi
}

# path_exists HOST PATH -> exit 0 if PATH exists on HOST
path_exists() {
  run_at "$1" "test -e '$2'"
}

# unit_active HOST NAME -> exit 0 if minecraft-server-NAME is active on HOST
unit_active() {
  run_at "$1" "systemctl is-active --quiet minecraft-server-$2"
}

# ctl HOST ACTION NAME -> systemctl ACTION on minecraft-server-NAME (via sudo)
ctl() {
  run_at "$1" "sudo systemctl $2 minecraft-server-$3"
}

# fix_owner HOST DATADIR -> chown the data dir back to the minecraft user
fix_owner() {
  run_at "$1" "sudo chown -R minecraft:minecraft '$2'"
}

# --- rcon (always executed on the live host, so it stays localhost-bound) ----
RCON_PORT=""
RCON_PASS=""

# rcon_load HOST DATADIR -> populate RCON_PORT/RCON_PASS from server.properties.
# Returns non-zero if rcon is not enabled on that server.
rcon_load() {
  local host="$1" props="$2/server.properties" contents
  contents="$(run_at "$host" "cat '$props' 2>/dev/null" || true)"
  local enabled
  enabled="$(printf '%s\n' "$contents" | grep -E '^enable-rcon=' | head -1 | cut -d= -f2- | tr -d '[:space:]')"
  [[ "$enabled" == "true" ]] || return 1
  RCON_PORT="$(printf '%s\n' "$contents" | grep -E '^rcon\.port=' | head -1 | cut -d= -f2- | tr -d '[:space:]')"
  RCON_PASS="$(printf '%s\n' "$contents" | grep -E '^rcon\.password=' | head -1 | cut -d= -f2-)"
  RCON_PORT="${RCON_PORT:-25575}"
  return 0
}

rcon_run() { # HOST CMD...  (each remaining arg is one console command)
  local host="$1"
  shift
  local args=""
  local c
  for c in "$@"; do
    args+=" \"$c\""
  done
  run_at "$host" "mcrcon -H 127.0.0.1 -P $RCON_PORT -p '$RCON_PASS'$args"
}

# --- backup ------------------------------------------------------------------
# backup HOST DATADIR NAME REL...  -> tar the existing REL dirs into a timestamped
# archive under <DATADIR>/../.world-backups on the destination host.
backup() {
  local host="$1" datadir="$2" name="$3"
  shift 3
  local existing=()
  local rel
  for rel in "$@"; do
    if path_exists "$host" "$datadir/$rel"; then
      existing+=("$rel")
    fi
  done
  if [[ ${#existing[@]} -eq 0 ]]; then
    echo "     (nothing present to back up)"
    return 0
  fi
  local ts bdir bfile
  ts="$(date +%Y%m%d-%H%M%S)"
  bdir="$datadir/../.world-backups"
  bfile="$bdir/$name-$ts.tar.zst"
  run_at "$host" "sudo mkdir -p '$bdir' && sudo tar --zstd -cf '$bfile' -C '$datadir' ${existing[*]}"
  echo "     backup -> $bfile (on ${host:-local})"
}

# --- transfer ----------------------------------------------------------------
# sync_path SRCHOST SRCDIR DSTHOST DSTDIR REL
# Copies DATADIR/REL from source to destination with rsync -a --delete.
# Handles every local/remote combination; only both-remote stages via a temp dir.
sync_path() {
  local sh="$1" sd="$2" dh="$3" dd="$4" rel="$5"
  local src="$sd/$rel" dst="$dd/$rel"

  if ! path_exists "$sh" "$src"; then
    echo "     skip $rel (absent on source)"
    return 0
  fi
  echo "     sync $rel"

  local opts=(-a --delete)
  if [[ -z "$sh" && -z "$dh" ]]; then
    mkdir -p "$dst"
    rsync "${opts[@]}" "$src/" "$dst/"
  elif [[ -n "$sh" && -z "$dh" ]]; then
    mkdir -p "$dst"
    rsync "${opts[@]}" -e ssh "$sh:$src/" "$dst/"
  elif [[ -z "$sh" && -n "$dh" ]]; then
    run_at "$dh" "sudo mkdir -p '$dst'"
    rsync "${opts[@]}" -e ssh --rsync-path="sudo rsync" "$src/" "$dh:$dst/"
  else
    # both remote: stage through a local temp dir
    local tmp
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' RETURN
    rsync "${opts[@]}" -e ssh "$sh:$src/" "$tmp/"
    run_at "$dh" "sudo mkdir -p '$dst'"
    rsync "${opts[@]}" -e ssh --rsync-path="sudo rsync" "$tmp/" "$dh:$dst/"
    rm -rf "$tmp"
    trap - RETURN
  fi
}

# --- config loading ----------------------------------------------------------
liveHost="" ; liveDir="" ; devHost="" ; devDir=""
WORLD_PATHS=() ; CONTENT_PATHS=()

load_server() {
  local server="$1"
  jq -e --arg s "$server" '.servers[$s]' "$CONFIG" >/dev/null 2>&1 \
    || die "unknown server '$server' (known: $(jq -r '.servers | keys | join(", ")' "$CONFIG"))"
  liveHost="$(jq -r --arg s "$server" '.servers[$s].live.host // ""' "$CONFIG")"
  liveDir="$(jq -r --arg s "$server" '.servers[$s].live.dataDir' "$CONFIG")"
  devHost="$(jq -r --arg s "$server" '.servers[$s].dev.host // ""' "$CONFIG")"
  devDir="$(jq -r --arg s "$server" '.servers[$s].dev.dataDir' "$CONFIG")"
  mapfile -t WORLD_PATHS < <(jq -r '.worldPaths[]' "$CONFIG")
  mapfile -t CONTENT_PATHS < <(jq -r '.contentPaths[]' "$CONFIG")
}

# --- commands ----------------------------------------------------------------
do_pull() {
  local server="" start_dev=1
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-start) start_dev=0 ;;
      -*) die "unknown flag: $1" ;;
      *) server="$1" ;;
    esac
    shift
  done
  [[ -n "$server" ]] || die "usage: mc-world-pull [--no-start] <server>"
  load_server "$server"

  echo "==> Pull '$server': live -> dev (world + content)"

  echo " -> stopping dev ($server-dev)"
  ctl "$devHost" stop "$server-dev" || true

  local rcon_on=0
  if unit_active "$liveHost" "$server"; then
    if rcon_load "$liveHost" "$liveDir"; then
      echo " -> live running: save-off + flushing to disk"
      rcon_run "$liveHost" "save-off" "save-all flush"
      sleep 3
      rcon_on=1
    else
      die "live '$server' is running but RCON is not enabled; refusing to copy a possibly-inconsistent world"
    fi
  else
    echo " -> live not running: copying at-rest"
  fi

  echo " -> backing up current dev state"
  backup "$devHost" "$devDir" "$server-dev" "${WORLD_PATHS[@]}" "${CONTENT_PATHS[@]}"

  echo " -> copying world + content"
  local rel
  for rel in "${WORLD_PATHS[@]}" "${CONTENT_PATHS[@]}"; do
    sync_path "$liveHost" "$liveDir" "$devHost" "$devDir" "$rel"
  done

  if [[ "$rcon_on" == 1 ]]; then
    echo " -> live save-on"
    rcon_run "$liveHost" "save-on" || true
  fi

  echo " -> fixing ownership on dev"
  fix_owner "$devHost" "$devDir"

  if [[ "$start_dev" == 1 ]]; then
    echo " -> starting dev ($server-dev)"
    ctl "$devHost" start "$server-dev"
  else
    echo " -> leaving dev stopped (--no-start)"
  fi
  echo "==> Pull complete."
}

do_push() {
  local server="" assume_yes=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -y|--yes) assume_yes=1 ;;
      -*) die "unknown flag: $1" ;;
      *) server="$1" ;;
    esac
    shift
  done
  [[ -n "$server" ]] || die "usage: mc-world-push [--yes] <server>"
  load_server "$server"

  # Hard safety: the world must never be part of a push.
  local c w
  for c in "${CONTENT_PATHS[@]}"; do
    for w in "${WORLD_PATHS[@]}"; do
      [[ "$c" == "$w" ]] && die "content path '$c' overlaps a world path; refusing to push (would risk the live world)"
    done
  done

  echo "==> Push '$server': dev -> live (content only; live world is never touched)"

  if [[ "$assume_yes" != 1 ]]; then
    read -rp "Overwrite mods/config on LIVE '$server' with dev's? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || die "aborted"
  fi

  echo " -> stopping live ($server) and dev ($server-dev)"
  ctl "$liveHost" stop "$server" || true
  ctl "$devHost" stop "$server-dev" || true

  echo " -> backing up current live content"
  backup "$liveHost" "$liveDir" "$server" "${CONTENT_PATHS[@]}"

  echo " -> copying content"
  local rel
  for rel in "${CONTENT_PATHS[@]}"; do
    sync_path "$devHost" "$devDir" "$liveHost" "$liveDir" "$rel"
  done

  echo " -> fixing ownership on live"
  fix_owner "$liveHost" "$liveDir"

  echo " -> starting live ($server)"
  ctl "$liveHost" start "$server"
  echo "==> Push complete. Dev left stopped."
}

# --- dispatch ----------------------------------------------------------------
sub="${1:-}"
[[ $# -gt 0 ]] && shift
case "$sub" in
  pull) do_pull "$@" ;;
  push) do_push "$@" ;;
  *) die "usage: mc-world-sync <pull|push> [flags] <server>" ;;
esac
