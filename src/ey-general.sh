#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# GENERAL

function generate_conscript_id () {
    while :
    do
        local NEW_CID="c${RANDOM}"
        check_conscript_identifier_registered "$NEW_CID" &> /dev/null
        if [ $? -eq 0 ]; then
            break
        fi
        debug_msg "Conscript ID already registered! (${RED}$NEW_CID${RESET})"\
            "Giving it another GO..."
    done
    debug_msg "Successfully generated new Conscript ID!"\
        "(${GREEN}$NEW_CID${RESET})"
    echo "$NEW_CID"
    return 0
}

function delete_all_conscript_archives () {
    local ARGUMENTS=(
        `format_evil_yuri_delete_all_archives_arguments
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Delete All Archives arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function delete_specific_conscript_archive () {
    local ARCHIVE_LABEL="$1"
    local ARGUMENTS=(
        `format_evil_yuri_delete_specific_archive_arguments "$ARCHIVE_LABEL"
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Delete Archive arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function delete_all_conscript_groups () {
    local ARGUMENTS=(
        `format_evil_yuri_delete_all_groups_arguments
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Delete All Groups arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function delete_specific_conscript_group () {
    local GROUP_LABEL="$1"
    local ARGUMENTS=(
        `format_evil_yuri_delete_specific_group_arguments "$GROUP_LABEL"
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Delete Group arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function delete_conscript_archive () {
    local CARCHIVE_LABEL="$1"
    case "$CARCHIVE_LABEL" in
        'Delete-All')
            delete_all_conscript_archives
            ;;
        *)
            delete_specific_conscript_archive "$CARCHIVE_LABEL"
            ;;
    esac
    return $?
}

function delete_conscript_group () {
    local CGROUP_LABEL="$1"
    case "$CGROUP_LABEL" in
        'Delete-All')
            delete_all_conscript_groups
            ;;
        *)
            delete_specific_conscript_group "$CGROUP_LABEL"
            ;;
    esac
    return $?
}

function create_conscript_archive () {
    local CARCHIVE_LABEL="$1"
    local ARGUMENTS=(
        `format_evil_yuri_create_archive_arguments "$CARCHIVE_LABEL"
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Create Conscript Archive arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function create_conscript_group () {
    local CGROUP_LABEL="$1"
    local ARGUMENTS=(
        `format_evil_yuri_create_group_arguments "$CGROUP_LABEL"
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Create Conscript Group arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function search_conscript_groups () {
    local SEARCH_CRITERIA="$1"
    local TARGET_VALUE="$2"
    local ARGUMENTS=(
        `format_evil_yuri_search_groups_arguments \
            "$SEARCH_CRITERIA" "$TARGET_VALUE"`
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Search Conscript Groups arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function search_conscript_archives () {
    local SEARCH_CRITERIA="$1"
    local TARGET_VALUE="$2"
    local ARGUMENTS=(
        `format_evil_yuri_search_archives_arguments \
            "$SEARCH_CRITERIA" "$TARGET_VALUE"`
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Search Conscript Archives arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function group_conscripts () {
    local GROUP_ID="$1"
    local CONSCRIPT_IDS_CSV="$2"
    local ARGUMENTS=(
        `format_evil_yuri_group_conscripts_arguments \
            "$GROUP_ID" "$CONSCRIPT_IDS_CSV"`
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Group Conscripts arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function archive_conscripts () {
    local ARCHIVE_ID="$1"
    local CONSCRIPT_IDS_CSV="$2"
    local ARGUMENTS=(
        `format_evil_yuri_archive_conscripts_arguments \
            "$ARCHIVE_ID" "$CONSCRIPT_IDS_CSV"`
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Archive Conscripts arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function shorten_file_path () {
    local FILE_PATH="$1"
    DIR_PATH=`dirname $FILE_PATH 2> /dev/null`
    DIR_NAME=`basename $DIR_PATH 2> /dev/null`
    FL_NAME=`basename $FILE_PATH 2> /dev/null`
    local FL_SHORT="${DIR_NAME}/${FL_NAME}"
    echo "$FL_SHORT"
    return $?
}

# CODE DUMP

