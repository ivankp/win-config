#!/bin/bash

mkdir -p WindowsTerminal
cp -v "$HOME/AppData/Local/Microsoft/Windows Terminal/settings.json" WindowsTerminal/

cp -v "$HOME/.vim/vimrc" ./
