#!/bin/sh
setxkbmap -layout us -variant altgr-intl -option nodeadkeys
xmodmap "${HOME}/.xmodmap"
