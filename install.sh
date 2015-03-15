#!/bin/bash

# Foremost Config
cp foremost/foremost.conf /etc/foremost.conf

# Sorter
cp sorter/* /usr/share/tsk/sorter

# Samba
cp samba/* /etc/samba

# WB Tools
cp wbtools/* /usr/local/bin

# PDF Tools
cp pdf-tools/* /usr/local/bin

# Misc Scripts
cp scripts/* /usr/local/bin

# Volatility Plugins
cp volatility/*.py /usr/lib/python2.7/dist-packages/volatility/plugins
rm -f /usr/lib/python2.7/dist-packages/volatility/plugins/javarat.py
chmod -R 644 /usr/lib/python2.7/dist-packages/volatility/plugins/*.py

# Install Density Scout
cp densityscout/densityscout /usr/local/bin

# Intall PE Carver
cp pe_carver/*.py /usr/local/bin

# Install Page Brute
cp page_brute/*.py /usr/local/bin

# Install Java PDX Parser
cp java_idx_parser/*.py /usr/local/bin

# Install SIFT Files
mkdir -p /usr/share/sift/resources
cp sift/resources/* /usr/share/sift/resources
mkdir -p /usr/share/sift/images
cp sift/images/* /usr/share/sift/images
mkdir -p /usr/share/sift/audio
cp sift/audio/* /usr/share/sift/audio
mkdir -p /usr/share/sift/other
cp sift/other/* /usr/share/sift/other
mkdir -p /usr/share/sift/scripts
cp sift/scripts/* /usr/local/bin

# Updated Regripper Stuff
mkdir -p /usr/share/regripper
cp -R regripper/* /usr/share/regripper
chmod -R 644 /usr/share/regripper/*

# Removing old tzworks id app
# Now called id64, installed by line #14
if [ -e /usr/local/bin/id ]; then
  rm -f /usr/local/bin/id
fi

chmod 755 /usr/local/bin/*

## Fix Privacy Controls
bash fixubuntu.sh

## Install Patches

# Install rc.local patch for more loopback devices
# fixes https://github.com/sans-dfir/sift/issues/22
patch -sN /etc/rc.local < patches/rc.local.patch
