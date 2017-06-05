#!/usr/bin/env bash

function _fetch_sources() {
  wget -O /tmp/nanorc.zip https://github.com/gmcclins/nanorc/archive/master.zip
  if [ ! -d ~/.nano/ ]
  then
    mkdir ~/.nano/
  fi

  cd ~/.nano/

  unzip -o "/tmp/nanorc.zip"
  mv nanorc-master/ ~/.nano/nanorc/
  rm /tmp/nanorc.zip
}

function _update_nanorc() {
  if [ ! -f ~/.nanorc ]
  then
      touch ~/.nanorc
  fi

  # add all includes from ~/.nano/nanorc/nanorc if they're not already there
  while read inc; do
      if ! grep -q "$inc" "${NANORC_FILE}"; then
          echo "$inc" >> $NANORC_FILE
      fi
  done < ~/.nano/nanorc/nanorc
}

function _update_nanorc_lite() {
  sed -i '/include "\/usr\/share\/nano\/\*\.nanorc"/i include "~\/.nano\/*.nanorc"' "${NANORC_FILE}"
}

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
if [[ $UPDATE_LITE ]]; then
  _update_nanorc_lite;
else
  _update_nanorc;
fi
