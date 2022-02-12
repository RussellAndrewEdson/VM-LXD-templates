#!/bin/bash

# Script to automate setup of a LXD container for Ubuntu 20.04
# complete with a working Julia v1.6.5 LTS setup.
#
# Code author: Russell A. Edson
# Date last modified: 12/02/2022

CONTAINER_NAME="ubuntu20-04-julia"
JULIA_PKG="https://julialang-s3.julialang.org/bin/linux/x64/"`
  `"1.6/julia-1.6.5-linux-x86_64.tar.gz"

# Provision VM and apt-upgrade
lxc launch ubuntu:20.04 $CONTAINER_NAME
sleep 10  # Need to wait for cloud-init to finish and network up?

lxc exec $CONTAINER_NAME -- bash -c "apt update && apt -y upgrade"

# Download and install Julia v1.6.5 LTS
lxc exec $CONTAINER_NAME -- bash -c \
  "wget -O julia.tar.gz ${JULIA_PKG}"`
  `" && tar -zxf julia.tar.gz"`
  `" && mv julia-1.6.5 /opt/"`
  `" && ln -s /opt/julia-1.6.5/bin/julia /usr/local/bin/julia"`
  `" && rm -rf julia.tar.gz"
