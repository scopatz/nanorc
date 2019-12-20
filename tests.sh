#!/usr/bin/env bash
# Shellcheck the script
# Note: using bash for more power in testing (the final user doesn't need it).

# Global Variables
readonly G_NANO_VERSION="4.6.0"
readonly G_SHELLCHECK_VERSION="0.6.0"

# Functions

# Compare Version
# Compare the first version (x.x.x format) against second one.
# Returns 0 if $1 => $2, 1 otherwise.
# In error returns 2.
# Sources:
#  https://unix.stackexchange.com/questions/285924/how-to-compare-a-programs-version-in-a-shell-script
#  https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash
# Test table:
#  req   | get   | test  | res
# -------+-------+-------+-----------
#  2.0.0 | 1.0.0 | 1.0.0 | true  = 0
#  1.0.0 | 2.0.0 | 1.0.0 | false = 1
#  0.5.3 | 0.5.3 | 0.5.3 | true  = 0
f_compare_version(){
  local required_v="$1"
  local getted_v="$2"
 
  # First: check if equal
  if [ "$required_v" = "$getted_v" ]; then
    return 0;
  fi
  
  # Second: check if greater or lesser
  local test_v
  test_v="$(printf "%s\n%s" "$required_v" "$getted_v" | sort -V | head -n 1)"
  case $test_v in
    $getted_v) return 0 ;;
    $required_v) return 1 ;;
    *) return 2 ;;
  esac
}

# Test Functions

f_test_nano_version() {
  local version
  version="$(nano --version | cut -d ' ' -f 4)"
  return "$(f_compare_version $G_NANO_VERSION $version)"
}

f_test_shellcheck_version() {
  local version
  version="$(nano --version | cut -d ' ' -f 8)"
  return "$(f_compare_version $G_SHELLCHECK_VERSION $version)"
}

printf "Nano Version ok? %s" f_test_nano_version
printf "Shellcheck Version ok? %s" f_test_shellcheck_version
# ....shellcheck -f diff *.sh | git apply | git commit -a -m "Shellcheck fast corrections"
shellcheck -- *.sh
