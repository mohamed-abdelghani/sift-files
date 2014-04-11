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

# Misc Scripts
cp scripts/* /usr/local/bin
