#!/bin/bash

script_dir="$(dirname "$(readlink -f "$0")")"
source "$script_dir/print-notice.conf"

CODE=${1^^} # First argument to uppercase TODO: Arg validation?
DIR="$print_notice_data_dir/$1"
COMMON="$script_dir/common"
ARCHIVE="$DIR/archive"
mkdir -p "$DIR"
chmod 777 "$DIR"

koha-shell $koha_instance -c "(cd \"$koha_path\"; misc/cronjobs/gather_print_notices.pl $DIR --html --letter_code=$CODE)"

cd $DIR
cp "$COMMON"/print-notices.css "$DIR"/
cp "$COMMON"/gu-bw-header-sv.png "$DIR"/
cp "$COMMON"/gu-bw-header-en.png "$DIR"/
cp "$COMMON"/make-pdf.sh "$DIR"/
cp "$COMMON"/add-css.sh "$DIR"/

# ls sorts in alphabetical order. Take the last one.
NOTICEFILE=$(ls notices_$CODE*.html | tail -n 1)
if test "x$NOTICEFILE" = "x"
then
    echo "NOFILE"
    exit
fi

PDFFILE=$(basename "$NOTICEFILE" .html).pdf

# Add CSS-link
$DIR/add-css.sh "$NOTICEFILE"

# Inject empty message to remove page footer on last page
perl -i -pe 's,</body>,<div class="message"></div></body>,g' "$NOTICEFILE"

# Make PDF
$DIR/make-pdf.sh "$NOTICEFILE" "$PDFFILE"

mkdir -p "$ARCHIVE"
mv "$NOTICEFILE" "$ARCHIVE"/
echo "$PDFFILE"
