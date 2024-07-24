#! /usr/bin/env bash

if [[ $1 == "play-pause" ]]; then
  playerctl --player spotify play-pause
fi

if [[ $1 == "previous" ]]; then
  playerctl --player spotify previous
fi

if [[ $1 == "next" ]]; then
  playerctl --player spotify next
fi

