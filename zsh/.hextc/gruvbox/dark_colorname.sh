#!/bin/bash
case "$1" in
  bg0_h) echo "1d2021" ;;
  bg|bg0) echo "282828" ;;
  bg0_s) echo "32302f" ;;
  bg1) echo "3c3836" ;;
  bg2) echo "504945" ;;
  bg3) echo "665c54" ;;
  bg4) echo "7c6f64" ;;
  fg0) echo "fbf1c7" ;;
  fg|fg1) echo "ebdbb2" ;;
  fg2) echo "d5c4a1" ;;
  fg3) echo "bdae93" ;;
  fg4|lightgrey|lightgray) echo "a89984" ;;
  grey|gray) echo "928374" ;;
  red) echo "cc241d" ;;
  brightred) echo "fb4934" ;;
  green) echo "98971a" ;;
  brightgreen) echo "b8bb26" ;;
  yellow) echo "d79921" ;;
  brightyellow) echo "fabd2f" ;;
  orange) echo "d65d0e" ;;
  brightorange) echo "fe8019" ;;
  blue) echo "458588" ;;
  brightblue) echo "83a598" ;;
  purple) echo "b16286" ;;
  brightpurple) echo "d3869b" ;;
  aqua) echo "689d6a" ;;
  brightaqua) echo "83c07c" ;;
  *) exit 2;;
esac
