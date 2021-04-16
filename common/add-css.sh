#!/bin/bash

# <link rel=stylesheet href='print-notices.css' type='text/css'>

if test "x$1" = "x"
then
    echo "Usage: $0 print-file.html"
    exit 0
fi

PRINTFILE="$1"

perl -i -pe 's/<title/<link rel=stylesheet href="print-notices.css" type="text\/css">\n<title/;' "$PRINTFILE"



