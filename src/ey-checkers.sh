#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# CHECKERS

function check_conscript_identifier_registered () {
    local CID="$1"
    local LINE_NO=`awk -F, -v conscript_id="$CID" \
        '$1 == conscript_id { print NR; exit 0 }' \
        "${MD_DEFAULT['cindex-file']}"`
    if [ $? -ne 0 ] || [ -z "$LINE_NO" ]; then
        return 0
    fi
    return 1
}

