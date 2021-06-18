#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# MODIFIERS

function modify_action_compile_payload_data_set () {
    local SETTING_LABELS=( 'HYpnotiK-Payload' 'Out-File' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'HYpnotiK-Payload')
            action_set_hypnotik_payload_source_file
            ;;
        'Out-File')
            action_set_out_file
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_compile_minion_data_set () {
    local SETTING_LABELS=( 'Evil-Minion' 'Out-File' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Evil-Minion')
            action_set_evil_minion_source_file
            ;;
        'Out-File')
            action_set_out_file
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_delete_group_data_set () {
    local SETTING_LABELS=( 'Group-Label' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Group-Label')
            action_set_group_labels
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_create_group_data_set () {
    local SETTING_LABELS=( 'Group-Label' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Group-Label')
            action_set_group_labels
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_search_groups_data_set () {
    local SETTING_LABELS=( 'Group-Label' 'Search-Criteria' 'Group-Size' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Search-Criteria')
            action_set_search_criteria
            ;;
        'Group-Label')
            action_set_group_labels
            ;;
        'Group-Size')
            action_set_group_size
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_group_conscripts_data_set () {
    local SETTING_LABELS=(
        'Group-Label' 'Port-Number' 'Conscript-User' 'Conscript-Address'
        'Conscript-Key' 'Conscript-ID' 'Action-Target' 'Search-Criteria'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Port-Number')
            action_set_port_number
            ;;
        'Action-Target')
            action_set_action_target
            ;;
        'Search-Criteria')
            action_set_search_criteria
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Payload-Path')
            action_set_hypnotik_payload
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_delete_archive_data_set () {
    local SETTING_LABELS=( 'Search-Criteria' 'Deprecated-Archive' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Search-Criteria')
            action_set_search_criteria
            ;;
        'Deprecated-Archive')
            action_set_victim_archive
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_search_conscripts_data_set () {
    local SETTING_LABELS=(
        'Search-Criteria' 'Port-Number' 'Conscript-User' 'Conscript-Address'
        'Conscript-Key' 'Conscript-ID'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Port-Number')
            action_set_port_number
            ;;
        'Search-Criteria')
            action_set_search_criteria
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Payload-Path')
            action_set_hypnotik_payload
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_archive_conscripts_data_set () {
    local SETTING_LABELS=(
        'Deprecated-Archive' 'Action-Target' 'Port-Number' 'Conscript-User'
        'Conscript-Address' 'Conscript-Key' 'Conscript-ID' 'Conscript-Group'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Deprecated-Archive')
            action_set_victim_archive
            ;;
        'Port-Number')
            action_set_port_number
            ;;
        'Action-Target')
            action_set_target
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Payload-Path')
            action_set_hypnotik_payload
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        'Conscript-Group')
            action_set_group_labels
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}


function modify_action_mission_instruction_data_set () {
    local SETTING_LABELS=(
        'Connection-Protocol' 'Mission-Instruction' 'Port-Number'
        'Papertrail-Flag' 'Action-Target' 'Conscript-User' 'Conscript-Address'
        'Conscript-Key' 'Conscript-ID' 'Conscript-Group'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Mission-Instruction')
            action_set_mission_instruction
            ;;
        'Connection-Protocol')
            action_set_connection_protocol
            ;;
        'Port-Number')
            action_set_port_number
            ;;
        'Papertrail-Flag')
            action_set_papertrail_flag
            ;;
        'Action-Target')
            action_set_target
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Payload-Path')
            action_set_hypnotik_payload
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        'Conscript-Group')
            action_set_group_labels
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_conscript_commander_data_set () {
    local SETTING_LABELS=( 'Conscript-ID' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_deploy_payload_data_set () {
    local SETTING_LABELS=(
        'FTP-Payload-Server' 'Connection-Protocol' 'Payload-Path'
        'Port-Number' 'Papertrail-Flag' 'Action-Target' 'Conscript-User'
        'Conscript-Address' 'Conscript-Key' 'Conscript-ID' 'Conscript-Group'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'FTP-Payload-Server')
            action_set_ftp_server_address
            ;;
        'Connection-Protocol')
            action_set_connection_protocol
            ;;
        'Port-Number')
            action_set_port_number
            ;;
        'Papertrail-Flag')
            action_set_papertrail_flag
            ;;
        'Action-Target')
            action_set_target
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Payload-Path')
            action_set_hypnotik_payload
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        'Conscript-Group')
            action_set_group_labels
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_search_victim_records_data_set () {
    local SETTING_LABELS=(
        'FTP-Payload-Server' 'Connection-Protocol' 'Port-Number' 'Conscript-User'
        'Conscript-Address' 'Conscript-Key' 'Conscript-ID' 'Conscript-Group'
        'Group-Size' 'Search-Criteria'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'FTP-Payload-Server')
            action_set_ftp_server_address
            ;;
        'Connection-Protocol')
            action_set_connection_protocol
            ;;
        'Port-Number')
            action_set_port_number
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        'Conscript-Group')
            action_set_group_labels
            ;;
        'Group-Size')
            action_set_group_size
            ;;
        'Search-Criteria')
            action_set_search_criteria
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_register_victims_data_set () {
    local SETTING_LABELS=(
        'FTP-Payload-Server' 'Connection-Protocol' 'Port-Number' 'Conscript-User'
        'Conscript-Address' 'Conscript-Key' 'Conscript-ID' 'Conscript-Group'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'FTP-Payload-Server')
            action_set_ftp_server_address
            ;;
        'Connection-Protocol')
            action_set_connection_protocol
            ;;
        'Port-Number')
            action_set_port_number
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        'Conscript-Group')
            action_set_group_labels
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_deploy_minion_data_set () {
    local SETTING_LABELS=(
        'FTP-Payload-Server' 'Connection-Protocol' 'Minion-Path'
        'Port-Number' 'Papertrail-Flag' 'Action-Target' 'Conscript-User'
        'Conscript-Address' 'Conscript-Key' 'Conscript-ID' 'Conscript-Group'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'FTP-Payload-Server')
            action_set_ftp_server_address
            ;;
        'Connection-Protocol')
            action_set_connection_protocol
            ;;
        'Port-Number')
            action_set_port_number
            ;;
        'Papertrail-Flag')
            action_set_papertrail_flag
            ;;
        'Action-Target')
            action_set_target
            ;;
        'Conscript-User')
            action_set_victim_user
            ;;
        'Minion-Path')
            action_set_evil_minion
            ;;
        'Conscript-Address')
            action_set_victim_addresses
            ;;
        'Conscript-Key')
            action_set_victim_key
            ;;
        'Conscript-ID')
            action_set_victim_identifiers
            ;;
        'Conscript-Group')
            action_set_group_labels
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_start_minion_listener_data_set () {
    local SETTING_LABELS=(
        'FTP-Payload-Server' 'Connection-Protocol'
        'Port-Number' 'Foreground-Flag'
    )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'FTP-Payload-Server')
            action_set_ftp_server_address
            ;;
        'Connection-Protocol')
            action_set_connection_protocol
            ;;
        'Port-Number')
            action_set_port_number
            ;;
        'Foreground-Flag')
            action_set_foreground_flag
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

function modify_action_setup_payload_ftp_server_data_set () {
    local SETTING_LABELS=( 'FTP-Config-Template' 'FTP-Payload-Server' )
    echo; info_msg "Select field to modify -
    "
    local SLABEL=`fetch_selection_from_user 'Setting' ${SETTING_LABELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$SLABEL" in
        'FTP-Payload-Server')
            action_set_ftp_server_address
            ;;
        'FTP-Config-Template')
            action_set_ftp_server_config_template
            ;;
        *)
            echo; error_msg "Invalid setting label! (${RED}${SLABEL}${RESET})"
            return 2
            ;;
    esac
    return $?
}

