#!/run/current-system/sw/bin/ bash

monitor=$1

if [ "$monitor" == 0 ]; then monitor="eDP-1"; elif [ "$monitor" == 1 ]; then monitor="HDMI-A-1"; else exit 1; fi

icons=("" "" "" "" "" "" "" "" "")
activeIcons=("" "" "" "" "" "" "" "" "")
workspaces=(1 2 3 4 5 6 7 8 9)

renderWorkspaces() {
	
}

renderWorkspaces
socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r _event; do
    renderWorkspaces
done
