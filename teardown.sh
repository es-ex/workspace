#!/usr/bin/env bash

shopt -s extglob
rm -rf !(*.sh|LICENSE|README.md)
