#!/usr/bin/env bash

NANO_VER=$(nano --version 2>/dev/null | awk '/version/ {print $4}' | awk -F . '{printf("%d%02d%02d", $1,  $2, $3)}')

if [[ -z "${NANO_VER}" ]]; then
  printf "Cannot determine nano's version\\n" >&2
  exit 1
fi

printf 'Found nano version %s\n' "$(nano --version 2>/dev/null | awk '/version/ {print $4}')"

if ((NANO_VER < 20105)); then
  NANO_BRANCH='pre-2.1.5'
elif ((NANO_VER < 20299)); then
  NANO_BRANCH='pre-2.2.99'
elif ((NANO_VER < 20302)); then
  NANO_BRANCH='pre-2.3.2'
elif ((NANO_VER < 20503)); then
  NANO_BRANCH='pre-2.5.3'
elif ((NANO_VER < 20905)); then
  NANO_BRANCH='pre-2.9.5'
elif ((NANO_VER < 40500)); then
  NANO_BRANCH='pre-4.5'
elif ((NANO_VER < 50000)); then
  NANO_BRANCH='pre-5.0'
else
  NANO_BRANCH='master'
fi

printf 'Switching to branch %s\n' "${NANO_BRANCH}"

git checkout "${NANO_BRANCH}"
