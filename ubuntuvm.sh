#!/bin/bash

# Script to automate setup of a basic QEMU/KVM virtual machine for 
# Ubuntu 20.04.
#
# Code author: Russell A. Edson
# Date last modified: 12/02/2022

DISKS_DIR="/zfspool/disks"
VM_NAME="ubuntu20.04"
ISO="/zfspool/ISOs/ubuntu-20.04.3-desktop-amd64.iso"

virt-install \
  --name "${VM_NAME}" \
  --vcpus=2 \
  --ram=8192 \
  --disk path="${DISKS_DIR}/${VM_NAME}.qcow2",size=16 \
  --os-type=linux \
  --os-variant=ubuntu20.04 \
  -w network=default \
  --cdrom "${ISO}"
