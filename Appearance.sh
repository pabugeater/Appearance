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
done
