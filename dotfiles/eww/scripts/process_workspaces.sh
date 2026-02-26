#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/eww"
CACHE_FILE="$CACHE_DIR/urgent.json"

ensure_cache_dir() {
  mkdir -p "$CACHE_DIR"
}

read_urgent() {
  if [ -f "$CACHE_FILE" ]; then
    urgent_id=$(jq -r '.urgent // -1' "$CACHE_FILE" 2>/dev/null || echo -1)
    if [ -z "$urgent_id" ] || [ "$urgent_id" = "null" ]; then
      urgent_id=-1
    fi
  else
    urgent_id=-1
  fi
}

write_urgent() {
  local val="$1"
  printf '{"urgent": %s}\n' "$val" > "$CACHE_FILE"
}

combine_and_output() {
  # produce combined JSON (active + list) and append urgent key
  combined=$(jq -s -c '{active: .[0], list: .[1]}' <(hyprctl activeworkspace -j) <(hyprctl workspaces -j | jq -c 'sort_by(.id)')) || return 1
  printf '%s\n' "$combined" | jq -c --argjson urgent "$urgent_id" '. + {urgent: $urgent}'
}

handle() {
  case "$1" in
    createworkspacev2*|destroyworkspacev2|workspacev2*)
      ensure_cache_dir
      read_urgent

      # If we switched to the urgent workspace, clear urgent (only then)
      active_id=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null || echo "")
      if [ "$urgent_id" != "-1" ] && [ -n "$active_id" ] && [ "$urgent_id" = "$active_id" ]; then
        urgent_id=-1
        write_urgent -1
      fi

      combine_and_output
      ;;

    urgent*)
      ensure_cache_dir

      addr_hex=$(printf "%s" "$1" | awk -F'>>' '{print $2}')
      case "$addr_hex" in
        0x*) addr="$addr_hex" ;;
        *) addr="0x$addr_hex" ;;
      esac

      ws_id=$(hyprctl clients -j 2>/dev/null | jq -r --arg addr "$addr" '.[] | select(.address == $addr) | .workspace.id' | head -n1)

      if [ -n "$ws_id" ] && [ "$ws_id" != "null" ]; then
        urgent_id="$ws_id"
        write_urgent "$ws_id"
      else
        urgent_id=-1
        write_urgent -1
      fi

      combine_and_output
      ;;
  esac
}

SOCKET_PATH=$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
socat -U - "UNIX-CONNECT:$SOCKET_PATH" | while read -r line; do
  handle "$line"
done
