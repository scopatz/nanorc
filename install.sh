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

# Bash Variables
# Ativate or not the erros (1=activated)
OPTERR=1
# Separator (useful for simulate arrays)
IFS=" "

# Global Variables
G_NANORC_FILE="~/.nanorc"
G_DEPS="unzip sed wget"

# Functions

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

_fetch_sources(){
  wget -O /tmp/nanorc.zip https://github.com/scopatz/nanorc/archive/master.zip
  mkdir -p ~/.nano/

  cd ~/.nano/ || exit
  unzip -o "/tmp/nanorc.zip"
  mv nanorc-master/* ./
  rm -rf nanorc-master
  rm /tmp/nanorc.zip
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


# check parameters
# init main
# get the git
# updat/create the nanorc
f_check_deps

case "$1" in
 -l|--lite)
   UPDATE_LITE=1;;
 -h|--help)
   echo "Install script for nanorc syntax highlights"
   echo "Call with -l or --lite to update .nanorc with secondary precedence to existing .nanorc includes"
 ;;
esac

_fetch_sources;
if [ $UPDATE_LITE ];
then
  _update_nanorc_lite
else
  _update_nanorc
fi
