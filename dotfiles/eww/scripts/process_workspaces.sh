#!/usr/bin/env bash

# Track the current urgent workspace in memory
urgent_id=-1

combine_and_output() {
  # produce combined JSON (active + list) and append urgent key
  combined=$(jq -s -c '{active: .[0], list: .[1]}' <(hyprctl activeworkspace -j) <(hyprctl workspaces -j | jq -c 'sort_by(.id)')) || return 1

  # Get the currently active workspace id
  active_id=$(printf '%s' "$combined" | jq -r '.active.id')

  # If there is an urgent workspace different from the current active workspace, output urgent as -1
  # Otherwise, output the urgent workspace id
  if [ "$urgent_id" != "-1" ] && [ "$urgent_id" != "$active_id" ]; then
    output_urgent=-1
  else
    output_urgent="$urgent_id"
  fi

  printf '%s\n' "$combined" | jq -c --argjson urgent "$output_urgent" '. + {urgent: $urgent}'
}

handle() {
  case "$1" in
    createworkspacev2*|destroyworkspacev2|workspacev2*)
      # If we switched to the urgent workspace, clear urgent
      active_id=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null || echo "")
      if [ "$urgent_id" != "-1" ] && [ -n "$active_id" ] && [ "$urgent_id" = "$active_id" ]; then
        urgent_id=-1
      fi

      combine_and_output
      ;;

    urgent*)
      addr_hex=$(printf "%s" "$1" | awk -F'>>' '{print $2}')
      case "$addr_hex" in
        0x*) addr="$addr_hex" ;;
        *) addr="0x$addr_hex" ;;
      esac

      ws_id=$(hyprctl clients -j 2>/dev/null | jq -r --arg addr "$addr" '.[] | select(.address == $addr) | .workspace.id' | head -n1)

      # Get the currently active workspace id
      active_id=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null || echo "")

      if [ -n "$ws_id" ] && [ "$ws_id" != "null" ]; then
        # Only mark as urgent if it's not already the active workspace
        if [ -z "$active_id" ] || [ "$ws_id" != "$active_id" ]; then
          urgent_id="$ws_id"
        else
          # If it's already active, clear urgent
          urgent_id=-1
        fi
      else
        urgent_id=-1
      fi

      combine_and_output
      ;;
  esac
}

SOCKET_PATH=$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
socat -U - "UNIX-CONNECT:$SOCKET_PATH" | while read -r line; do
  handle "$line"
done
