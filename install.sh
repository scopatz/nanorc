wget -O /tmp/nanorc.zip https://github.com/scopatz/nanorc/archive/master.zip
if [ ! -d ~/.nano/ ]
then
    mkdir ~/.nano/
fi

cd ~/.nano/

unzip -o "/tmp/nanorc.zip"
mv nanorc-master/* ./
rm -rf nanorc-master

if [ ! -f ~/.nanorc ]
then
    touch ~/.nanorc
fi

cat ~/.nano/nanorc >> ~/.nanorc
sort -u ~/.nanorc > /tmp/nanorc2
cat /tmp/nanorc2 > ~/.nanorc
