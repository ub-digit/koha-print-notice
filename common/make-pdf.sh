#!/bin/bash

# chromium-browser --headless --disable-gpu --print-to-pdf=file1.pdf http://www.example.com/

if test "x$2" = "x"
then
    echo "Usage: $0 print-file.html print-file.pdf"
    exit 0
fi

HTMLFILE="$1"
PDFFILE="$2"

google-chrome --headless --no-sandbox --disable-gpu --print-to-pdf="$PDFFILE" "$HTMLFILE"
