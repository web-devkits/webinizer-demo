#!/bin/bash

#  Copyright (C) 2023 Intel Corporation. All rights reserved.
#  Licensed under the Apache License 2.0. See LICENSE in the project root for license information.
#  SPDX-License-Identifier: Apache-2.0

init_git() {
  # init git for the project if it's not managed by git yet
  if [[ ! -d ".git" ]]; then
    git init
    git add -A
    git commit -q -m "init for demo project"
  fi
}

remove_git() {
  # cleanup the old .git folder
  if [[ -d ".git" ]]; then
    rm -rf .git
  fi
}

cd native_projects
# remove all untracked files and get a clean repo for each download
git clean -fd

echo ">>>>>> Preparing demo projects"
echo
echo
echo ">>>>>> Downloading project tetris"
git clone https://github.com/PacktPublishing/Learn-WebAssembly.git
if [[ (-d "Learn-WebAssembly") && (-d "tetris") ]]; then
  cd tetris
  remove_git
  cp -r ../Learn-WebAssembly/chapter-08-tetris/output-native/. .
  init_git
  cd ..
  rm -rf Learn-WebAssembly
  echo ">>>>>> Project tetris downloaded"
fi

echo
echo
echo ">>>>>> Downloading project gnuplot"
curl -O https://versaweb.dl.sourceforge.net/project/gnuplot/gnuplot/5.4.3/gnuplot-5.4.3.tar.gz
if [[ (-f "gnuplot-5.4.3.tar.gz") && (-d "gnuplot") ]]; then
  tar -xf gnuplot-5.4.3.tar.gz
  if [ -d "gnuplot-5.4.3" ]; then
    cd gnuplot
    remove_git
    cp -r ../gnuplot-5.4.3/. .
    init_git
    cd ..
    rm -rf gnuplot-5.4.3
  fi
  rm -rf gnuplot-5.4.3.tar.gz
  echo ">>>>>> Project gnuplot downloaded"
fi

echo
echo
echo ">>>>>> Downloading project ncurses"
curl -O https://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
if [[ (-f "ncurses-6.1.tar.gz") && (-d "ncurses") ]]; then
  tar -xf ncurses-6.1.tar.gz
  if [ -d "ncurses-6.1" ]; then
    cd ncurses
    remove_git
    cp -r ../ncurses-6.1/. .
    # add patch to back-port some fixes from newer versions
    if [[ -f "../../patches/ncurses.patch" ]]; then
      patch -p1 < ../../patches/ncurses.patch
    fi
    init_git
    cd ..
    rm -rf ncurses-6.1
  fi
  rm -rf ncurses-6.1.tar.gz
  echo ">>>>>> Project ncurses downloaded"
fi

echo
echo
echo ">>>>>> Downloading project 2048"
git clone https://github.com/alewmoose/2048-in-terminal
if [[ (-d "2048-in-terminal") && (-d "2048") ]]; then
  cd 2048
  remove_git
  cp -r ../2048-in-terminal/. .
  # add patch for it
  if [[ -f "../../patches/2048.patch" ]]; then
    patch -p1 < ../../patches/2048.patch
    git add -A
    git commit -q -m "init for demo project"
  fi
  cd ..
  rm -rf 2048-in-terminal
  echo ">>>>>> Project 2048 downloaded"
fi

echo
echo
echo ">>>>>> Downloading project FFmpeg"
# TODO. use git clone (with git info) or download release package directly (no git info)?
curl https://codeload.github.com/FFmpeg/FFmpeg/tar.gz/refs/tags/n5.0.2 -o FFmpeg-n5.0.2.tar.gz
if [[ (-f "FFmpeg-n5.0.2.tar.gz") && (-d "FFmpeg") ]]; then
  tar -xf FFmpeg-n5.0.2.tar.gz
  if [ -d "FFmpeg-n5.0.2" ]; then
    cd FFmpeg
    remove_git
    cp -r ../FFmpeg-n5.0.2/. .
    init_git
    cd ..
    rm -rf FFmpeg-n5.0.2
  fi
  rm -rf FFmpeg-n5.0.2.tar.gz
  echo ">>>>>> Project FFmpeg downloaded"
fi

echo
echo
echo ">>>>>> Downloading project x264"
git clone https://github.com/ffmpegwasm/x264.git x264-lib
if [[ (-d "x264-lib") && (-d "x264") ]]; then
  cd x264
  remove_git
  cp -r ../x264-lib/. .
  # include .webinizer to track by git
  git add -A
  git commit -q -m "init for demo project"
  cd ..
  rm -rf x264-lib
  echo ">>>>>> Project x264 downloaded"
fi

echo
echo
echo ">>>>>> Downloading project snake"
git clone https://github.com/udacity/CppND-Capstone-Snake-Game.git
if [[ (-d "CppND-Capstone-Snake-Game") && (-d "snake") ]]; then
  cd snake
  remove_git
  cp -r ../CppND-Capstone-Snake-Game/. .
  # include .webinizer to track by git
  git add -A
  git commit -q -m "init for demo project"
  cd ..
  rm -rf CppND-Capstone-Snake-Game
  echo ">>>>>> Project snake downloaded"
fi

# back to the root directory
cd ..

echo
echo
echo ">>>>>> All demo projects downloaded"