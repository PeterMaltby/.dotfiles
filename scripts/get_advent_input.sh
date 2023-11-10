#!/bin/bash
# get_advent_input.sh
# author: peterm
# created: 2023-11-10
#############################################################
source "$S/PABLO.sh"

cookie=$AOC_SESSION
adventRepo="$G/advent-of-code"
currentYear=$(date +%Y)
#############################################################
pStart

# command line args
year=$1
day=$2


if [[ $year -le "2014" ]] || [[ $year -gt $currentYear ]]; then
    pError "invlaid year $year"
fi

if [[ $day -le "0" ]] || [[ $day -gt "25" ]]; then
    pError "invlaid day $day"
fi

if [ ! -d "$adventRepo" ]; then
    pError "advent repo is not present at $adventRepo"
fi

urlPath="https://adventofcode.com/$year/day/$day/input"
destPath="$adventRepo/input/$year"
destFile="$destPath/$day.txt"

mkdir -p "$destPath"
pCheckError $? "mkdir $destPath"

touch "$destFile"

curl --cookie "$cookie" "$urlPath" > "$destFile"
pCheckError $? "curl"

pLog "successfuly got advent of code input file $destFile"

pEnd
