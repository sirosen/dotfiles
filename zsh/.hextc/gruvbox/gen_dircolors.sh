#!/bin/bash

set -euo pipefail
cd "$(dirname "$0")"

_gruv () {
  local hexcolor
  hexcolor="$(./dark_colorname.sh "$1")"
  shift 1
  ../hextc "$hexcolor" --dircolors "$@"
}

cat <<EOH
# colorize output to ttys, but not pipes
COLOR tty

# one TERM entry for each termtype that is colorizable
$(for term in \
  ansi color_xterm color-xterm \
  con132x25 con132x30 con132x43 con132x60 con80x25 con80x28 con80x30 con80x43 \
  con80x50 con80x60 cons25 console cygwin dtterm dvtm dvtm-256color Eterm \
  eterm-color fbterm gnome gnome-256color jfbterm konsole konsole-256color \
  kterm linux linux-c mach-color mlterm nxterm putty putty-256color rxvt \
  rxvt-256color rxvt-cygwin rxvt-cygwin-native rxvt-unicode rxvt-unicode256 \
  rxvt-unicode-256color screen screen-16color screen-16color-bce \
  screen-16color-s screen-16color-bce-s screen-256color screen-256color-bce \
  screen-256color-s screen-256color-bce-s screen-256color-italic screen-bce \
  screen-w screen.linux screen.xterm-256color screen.xterm-new st st-meta \
  st-256color st-meta-256color tmux tmux-256color vt100 xterm xterm-new \
  xterm-16color xterm-256color xterm-256color-italic xterm-88color \
  xterm-color xterm-debian xterm-termite ; do
  echo "TERM $term"
done)

# EIGHTBIT, followed by '1' for on, '0' for off. (8-bit output)
EIGHTBIT 1

# global default, normal files
NORMAL 00
FILE 00

# directory
DIR $(_gruv blue);1
# XX2, XX3, XX6, and XX7 directories (orange bg, bold)
OTHER_WRITABLE $(_gruv orange --bg);$(_gruv bg0_h);1
# symbolic link
LINK $(_gruv brightaqua)

# pipe, socket, block device, character device (lighter bg, normal text)
$(for key in FIFO SOCK DOOR BLK CHR; do
  echo "$key $(_gruv bg3 --bg)"
done)

# Orphaned symlinks, missing symlink targets
$(for key in ORPHAN MISSING; do
  echo "$key $(_gruv brightred);$(_gruv bg2 --bg)"
done)

# executables
$(for key in EXEC .cmd .exe .com .bat .reg .app; do
  echo "$key $(_gruv brightgreen);1"
done)

# Text, Markdown
$(for key in .txt .org .md .rs .adoc .mkd; do
  echo "$key $(_gruv fg3)"
done)

# Source
$(for key in \
  .h .hpp .c .C .cc .cpp .cxx .objc .cl \
  .sh .bash .csh .zsh \
  .el .vim .java .pl .pm .py .rb .jinja2 \
  .hs .php .htm .html .shtml .erb .haml \
  .xml .rdf .css .sass .scss .less .js .coffee .man \
  ".0" ".1" ".2" ".3" ".4" ".5" ".6" ".7" ".8" ".9" \
  .l .n .p .pod .tex .go .sql .csv .sv .svh .v .vh .vhd; do
  echo "$key $(_gruv green)"
done)

### Multimedia formats
$(for key in \
  .bmp .cgm .dl .dvi .emf .eps .gif .jpeg .jpg .JPG \
  .mng .pbm .pcx .pdf .pgm .png .PNG .ppm .pps .ppsx \
  .ps .svg .svgz .tga .tif .tiff .xbm .xcf .xpm .xwd \
  .xwd .yuv .aac .au .flac .m4a .mid .midi .mka .mp3 \
  .mpa .mpeg .mpg .ogg .opus .ra .wav .anx .asf .avi \
  .axv .flc .fli .flv .gl .m2v .m4v .mkv .mov .MOV .mp4 \
  .mp4v .mpeg .mpg .nuv .ogm .ogv .ogx .qt .rm .rmvb \
  .swf .vob .webm .wmv; do
  echo "$key $(_gruv brightpurple)"
done)

# Binary document formats and multimedia source
$(for key in \
  .doc .docx .rtf .odt .dot .dotx .ott .xls .xlsx \
  .ods .ots .ppt .pptx .odp .otp .fla .psd; do
  echo "$key $(_gruv purple)"
done)

# Archives, compressed
$(for key in \
  .7z .apk .arj .bin .bz .bz2 .cab .deb .dmg \
  .gem .gz .iso .jar .msi .rar .rpm .tar .tbz \
  .tbz2 .tgz .tx .war .whl .xpi .xz .z .Z .zip; do
  echo "$key $(_gruv yellow);1"
done)

# Semi-hidden files
$(for key in \
  ".log" "*~" "*#" ".bak" ".BAK" ".old" ".OLD" ".org_archive" \
  ".off" ".OFF" ".dist" ".DIST" ".orig" ".ORIG" ".swp" ".swo" "*,v"; do
  echo "$key $(_gruv gray);1"
done)

# special data/files
$(for key in .gpg .pgp .asc .3des .aes .enc .sqlite; do
  echo "$key $(_gruv red)"
done)
EOH
