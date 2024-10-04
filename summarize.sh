#!/bin/bash

for ZIP_FILE in dbg/*.zip
do
    PACKAGE=$(echo $ZIP_FILE | awk -F/ '{print $2}' | awk -F- '{print $1}')
    CHECKSUM=$(cat ${ZIP_FILE/\.zip/.sha256})
    echo "$PACKAGE:$CHECKSUM" >> LIB_CHECKSUM
done