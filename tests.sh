#!/bin/sh
# Shellcheck the script

nano --version
shellcheck --version

# shellcheck -f diff *.sh | git apply | git commit -a -m "Shellcheck fast corrections"
shellcheck *.sh
