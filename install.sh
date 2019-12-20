#!/bin/sh

# IMPROVED NANO SYNTAX HIGHLIGHTING FILES
# Get nano editor better to use and see.

# Copyright (C) 2014+ Anthony Scopatz et al.
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# https://spdx.org/licenses/GPL-3.0-or-later.html

# Help:
# Sed: http://www.grymoire.com/Unix/Sed.html

# Bash Variables
# Ativate or not the erros (1=activated)
OPTERR=1
# Separator (useful for simulate arrays)
G_IFS=" "
# Debugging variables
set -e
set -x

# Global Variables
G_VERSION="2019.10.17"
G_DEPS="unzip sed"
G_FILE="${HOME}/.nanorc"
G_REPO_MASTER="https://github.com/scopatz/nanorc/archive/master.zip"
G_REPO_RELEASE="https://github.com/scopatz/nanorc/archive/${G_VERSION}.zip"
G_NANO_VERSION="4.6.0"
G_NANO_NRC_DIR=""
unset G_LITE G_UNSTABLE G_VERBOSE G_DIR G_THEME

# Exit Values Help
# 0 - OK
# 1 - Big problem

# Functions

# Show the usage/help
f_menu_usage(){
  printf "\n Usage: %s [ -h|-l|-u|-v|-w ] [ -d DIR ] [ -t THEME ]" "$0"
  printf "\n"
  printf "\n IMPROVED NANO SYNTAX HIGHLIGHTING FILES"
  printf "\n Get nano editor better to use and see."
  printf "\n"
  printf "\n -h    Show help or usage."
  printf "\n -l    Activate lite installation."
  printf "\n         We will take account your existing .nanorc files."
  printf "\n -u    Use the unstable branch (master)."
  printf "\n -v    Show version, license and other info."
  printf "\n -w    Turn the script more verbose, often to tests."
  printf "\n"
  printf "\n -d DIR"
  printf "\n       Give other directory for installation."
  printf "\n         Default: ~/.nano/nanorc/"
  printf "\n"
  printf "\n -t THEME"
  printf "\n       Give other theme for installation."
  printf "\n         Default: scopatz"
  printf "\n         Options: nano, scopatz, tpro"

  exit 1
}

# Show version, license and other file.
f_menu_version(){
  printf "\n IMPROVED NANO SYNTAX HIGHLIGHTING FILES"
  printf "\n Version %s" "${G_VERSION}"
  printf "\n"
  printf "\n Copyright (C) 2014+ Anthony Scopatz et al."
  printf "\n License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>."
  printf "\n This is free software: you are free to change and redistribute it."
  printf "\n There is NO WARRANTY, to the extent permitted by law."
  printf "\n"
  printf "\n Written by Anthony Scopatz and others."
  printf "\n"
  printf "\n For bugs report, please fill an issue at https://github.com/scopatz/nanorc"

  exit 0
}

# Check dependencies
f_check_deps(){
  DEPS_MISSED=""

  # If there isn't the dependency the $DEPS_MISSED will be populated.
  for DEP in $G_DEPS; do
    if [ ! "$(command -v "$DEP")" ]; then
      DEPS_MISSED="${DEP} ${DEPS_MISSED}"
    fi
  done

  # Error if $DEPS_MISSED is populated.
  if [ "$DEPS_MISSED" = "" ]; then
    return 0
  else
    for DEP in $DEPS_MISSED; do
      printf "\n The '%s' program is required but was not found. Install '${DEP}' first and then run this script again." "${DEP}" >&2
    done
    return 1
  fi
}

# Set IFS
f_set_ifs(){
  temp=$IFS
  IFS=$G_IFS
  G_IFS=temp
}

# Set Variable
# Receives two parameters:
#  1. the variable name
#  2. a value
# Sources:  https://unix.stackexchange.com/questions/23111/what-is-the-eval-command-in-bash
f_set_variable(){
  varname=$1
  varvalue=""
  shift

  # Because 'sh' do not recognize indirect expansion "${!#}" like bash.
  # Alert! The backslash "\" is needed!
  eval varvalue="\$${varname}"

  if [ -z "${varvalue}" ]; then
    eval "$varname=${*}"
  else
    printf "\n Error: '%s' is already set." "${varname}"
    usage
  fi
}

