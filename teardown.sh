#! /bin/bash

shopt -s extglob
rm -rf !(*.sh|LICENSE|README.md)
