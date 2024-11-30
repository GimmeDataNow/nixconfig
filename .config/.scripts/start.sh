#! /usr/bin/env bash

swww init &

swww img ~/.config/.scripts/wallpaper.png &

# mpvpaper -f -o "--loop-file=inf" DVI-D-1 /home/hallow/.config/.scripts/2kpro.mp4

# mpvpaper -f "--loop-file=inf" HDMI-A-1 /home/hallow/.config/.scripts/2kpro.mp4

dunst &

waybar &
