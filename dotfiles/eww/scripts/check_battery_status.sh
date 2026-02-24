#!/usr/bin/env bash

# function to parse acpi output
parse_acpi() {
    echo "$1" | grep -oP 'Battery \d+: \w+, \K[0-9]+%' | head -n 1
}

# function to parse end time
parse_end_time() {
    echo "$1" | grep -oP 'fully discharged at \K[0-9:]+'
}

# Check arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided. Use --capacity, --status, --status-icon, --remaining-time, or --end-time."
    exit 1
fi

# status=$(eww get EWW_BATTERY | jq -r '.BAT1.status')
if [[ "$1" == "--capacity" ]]; then
    cat /sys/class/power_supply/BAT1/capacity
    # exit 0
elif [[ "$1" == "--status" ]]; then
    status=$(cat /sys/class/power_supply/BAT1/status)
elif [[ "$1" == "--remaining-time" ]]; then
    acpi_output=$(acpi -r)
    remaining_time=$(echo "$acpi_output" | grep -oP '\d{2}:\d{2}:\d{2}')
    hours=$(echo "$remaining_time" | cut -d':' -f1)
    minutes=$(echo "$remaining_time" | cut -d':' -f2)
    seconds=$(echo "$remaining_time" | cut -d':' -f3)
    # Format with a single zero for hours if both are zero
    formatted_time=$(printf "%dh, %dm, %ds" "$((10#$hours))" "$((10#$minutes))" "$((10#$seconds))")
    echo "$formatted_time"
    exit 0
elif [[ "$1" == "--end-time" ]]; then
    acpi_output=$(acpi -e -F "%I:%M %p")
    end_time=$(echo "$acpi_output" | grep -oP 'fully discharged at \K[0-9:]+.*')
    echo "$end_time"
    exit 0
elif [[ "$1" == "--status-icon" ]]; then
    status=$(cat /sys/class/power_supply/BAT1/status)

    if [ "$status" = "Charging" ]; then
        # echo "󱐋"
        echo "▞"
    else
        # echo ""
        echo "↓"
    fi
    exit 0
else
    echo "Invalid argument. Use --capacity, --status, --status-icon, --remaining-time, or --end-time."
    exit 1
fi
