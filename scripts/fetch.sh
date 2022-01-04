#!/usr/bin/env bash
set -e

# Download Shakespeare
mkdir -p download
mkdir -p opensourceshakespeare
cd download
curl -LO http://www.opensourceshakespeare.org/downloads/oss-textdb.zip
unzip -u oss-textdb.zip
# Remove headers
for FILENAME in *.txt; do
  sed -e '1d' "$FILENAME" > "../opensourceshakespeare/$FILENAME"
done
cd -

