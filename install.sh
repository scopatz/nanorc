#!/bin/sh

wget -O /tmp/nanorc.zip https://github.com/scopatz/nanorc/archive/master.zip
if [ ! -d ~/.nano/ ]
then
    mkdir ~/.nano/
fi

cd ~/.nano/

unzip -o "/tmp/nanorc.zip"
mv nanorc-master/* ./
rm -rf nanorc-master
rm /tmp/nanorc.zip

if [ ! -f ~/.nanorc ]
then
    touch ~/.nanorc
fi

# add all includes from ~/.nano/nanorc if they're not already there
NANORC_FILE=~/.nanorc
while read inc; do
    if ! grep -q "$inc" "${NANORC_FILE}"; then
        echo "$inc" >> $NANORC_FILE
    fi
done < ~/.nano/nanorc
