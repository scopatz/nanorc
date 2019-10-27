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


# check for unzip before we continue
if [ ! "$(command -v unzip)" ]; then
  echo 'unzip is required but was not found. Install unzip first and then run this script again.' >&2
  exit 1
fi

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

# Good start / docs
# start constants
# list and check the needed programs
# check parameters
# init main
# get the git
# updat/create the nanorc

NANORC_FILE=~/.nanorc

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
