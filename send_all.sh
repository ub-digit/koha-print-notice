#!/bin/bash

source /etc/profile

script_dir="$(dirname "$(readlink -f "$0")")"
source "$script_dir/print-notice.conf"

RECEIVER="vaktm@ub.gu.se"
SUBJECT="Dagens pappersbrev"
BODYFILE="$script_dir/msgbody.txt"


RESULTHOLD=$($script_dir/gather-print-notice.sh hold)
RESULTODUE=$($script_dir/gather-print-notice.sh odue)
RESULTODUE2=$($script_dir/gather-print-notice.sh odue2)
RESULTODUE3=$($script_dir/gather-print-notice.sh odue3)

ATTACHSTR=""
if test "$RESULTHOLD" != "NOFILE"
then
    ATTACHSTR="${ATTACHSTR} hold/$RESULTHOLD"
fi
if test "$RESULTODUE" != "NOFILE"
then
    ATTACHSTR="${ATTACHSTR} odue/$RESULTODUE"
fi
if test "$RESULTODUE2" != "NOFILE"
then
    ATTACHSTR="${ATTACHSTR} odue2/$RESULTODUE2"
fi
if test "$RESULTODUE3" != "NOFILE"
then
    ATTACHSTR="${ATTACHSTR} odue2/$RESULTODUE3"
fi

if test "x$ATTACHSTR" = "x"
then
    echo "Nothing to send..."
    exit
fi

echo "set smtp_url = \"smtp://${smtp_host}:${smtp_port}\"" > /root/.muttrc
echo 'set from = "Koha <koha@ub.gu.se>"' >> /root/.muttrc
echo 'set ssl_starttls=no' >> /root/.muttrc
echo 'set ssl_force_tls=no' >> /root/.muttrc

cd "$print_notice_data_dir"
echo "" | mutt -s "$SUBJECT" -i "$BODYFILE" -a $ATTACHSTR -- "$RECEIVER"
