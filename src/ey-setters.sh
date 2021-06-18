#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETTERS

function set_out_file () {
    local FILE_PATH="$1"
    MD_DEFAULT['out-file']="$FILE_PATH"
    return $?
}

function set_source_file () {
    local FILE_PATH="$1"
    MD_DEFAULT['source-file']="$FILE_PATH"
    return $?
}

function set_group_index_file () {
    local FILE_PATH="$1"
    MD_DEFAULT['gindex-file']="$FILE_PATH"
    return $?
}

function set_archive_index_file () {
    local FILE_PATH="$1"
    MD_DEFAULT['aindex-file']="$FILE_PATH"
    return $?
}

function set_conscript_index_file () {
    local FILE_PATH="$1"
    MD_DEFAULT['cindex-file']="$FILE_PATH"
    return $?
}

function set_victim_directory () {
    local DIR_PATH="$1"
    MD_DEFAULT['vctm-dir']="$DIR_PATH"
    return $?
}

function set_search_criteria () {
    local SCRITERIA="$1"
    MD_DEFAULT['search-criteria']="$SCRITERIA"
    return $?
}

function set_target () {
    local TARGET="$1"
    MD_DEFAULT['target']="$TARGET"
    return $?
}

function set_group_size () {
    local GSIZE=$1
    MD_DEFAULT['group-size']=$GSIZE
    return $?
}

function set_papertrail_flag () {
    local PAPERTRAIL_FLAG="$1"
    MD_DEFAULT['papertrail-flag']="$PAPERTRAIL_FLAG"
    return $?
}

function set_foreground_flag () {
    local FOREGROUND_FLAG="$1"
    MD_DEFAULT['foreground-flag']="$FOREGROUND_FLAG"
    return $?
}

function set_hypnotik_payload () {
    local FILE_PATH="$1"
    MD_DEFAULT['payload-path']="$FILE_PATH"
    return $?
}

function set_evil_minion () {
    local FILE_PATH="$1"
    MD_DEFAULT['minion-path']="$FILE_PATH"
    return $?
}

function set_ftp_config_template () {
    local FILE_PATH="$1"
    MD_DEFAULT['ftp-conf-template']="$FILE_PATH"
    return $?
}

function set_template_directory () {
    local DIR_PATH="$1"
    MD_DEFAULT['template-dir']="$DIR_PATH"
    return $?
}

function set_payload_directory () {
    local DIR_PATH="$1"
    MD_DEFAULT['payload-dir']="$DIR_PATH"
    return $?
}

function set_minion_directory () {
    local DIR_PATH="$1"
    MD_DEFAULT['minion-dir']="$DIR_PATH"
    return $?
}

function set_group_labels () {
    local GLABELS="$1"
    MD_DEFAULT['group-labels']="$GLABELS"
    return $?
}

function set_victim_addresses () {
    local VADDRS="$1"
    MD_DEFAULT['victim-addresses']="$VADDRS"
    return $?
}

function set_victim_identifiers () {
    local VIDS="$1"
    MD_DEFAULT['victim-identifiers']="$VIDS"
    return $?
}

function set_ftp_server_address () {
    local SERVER_ADDR="$1"
    MD_DEFAULT['ftp-serv-address']="$SERVER_ADDR"
    return $?
}

function set_victim_archive () {
    local DEPRECATED_ARCHV="$1"
    MD_DEFAULT['deprecated-archive']="$DEPRECATED_ARCHV"
    return $?
}

function set_victim_key () {
    local VICTIM_KEY="$1"
    MD_DEFAULT['victim-key']="$VICTIM_KEY"
    return $?
}

function set_victim_user () {
    local VICTIM_USR="$1"
    MD_DEFAULT['victim-user']="$VICTIM_USR"
    return $?
}

function set_port_number () {
    local PORT_NO=$1
    MD_DEFAULT['port-number']="$PORT_NO"
    return $?
}

function set_mission_instruction () {
    local MISSION="$1"
    if [[ ! "$MISSION" =~ '[space]' ]] && [ ! -z "$MISSION" ]; then
        local MISSION=`echo "$MISSION" | sed 's/ /[space]/g'`
    fi
    MD_DEFAULT['mission-instruction']="$MISSION"
    return 0

}