# Get Nanorc's
# Get the not installed Nano's files.
# This function is only called in lite installation.
# Sources:
# http://mywiki.wooledge.org/ParsingLs
# https://unix.stackexchange.com/questions/70614/how-to-output-only-file-names-with-spaces-in-ls-al
# https://stackoverflow.com/questions/25156902/how-to-check-if-find-command-didnt-find-anything-bash-opensus
# https://stackoverflow.com/questions/59110820/find-operator-cant-go-up-in-directory
f_get_nanorcs(){
  lite=""

  if cd nanorc/; then
    printf "\n Error: Cannot open or access '%s' directory." "nanorc/"
    exit 1
  fi

  for file in *; do
    [ -e "$file" ] || continue

    if [ -z "$(find "../original/" -name "$file")" ]; then
      lite="$(printf "%s\ninclude %s" "$lite" "$file")"
    fi

  done
  cd ..

  return "$lite"
}

# Install
# Sources:
#  https://www.cyberciti.biz/faq/download-a-file-with-curl-on-linux-unix-command-line/
f_install(){
  temp="temp.zip"
  begin="# BEGIN"
  end="# END"
  theme="${G_DIR}/themes/${G_THEME}/"

  if cd "$HOME"; then
    printf "\n Error: Cannot open or access '%s' directory." "${HOME}"
    exit 1
  fi

  mkdir -p "$G_DIR"

  if [ ! -d "$G_DIR" ]; then
    printf "\n Error: '%s' is not a directory or cannot be accessed or created." "${G_DIR}"
    usage
  fi

  if [ "$G_UNSTABLE" = true ]; then
    curl -L -o $temp $G_REPO_MASTER
  else
    curl -L -o $temp $G_REPO_RELEASE
  fi

  unzip -u $temp
  rm $temp

  if [ "$G_UNSTABLE" = true ]; then
    mv "nanorc-master/*" "$G_DIR"
    rm -rf "nanorc-master"
  else
    mv "nanorc-${G_VERSION}" "$G_DIR"
    rm -rf "nanorc-${G_VERSION}"
  fi

  if [ ! -d "$theme" ]; then
    printf "\n Error: '%s' is not a theme or cannot be accessed." "${G_THEME}"
    usage
  fi

  touch "$G_FILE"

  printf "\n %s \n %s \n" "$begin" "$end" >> "$G_FILE"

  if [ "$G_LITE" = true ]; then
    sed -n -i.bkp '/'"$begin"'/,/'"$end"'/ {
        /'"$begin"'/n # skip over the line that has "$begin" on it
        /'"$end"'/ !{ # skip over the line that has "$end" on it
          s/*//
          r '"${theme}/config"'
          r f_get_nanorc
          d
        }
    }' "$G_FILE"
  else
    sed -n -i.bkp '/'"$begin"'/,/'"$end"'/ {
        /'"$begin"'/n # skip over the line that has "$begin" on it
        /'"$end"'/ !{ # skip over the line that has "$end" on it
          s/*//
          r '"${theme}/config"'
          # TODO: add a line with only "include /nanorc/*"
          d
        }
    }' "$G_FILE"
    _update_nanorc
  fi
}

# big change: update all nanorc's
# big change: install "only" the themed nanorc files and .nanorc

# next:

# ============================
#
# MAIN / Init of script
#
# =============================

# Pre-check
f_set_ifs
f_check_deps && exit 1

# Menu
# Getopts: https://www.shellscript.sh/tips/getopts/
while getopts "d:hlt:uvw" c; do
  case $c in
    d) f_set_variable G_DIR "$OPTARG" ;;
    h) f_menu_usage ;;
    l) f_set_variable G_LITE true ;;
    t) f_set_variable G_THEME "$OPTARG" ;;
    u) f_set_variable G_UNSTABLE true ;;
    v) f_menu_version ;;
    w) f_set_variable G_VERBOSE true ;;
    *) f_menu_usage ;;
  esac
done

# Set defaults if there is not.
[ -z "$G_DIR" ] && G_DIR="${HOME}/.nano/nanorc/"
[ -z "$G_THEME" ] && G_THEME="scopatz"

# Set verbose
if [ "$G_VERBOSE" = true ]; then
  set -x
fi

# Install
f_install

# Post-check
f_set_ifs
exit 0
