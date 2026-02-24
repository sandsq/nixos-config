#!/usr/bin/env bash

COMBINE_CMD="jq -s -c '{active: .[0], list: .[1]}' <(hyprctl activeworkspace -j) <(hyprctl workspaces -j | jq -c 'sort_by(.id)')"


handle() {
  case "$1" in
    createworkspacev2*|destroyworkspacev2|workspacev2*)
      eval "$COMBINE_CMD";;
  esac
}

SOCKET_PATH=$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
socat -U - "UNIX-CONNECT:$SOCKET_PATH" | while read -r line; do
  handle "$line"
done
