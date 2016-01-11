#!/bin/bash

TESTDIR="/tmp/mod-on-test"
OLDDIR=`pwd`

# Create test files
[[ -d "$TESTDIR" ]] || mkdir $TESTDIR
cd $TESTDIR
for d in mon tue wed thu fri sat sun; do 
    touch --date="last $d" "file-$d"
done

cd $OLDDIR

# Check we find the test files
for d in mon tue wed thu fri sat sun; do 
    CMD="mod-on $d --dir $TESTDIR"
    echo "### Running: $CMD ###"
    $CMD
done
