#!/bin/sh
# Shellcheck the script

nano --version

shellcheck install.sh && exit 1
