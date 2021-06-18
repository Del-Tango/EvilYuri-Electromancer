#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FETCHERS

function fetch_conscript_count () {
    local LINE_NO=`cat ${MD_DEFAULT['cindex-file']} | \
        sed -e 's/^#//g' -e 's/^\s{0,}$//g' | wc -l`
    local EXIT_CODE=$?
    echo $LINE_NO
    return $EXIT_CODE
}

function fetch_group_count () {
    local LINE_NO=`cat ${MD_DEFAULT['gindex-file']} | \
        sed -e 's/^#//g' -e 's/^\s{0,}$//g' | wc -l`
    local EXIT_CODE=$?
    echo $LINE_NO
    return $EXIT_CODE
}

function fetch_archive_count () {
    local LINE_NO=`cat ${MD_DEFAULT['aindex-file']} | \
        sed -e 's/^#//g' -e 's/^\s{0,}$//g' | wc -l`
    local EXIT_CODE=$?
    echo $LINE_NO
    return $EXIT_CODE
}

function fetch_all_conscript_group_labels () {
    local LABELS=(
        `awk -F, '{ print $1 }' "${MD_DEFAULT['gindex-file']}" | sort -u`
    )
    echo ${LABELS[@]}
    return 0
}

function fetch_all_conscript_archive_labels () {
    local LABELS=(
        `awk -F, '{ print $NF }' "${MD_DEFAULT['aindex-file']}" | sort -u`
    )
    echo ${LABELS[@]}
    return 0
}
