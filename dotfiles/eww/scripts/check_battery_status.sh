#!/usr/bin/env bash

# This script uses `acpi` for all battery information so the specific
# battery name (BAT0/BAT1/etc.) doesn't matter.
#
# Supported flags:
#   --capacity        : prints battery percentage (number only)
#   --status          : prints battery status (Charging/Discharging/Full/etc.)
#   --status-icon     : prints a small icon for status (Charging vs Discharging)
#   --remaining-time  : prints remaining time as "Xh, Ym, Zs"
#   --end-time        : prints an end-time string if available (e.g. "01:23 PM")
#
# Example:
#   ./check_battery_status.sh --capacity

# helper: ensure acpi exists
if ! command -v acpi >/dev/null 2>&1; then
    echo "acpi not found"
    exit 1
fi

# Check arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided. Use --capacity, --status, --status-icon, --remaining-time, or --end-time."
    exit 1
fi

# get first battery line from acpi
get_acpi_line() {
    # acpi -b prints battery info lines; pick the first non-empty line
    acpi -b | sed -n '1p'
}

if [[ "$1" == "--capacity" ]]; then
    # extract first percentage number
    acpi_line="$(get_acpi_line)"
    perc=$(echo "$acpi_line" | grep -oP '\d+(?=%)' | head -n1)
    if [[ -n "$perc" ]]; then
        echo "$perc"
        exit 0
    else
        echo "N/A"
        exit 1
    fi

elif [[ "$1" == "--status" ]]; then
    acpi_line="$(get_acpi_line)"
    # status usually appears after "Battery N: " and before the first comma
    status=$(echo "$acpi_line" | sed -E 's/^Battery[[:space:]]*[0-9]+:[[:space:]]*([^,]+).*/\1/g' | awk '{$1=$1;print}')
    if [[ -n "$status" ]]; then
        echo "$status"
        exit 0
    else
        echo "Unknown"
        exit 1
    fi

elif [[ "$1" == "--remaining-time" ]]; then
    acpi_line="$(get_acpi_line)"
    # extract first time-like token (HH:MM:SS or HH:MM)
    remaining="$(echo "$acpi_line" | grep -oP '\d{1,2}:\d{2}(:\d{2})?' | head -n1)"
    if [[ -z "$remaining" ]]; then
        echo "N/A"
        exit 1
    fi

    # Normalize to H M S
    IFS=':' read -r h m s_rest <<< "$(echo "$remaining" | awk -F: '{ if (NF==2) { print $1 ":" $2 ":00" } else { print $1 ":" $2 ":" $3 } }')"
    h=$((10#$h))
    m=$((10#$m))
    s=$((10#${s_rest:-0}))
    printf "%dh, %dm, %ds\n" "$h" "$m" "$s"
    exit 0

elif [[ "$1" == "--end-time" ]]; then
    acpi_line="$(get_acpi_line)"
    # look for explicit phrases like "until charged at", "fully discharged at", or generic "at TIME"
    # try a few patterns, return first match
    end_time=$(echo "$acpi_line" | grep -oP '(until charged at|fully discharged at|at) \K[0-9]{1,2}:[0-9]{2}(:[0-9]{2})? ?(AM|PM|am|pm)?' | head -n1)
    if [[ -n "$end_time" ]]; then
        echo "$end_time"
        exit 0
    fi

    # fallback: try acpi -e for event-style output (if supported)
    end_time=$(acpi -e 2>/dev/null | grep -oP '[0-9]{1,2}:[0-9]{2} ?(AM|PM|am|pm)?' | head -n1 || true)
    if [[ -n "$end_time" ]]; then
        echo "$end_time"
        exit 0
    fi

    echo "N/A"
    exit 1

elif [[ "$1" == "--status-icon" ]]; then
    acpi_line="$(get_acpi_line)"
    status=$(echo "$acpi_line" | sed -E 's/^Battery[[:space:]]*[0-9]+:[[:space:]]*([^,]+).*/\1/g' | awk '{$1=$1;print}')
    if [[ "$status" == "Charging" ]]; then
        echo "▞"
    else
        echo "↓"
    fi
    exit 0

else
    echo "Invalid argument. Use --capacity, --status, --status-icon, --remaining-time, or --end-time."
    exit 1
fi
