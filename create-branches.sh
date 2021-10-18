#!/usr/bin/env bash

set -vxe

if command -v brew &>/dev/null; then
  # use gsed if installed
  PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:${PATH}"
fi

branches=(
  pre-5.0
  pre-4.5
  pre-2.9.5
  pre-2.5.3
  pre-2.3.2
  pre-2.2.99
  pre-2.1.5
)

# git clone https://github.com/rasa/nanorc

# cd nanorc

# git remote remove upstream || true
# git remote add upstream https://github.com/scopatz/nanorc

# git fetch upstream

# https://stackoverflow.com/a/42332860/1432614

# ensures current branch is master
git checkout master

# pulls all new commits made to upstream/master
# git pull upstream master

# this will delete all your local changes to master
# git reset --hard upstream/master

for branch in "${branches[@]}"; do
  git branch -D "${branch}" || true
done

# sed will convert symlinks to regular files, so ignore them
mapfile -t nanos <<<"$(find . -not -type l -name '*.nanorc' | sort)"

git checkout -b pre-5.0
sed -E -i.bak -e 's/\bcolor\s+purple\b/color brightmagenta/' "${nanos[@]}"
git commit -am "fix: pre-5.0: change 'brightred' to 'brightmagenta'"

sed -E -i.bak -e 's/\bcolor\s+latte\b/color brightred/' "${nanos[@]}"
git commit -am "fix: pre-5.0: change 'latte' to 'brightred'"

git checkout -b pre-4.5
sed -E -i.bak -e 's/^(\s*tabgives\b)/# \1/' "${nanos[@]}"
git commit -am "fix: pre-4.5: comment out 'tabgives'"

git checkout -b pre-2.9.5
sed -E -i.bak -e 's/color\s+normal\b/color white/' "${nanos[@]}"
sed -E -i.bak -e 's/color\s+,normal\b/color ,white/' "${nanos[@]}"
git commit -am "fix: pre-2.9.5: change 'normal' to 'white'"

sed -E -i.bak -e 's/color\s+brightnormal\b/color brightwhite/' "${nanos[@]}"
git commit -am "fix: pre-2.9.5: change 'brightnormal' to 'brightwhite'"

git checkout -b pre-2.5.3
sed -E -i.bak -e 's/^(\s*comment\b)/# \1/' "${nanos[@]}"
git commit -am "fix: pre-2.5.3: comment out 'comment'"

git checkout -b pre-2.3.2
sed -E -i.bak -e 's/^(\s*linter\b)/# \1/' "${nanos[@]}"
git commit -am "fix: pre-2.3.2: comment out 'linter'"

git checkout -b pre-2.2.99
sed -E -i.bak -e 's/^(\s*magic\b)/# \1/' "${nanos[@]}"
git commit -am "fix: pre-2.2.99: comment out 'magic'"

git checkout -b pre-2.1.5
sed -E -i.bak -e 's/^(\s*header\b)/# \1/' "${nanos[@]}"
git commit -am "fix: pre-2.1.5: comment out 'header'"

sed -E -i.bak -e 's/^(\s*syntax\s+)([^"\s]+)(\s.*)/\1"\2"\3/' "${nanos[@]}"
git commit -am "fix: pre-2.1.5: add quotes around syntax names"

sed -E -i.bak -e 's/^(\s*icolor\s+cyan\s+.*Add-AppPackage)/# \1/' "${nanos[@]}"
git commit -am "fix: pre-2.1.5: comment out string causing out-of-memory"

# +++ b/Rnw.nanorc
# -color blue "([a-zA-Z0-9_\-$\.]*)\("
# +color blue "([a-zA-Z0-9_$\.-]*)\("
sed -E -i.bak -e 's/a-zA-Z0-9_\\-\$\\\./a-zA-Z0-9_$\\.-/' "${nanos[@]}"

# +++ b/jade.nanorc
# +++ b/pug.nanorc
# -icolor brightgreen "https?:\/\/(www\.)?[a-zA-Z0-9@%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)" "_blank"
# +icolor brightgreen "https?:\/\/(www\.)?[a-zA-Z0-9@%._\+~#=]+\.[a-z]+\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)" "_blank"
sed -E -i.bak -e 's/]\{2,256\}\\/]+\\/' "${nanos[@]}"
sed -E -i.bak -e 's/]\{2,6\}\\b/]+\\b/' "${nanos[@]}"

# +++ b/toml.nanorc
# -color ,red "^[[:space:]]*\[\..*?\]"
# +color ,red "^[[:space:]]*\[\..*"
sed -E -i.bak -e 's/(color ,red .*\.\.\*)\?\\]/\1/' "${nanos[@]}"

# +++ b/x11basic.nanorc
# -icolor brightwhite "\<[A-Z_][A-Za-z0-9_]*(|\$|\%|\&|\||\(\))\>"
# +icolor brightwhite "\<[A-Z_][A-Za-z0-9_]*(\$|\%|\&|\||\(\))\>"
sed -E -i.bak -e 's/(icolor\s+brightwhite.*\*\()\|/\1/' "${nanos[@]}"

# +++ b/yaml.nanorc
# -color red "(^|\s+).*+\s*:(\s|$)"
# +color red "(^|\s+).*\+\s*:(\s|$)"
sed -E -i.bak -e 's/(color\s+red\s+.*\)\.\*)\+/\1\\+/' "${nanos[@]}"
git commit -am "fix: pre-2.1.5: fix bad regexes"

# git checkout master

# take care, this will delete all your changes on your forked master
# git push --force origin master

for branch in "${branches[@]}"; do
  git checkout "${branch}"
  git push --force -u origin "${branch}"
done

git checkout master
