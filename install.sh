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

# Help:
# https://www.shellscript.sh/tips/getopts/


# Bash Variables
# Ativate or not the erros (1=activated)
OPTERR=1
# Separator (useful for simulate arrays)
G_IFS=" "

# Global Variables
G_VERSION="1.0.0"
G_DEPS="unzip sed wget"
G_LITE=false
G_FILE="~/.nanorc"

# Exit Values Help
# 0 - OK
# 1 - Small problem
# 2 - Big problem

# Functions

# Show the usage/help
f_menu_usage(){
  echo "Usage: $0 [ -l|-v|-h ] [ -f FILE ]"
  echo "IMPROVED NANO SYNTAX HIGHLIGHTING FILES"
  echo "Get nano editor better to use and see."
  echo
  echo "-l    Activate lite installation."
  echo "       We will take account your existing .nanorc files."
  echo "-v    Show version, license and other info."
  echo "-h    Show help or usage."
  echo "-f FILE"
  echo "      Other file instead of the default .nanorc file."

  exit 2
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


# check parameters with set variable
# made the script more or less verbose

# init main
# get the git
# updat/create the nanorc

# ============================
#
# MAIN / Init of script
#
# =============================

f_set_ifs
f_check_deps && exit 2

while getopts "lf:vh?" c
  case $c in
    l) G_LITE=true;;
    f) G_FILE=$OPTARG;;
    v) f_menu_version ;;
    h|?|*) f_menu_usage ;;
  esac
done

_fetch_sources

if [ $G_LITE ];
then
  _update_nanorc_lite
else
  _update_nanorc
fi

f_set_ifs
