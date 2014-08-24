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

# Removing old tzworks id app
# Now called id64, installed by line #14
if [ -e /usr/local/bin/id ]; then
  rm -f /usr/local/bin/id
fi

chmod 755 /usr/local/bin/*
