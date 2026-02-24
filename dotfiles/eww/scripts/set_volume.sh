#!/usr/bin/env bash
new_volume="$1"
new_volume_perc=$(bc -l <<< "$new_volume / 100")
echo $new_volume_perc > ~/.config/eww/data/current_volume.txt
wpctl set-volume @DEFAULT_SINK@ $new_volume_perc
