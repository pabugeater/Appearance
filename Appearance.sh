#!/bin/bash

#  Appearance.bash, Ver 1.fixme
#
#  Created by Steve Lidie on 12/12/18.
#  Copyright © 2018 Steve Lidie. All rights reserved.

if [ $# -lt 4 ]; then
echo "Usage: Appearance.sh srcFolder destFolder version file1 ... "
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
    if [ $f = "Appearance.html" ] && [ $FIX_APPEARANCE_HTML = "YES" ] ; then
        out="Appearance.newHTML"
        echo Fixup Appearance.html to get com_bigcatos_Appearance.js from BigCatOs.com ...
        /usr/bin/perl -pe 's/src=\"com_bigcatos_Appearance.js\"/src=\"https:\/\/www\.bigcatos\.com\/BigCatOs\/js\/com_bigcatos_Appearance\.js\"/' $dest/$f > $dest/$out
        if [ $? = 0 ] ; then
            mv $dest/$out $dest/$f
            echo Fixup complete
        else
            echo Fixup $out subsitution failed: $?
            exit 3
        fi

    fi
done
