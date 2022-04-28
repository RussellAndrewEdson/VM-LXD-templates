#!/bin/bash

# Script to automate setup of a LXD virtual machine for
# Ubuntu 20.04 Desktop with a full build-essential and
# texlive+Texmaker setup. Boot into the VGA console when
# the VM is online with:
#   lxc console VM_NAME --type=vga
#
# Code author: Russell A. Edson
# Date last modified: 28/04/2022

VM_NAME="ubuntu20-04-texmaker"

# Provision VM and apt-upgrade
lxc init images:ubuntu/20.04/desktop $VM_NAME --vm \
  -c limits.cpu=2 \
  -c limits.memory=8GiB
lxc config device override $VM_NAME root size=20GiB
lxc start $VM_NAME
sleep 20  # To allow cloud-init to finish, establish network
lxc exec $VM_NAME -- bash -c "apt update && apt -y upgrade"

# Install build-essential, texlive-full, texmaker
# TODO: Make this texlive-recommended or something instead?
#       texlive-full is pretty beefy...
lxc exec $VM_NAME -- bash -c \
  "apt -y install build-essential texlive-full texmaker"
lxc exec $VM_NAME -- bash -c "apt clean"

# Disable the GNOME screenlock
GSET="dbus-launch gsettings set"
lxc exec $VM_NAME -- runuser -l ubuntu -c \
  "$GSET org.gnome.desktop.screensaver lock-enabled false"
lxc exec $VM_NAME -- runuser -l ubuntu -c \
  "$GSET org.gnome.desktop.screensaver idle-activation-enabled false"
lxc exec $VM_NAME -- runuser -l ubuntu -c \
  "$GSET org.gnome.desktop.lockdown disable-lock-screen true"

# Add texmaker to the launcher dock
APPS="['firefox.desktop', 'org.gnome.Nautilus.desktop', 'texmaker.desktop']"
lxc exec $VM_NAME -- runuser -l ubuntu -c \
  "$GSET org.gnome.shell favorite-apps \"${APPS}\""

# Restart the VM and run the VGA console
lxc restart $VM_NAME
lxc console $VM_NAME --type=vga
