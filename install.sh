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

# Removing old tzworks id app
# Now called id64, installed by line #14
if [ -e /usr/local/bin/id ]; then
  rm -f /usr/local/bin/id
fi
