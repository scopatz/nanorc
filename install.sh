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

# Global Variables
G_VERSION="2019.10.17"
G_DEPS="unzip sed"
G_REPO_MASTER="https://github.com/scopatz/nanorc/archive/master.zip"
G_REPO_RELEASE="https://github.com/scopatz/nanorc/archive/${G_VERSION}.zip"
unset G_DIR G_LITE G_VERBOSE G_UNSTABLE G_FILE

# Exit Values Help
# 0 - OK
# 1 - Big problem

# Functions

# Show the usage/help
f_menu_usage(){
  echo "Usage: $0 [ -d | -h | -l | -t | -u | -v ] [ -f FILE ]"
  echo
  echo "IMPROVED NANO SYNTAX HIGHLIGHTING FILES"
  echo "Get nano editor better to use and see."
  echo
  echo "-d    Give other directory for installation."
  echo "        Default: ~/.nano/nanorc/"
  echo "-h    Show help or usage."
  echo "-l    Activate lite installation."
  echo "        We will take account your existing .nanorc files."
  echo "-t    Turn the script more verbose, often to tests."
  echo "-u    Use the unstable branch."
  echo "-v    Show version, license and other info."
  echo "-f FILE"
  echo "      The path of other file instead of the default .nanorc file."

  exit 1
}

# Show version, license and other file.
f_menu_version(){
  echo "IMPROVED NANO SYNTAX HIGHLIGHTING FILES"
  echo "Version ${G_VERSION}"
  echo
  echo "Copyright (C) 2014+ Anthony Scopatz et al."
  echo "License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>."
  echo "This is free software: you are free to change and redistribute it."
  echo "There is NO WARRANTY, to the extent permitted by law."
  echo
  echo "Written by Anthony Scopatz and others."
  echo
  echo "For bugs report, please fill an issue at https://github.com/scopatz/nanorc"

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
      echo "The '${DEP}' program is required but was not found. Install '${DEP}' first and then run this script again." >&2
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
  shift

  # Because 'sh' do not recognize indirect expansion "${!#}"
  eval varvalue="$"$varname

  if [ -z "${varvalue}" ]; then
    eval "$varname=${@}"
  else
    echo "Error: ${varname} already set."
    usage
  fi
}



_update_nanorc(){
  touch ~/.nanorc

  # add all includes from ~/.nano/nanorc if they're not already there
  while read -r inc; do
      if ! grep -q "$inc" "${NANORC_FILE}"; then
          echo "$inc" >> "$NANORC_FILE"
      fi
  done < ~/.nano/nanorc
}

_update_nanorc_lite(){
  sed -i '/include "\/usr\/share\/nano\/\*\.nanorc"/i include "~\/.nano\/*.nanorc"' "${NANORC_FILE}"
}




# Install
# Sources: https://www.cyberciti.biz/faq/download-a-file-with-curl-on-linux-unix-command-line/
f_install(){
  temp="temp.zip"
  cd ~

  mkdir -p $G_DIR

  if [ ! -d "G_DIR" ]; then
    echo "Error: ${G_DIR} is not a directory or cannot be accessed or created."
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
    mv "nanorc-master/*" $G_DIR
    rm -rf "nanorc-master"
  else
    mv "nanorc-${G_VERSION}" $G_DIR
    rm -rf "nanorc-${G_VERSION}"
  fi

  if [ "$G_LITE" = true ]; then
    _update_nanorc_lite
  else
    _update_nanorc
  fi
}

# updat/create the nanorc

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
while getopts "d:hltvf:" c
  case $c in
    d) f_set_variable G_DIR $OPTARG ;;
    h) f_menu_usage ;;
    l) f_set_variable G_LITE true ;;
    t) f_set_variable G_VERBOSE true ;;
    u) f_set_variable G_UNSTABLE true
    v) f_menu_version ;;
    f) f_set_variable G_FILE $OPTARG ;;
    *) f_menu_usage ;;
  esac
done

# Set defaults if there is not.
[ -z "$G_FILE" ] && G_FILE="~/.nanorc"
[ -z "$G_DIR" ] && G_DIR="~/.nano/nanorc/"

# Set verbose
if [ "$G_VERBOSE" = true ]; then
  set -x
fi

# Install
f_install

# Post-check
f_set_ifs
exit 0
