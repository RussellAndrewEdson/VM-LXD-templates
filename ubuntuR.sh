#!/bin/bash

# Script to automate setup of a LXD container for Ubuntu 20.04
# complete with a working R v4.0 setup + tidyverse, other packages.
#
# Code author: Russell A. Edson
# Date last modified: 12/02/2022

CONTAINER_NAME="ubuntu20-04-001"
CRAN="https://cloud.r-project.org/bin/linux/ubuntu"

# Provision VM and apt-upgrade
lxc launch ubuntu:20.04 $CONTAINER_NAME
sleep 10  # Wait for cloud-init to finish, network to be set up, etc

lxc exec $CONTAINER_NAME -- bash -c "apt update && apt -y upgrade"

# Add CRAN R4.0 repository, install R, tidyverse dependencies
lxc exec $CONTAINER_NAME -- bash -c \
  "apt install --no-install-recommends software-properties-common dirmngr"`
  `" && wget -qO- ${CRAN}/marutter_pubkey.asc | "`
  `"tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc"`
  `" && add-apt-repository -u 'deb ${CRAN} focal-cran40/'"`
  `" && apt install -y r-base git libcurl4-openssl-dev libssl-dev libxml2-dev"

# Install tidyverse
lxc exec $CONTAINER_NAME -- R -e "install.packages('tidyverse')"

# Install devtools, remotes
lxc exec $CONTAINER_NAME -- R -e "install.packages(c('devtools', 'remotes'))"
