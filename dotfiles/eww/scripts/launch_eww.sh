#!/usr/bin/env bash

source_dir=$1

eww close-all
eww kill

ln -sf $source_dir $HOME/.config/eww

eww open my_vertical_bar
eww open my_desktop_window
eww open aseprite_launcher
