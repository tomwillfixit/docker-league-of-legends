#!/bin/bash

set -e

rm -rf wine wine-staging ||true

git clone https://github.com/wine-mirror/wine.git
git clone https://github.com/wine-staging/wine-staging.git
cd wine
git checkout 053a7e225c8190fd7416b3f3c3186f1ac230eeb3

cd ..

cd wine-staging
git checkout 60e4f489f69180a249c7c1af415671e081f89c9b

cd ..

echo "Ready"
