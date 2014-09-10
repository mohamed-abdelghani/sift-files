#!/bin/bash

# Foremost Config
cp foremost/foremost.conf /etc/foremost.conf

# Sorter
cp sorter/* /usr/share/tsk/sorter

# Samba
cp samba/* /etc/samba

# TZWorks
mkdir -p /usr/local/share/tzworks
cp tzworks/bin/* /usr/local/bin
cp -R tzworks/docs/* /usr/local/share/tzworks

# WB Tools
cp wbtools/* /usr/local/bin

# Misc Scripts
cp scripts/* /usr/local/bin

# Volatility Plugins
cp volatility/*.py /usr/lib/python2.7/dist-packages/volatility/plugins

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
cp sift/scripts/* /usr/share/sift/scripts

# Removing old tzworks id app
# Now called id64, installed by line #14
if [ -e /usr/local/bin/id ]; then
  rm -f /usr/local/bin/id
fi

chmod 755 /usr/local/bin/*

## Install Patches

# Install rc.local patch for more loopback devices
# fixes https://github.com/sans-dfir/sift/issues/22
patch -sN /etc/rc.local < patches/rc.local.patch