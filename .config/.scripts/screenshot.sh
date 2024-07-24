#! /usr/bin/env bash
SCREENSHOTS_FOLDER=~/screenshots

if [ ! -d "$SCREENSHOTS_FOLDER" ]; then
  echo "$SCREENSHOTS_FOLDER does not exist"
  echo "Now creating $SCREENSHOTS_FOLDER"
  mkdir $SCREENSHOTS_FOLDER
fi

grim -g "$(slurp)" $SCREENSHOTS_FOLDER/"$(date +%Y-%m-%d@%H:%M:%S)".png
