# Example modpack — a copy-me template for adding a new server set.
#
# A pack is a directory: this default.nix is the pack base (it applies the global
# baseline to each of the pack's servers), and every server is a sibling
# <server>.nix file in this directory.
#
# To turn this into a real modpack:
#   1. Copy this directory to <pack>/ and rename the servers in `heapSize`.
#   2. Set real heap sizes and per-server overrides in the <server>.nix files.
#   3. Import the directory from ../default.nix (e.g. `./<pack>`).
{ lib, pkgs, ... }:
let
  mkBaseline = import ../baseline-server.nix { inherit lib pkgs; };

  # One entry per server in this pack; the key must match a <server>.nix file.
  heapSize = {
    example = "4G";
    example-dev = "2G";
  };

  serverNames = builtins.attrNames heapSize;
in
{
  imports = builtins.map (server: ./. + "/${server}.nix") serverNames;

  services.minecraft-servers.servers = lib.attrsets.genAttrs serverNames (
    name: mkBaseline { heapSize = heapSize.${name}; }
  );
}
