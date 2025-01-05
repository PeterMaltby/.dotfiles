#!/bin/bash
# fileMatch.sh
# author: peterm
# created: 2024-11-23
#############################################################
#source "$S/PABLO.sh"
#############################################################

for entry in *
do
  filename=$(echo $entry | cut -d "." -f 1)
  extension=$(echo $entry | cut -d "." -f 2)
  if [ "$extension" = "JPG" ]; then
    if [ -z $(ls | grep "${filename}.dds") ]; then echo $filename; fi
  fi
done

