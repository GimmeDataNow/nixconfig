#! /usr/bin/env bash

PLAYER_METADATA=$(playerctl metadata --no-messages --player spotify --format "{{ artist }} | {{ title }}" || echo "-")

if [ -z "$1" ]; then
  echo "$PLAYER_METADATA"
fi

if [[ $1 == "-c" || $1 == "--copy" ]]; then
  wl-copy "$PLAYER_METADATA"
fi
