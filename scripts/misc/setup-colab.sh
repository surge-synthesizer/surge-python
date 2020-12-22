#!/bin/bash
# These are build instructions for Google Colab (Ubuntu 18.04)

apt-get -qq update

# Install prerequisites from Surge
apt-get -qq install build-essential libcairo-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util-dev

# We need cmake >= 3.15
apt-get -qq remove cmake
apt -qq autoremove
apt-get -qq install -y apt-transport-https ca-certificates gnupg software-properties-common wget
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add -
apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
apt-get -qq update
apt-get -qq install cmake

# Clone surge from master, and build
git clone --quiet https://github.com/surge-synthesizer/surge.git
cd surge
git submodule --quiet update --init --recursive
/usr/bin/cmake -Bbuildpy -DBUILD_SURGE_PYTHON_BINDINGS=TRUE -DCMAKE_BUILD_TYPE=Release

# Specifically build surgepy integration
# We use colab specific paths to find -lpython, but please modify
# this if your python.so is in another directory.

LD_LIBRARY_PATH="/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/:$LD_LIBRARY_PATH" /usr/bin/cmake --build buildpy --config Release --target surgepy
/usr/bin/cmake --build buildpy --target install-resources-local
