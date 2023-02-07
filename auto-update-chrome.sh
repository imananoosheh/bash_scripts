#!/usr/bin/bash

killall chrome
wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' -O /tmp/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb

sudo rm /tmp/google-chrome-stable_current_amd64.deb


