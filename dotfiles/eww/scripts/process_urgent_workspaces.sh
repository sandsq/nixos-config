#!/usr/bin/env bash



handle() {
  case "$1" in
    urgent*)
        addr_hex=$(printf "%s" "$1" | awk -F'>>' '{print $2}')
        case "$addr_hex" in
            0x*) addr="$addr_hex";;
            *) addr="0x$addr_hex";;
        esac

        ws_id=$(hyprctl clients -j 2>/dev/null | jq -r --arg addr "$addr" '.[] | select(.address == $addr) | .workspace.id' | head -n1)

        echo hello >> $HOME/nixos-config-surface/dotfiles/eww/data/ipc_test.txt
        echo "$ws_id";;
  esac
}

SOCKET_PATH=$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
socat -U - "UNIX-CONNECT:$SOCKET_PATH" | while read -r line; do
  handle "$line"
done
