#!/usr/bin/env bash
# Shellcheck the script
# Note: using bash for more power in testing (the final user doesn't need it).

# Functions

# Test Version
# Receives two parameters in x.x.x format.
# Returns true or false
# Sources:
#  https://unix.stackexchange.com/questions/285924/how-to-compare-a-programs-version-in-a-shell-script
#  https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash
test_version (){


currentver="$(gcc -dumpversion)"
requiredver="5.0.0"
 if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then 
        echo "Greater than or equal to 5.0.0"
 else
        echo "Less than 5.0.0"
 fi

###################

verlte() {
    [  "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

##################




}


# Tests

get_nano_version () {
  local tested_version=""
  # x.x.x
  local actual_version="nano --version | cut -d ' ' -f 4"
}

nano --version
shellcheck --version

# ....shellcheck -f diff *.sh | git apply | git commit -a -m "Shellcheck fast corrections"
shellcheck *.sh
