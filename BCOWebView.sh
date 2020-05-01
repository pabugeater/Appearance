#!/bin/bash

#  BCOWebView.bash, Ver 1.fixme
#
#  Created by Steve Lidie on 12/12/18.
#  Copyright © 2018 Steve Lidie. All rights reserved.

if [ $# -lt 4 ]; then
echo "Usage: BCOwebView.sh srcFolder destFolder version file1 ... "
    exit 1
fi

src=$1
shift
dest=$1
shift
v=$1
shift

for f in $*; do
    echo Exporting $src/$f '-->' $dest/$f '...'
    /usr/bin/perl -ne "s/1\.fixme/$v/; print" $src/$f > $dest/$f
    if [ $f = "BCOwebView.html" ] && [ $FIX_BCOWEBVIEW_HTML = "YES" ] ; then
        out="BCOwebView.newHTML"
        echo Fixup BCOwebView.html to get BCOwebView.js from BigCatOs.com ...
        /usr/bin/perl -pe 's/src=\"BCOwebView.js\"/src=\"https:\/\/www\.bigcatos\.com\/BigCatOs\/js\/BCOwebView\.js\"/' $dest/$f > $dest/$out
        if [ $? = 0 ] ; then
            mv $dest/$out $dest/$f
            echo Fixup complete
        else
            echo Fixup $out subsitution failed: $?
            exit 3
        fi

    fi
done
