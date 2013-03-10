#!/bin/bash
wget -nc http://www.opensourceshakespeare.org/downloads/oss-textdb.zip
unzip -u oss-textdb.zip
mkdir -p /tmp/opensourceshakespeare
for FILENAME in `ls *.txt`
do
  sed '1d' $FILENAME > /tmp/opensourceshakespeare/$FILENAME
done

