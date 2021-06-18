#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_game_changer_header () {
    echo "
    ___________________________________________________________________________

     *            *           *     Game Changer    *           *            *
    _______________________________________________________v.Shell2C___________
                        Regards, the Alveare Solutions society.
    "
}

function display_action_compile_payload_data_set () {
    echo -n "${RED}"; display_game_changer_header; echo -n "${RESET}"
    echo "    ${CYAN}Compile ${RED}HYpnotiK Payload${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_setting_source_file
    echo -n '    '; display_formatted_setting_out_file
    return 0
}

function display_action_compile_minion_data_set () {
    echo -n "${RED}"; display_game_changer_header; echo -n "${RESET}"
    echo "    ${CYAN}Compile ${RED}Evil Minion${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_setting_source_file
    echo -n '    '; display_formatted_setting_out_file
    return 0
}

function display_action_search_groups_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Search ${RED}Conscript ${CYAN}Groups${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_search_criteria
    case "${MD_DEFAULT['search-criteria']}" in
        'identifier')
            echo -n '    '; display_formatted_setting_group_labels
            ;;
        'size')
            echo -n '    '; display_formatted_setting_group_size
            ;;
    esac
    return 0
}

function display_action_search_archives_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Search ${RED}Conscript ${CYAN}Archives${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_search_criteria
    case "${MD_DEFAULT['search-criteria']}" in
        'identifier')
            echo -n '    '; display_formatted_setting_victim_identifiers
            ;;
        'address')
            echo -n '    '; display_formatted_setting_victim_addresses
            ;;
        'port')
            echo -n '    '; display_formatted_setting_port_number
            ;;
        'key')
            echo -n '    '; display_formatted_setting_victim_key
            ;;
        'user')
            echo -n '    '; display_formatted_setting_victim_user
            ;;
    esac
    return 0
}

function display_action_group_conscripts_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Group ${RED}Conscripts${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_group_labels
    echo -n '    '; display_formatted_setting_target
    case "${MD_DEFAULT['target']}" in
        'specific')
            echo -n '    '; display_formatted_setting_victim_identifiers
            ;;
        'attribute')
            echo -n '    '; display_formatted_setting_search_criteria
            case "${MD_DEFAULT['search-criteria']}" in
                'identifier')
                    echo -n '    '; display_formatted_setting_victim_identifiers
                    ;;
                'address')
                    echo -n '    '; display_formatted_setting_victim_addresses
                    ;;
                'port')
                    echo -n '    '; display_formatted_setting_port_number
                    ;;
                'key')
                    echo -n '    '; display_formatted_setting_victim_key
                    ;;
                'user')
                    echo -n '    '; display_formatted_setting_victim_user
                    ;;
            esac
            ;;
    esac
    return 0
}

function display_action_delete_group_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Delete ${RED}Conscript ${CYAN}Group${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_group_labels
}

function display_action_create_group_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Create ${RED}Conscript ${CYAN}Group${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_group_labels
    return 0
}

function display_action_delete_archive_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Delete ${RED}Conscript ${CYAN}Archives${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_search_criteria
    echo -n '    '; display_formatted_setting_deprecated_archive
}

function display_action_search_conscripts_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Search ${RED}Conscripts${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_search_criteria
    case "${MD_DEFAULT['search-criteria']}" in
        'identifier')
            echo -n '    '; display_formatted_setting_victim_identifiers
            ;;
        'address')
            echo -n '    '; display_formatted_setting_victim_addresses
            ;;
        'port')
            echo -n '    '; display_formatted_setting_port_number
            ;;
        'key')
            echo -n '    '; display_formatted_setting_victim_key
            ;;
        'user')
            echo -n '    '; display_formatted_setting_victim_user
            ;;
    esac
    return 0
}

function display_action_archive_conscripts_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Archive ${RED}Conscripts${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_deprecated_archive
    echo -n '    '; display_formatted_setting_target
    case "${MD_DEFAULT['target']}" in
        'specific')
            echo -n '    '; display_formatted_setting_victim_identifiers
            ;;
        'group')
            echo -n '    '; display_formatted_setting_group_labels
            ;;
        'attribute')
            case "${MD_DEFAULT['search-criteria']}" in
                'identifier')
                    echo -n '    '; display_formatted_setting_victim_identifiers
                    ;;
                'address')
                    echo -n '    '; display_formatted_setting_victim_addresses
                    ;;
                'port')
                    echo -n '    '; display_formatted_setting_port_number
                    ;;
                'key')
                    echo -n '    '; display_formatted_setting_victim_key
                    ;;
                'user')
                    echo -n '    '; display_formatted_setting_victim_user
                    ;;
            esac
            ;;
    esac
    return 0
}

function display_wifi_commander_details () {
    ${MD_CARGO['wifi-commander']} "$CONF_FILE_PATH" '--state' &> /dev/null
    case $? in
        0)
            local WC_FLAG="${GREEN}ON${RESET}"
            ;;
        *)
            local WC_FLAG="${RED}OFF${RESET}"
            ;;
    esac
    if [ $EUID -ne 0 ]; then
        local SU_FLAG="${RED}OFF${RESET}"
        warning_msg "${BLUE}WiFi Commander${RESET} requires"\
            "${RED}elevated privileges${RESET}!"
    else
        local SU_FLAG="${GREEN}ON${RESET}"
    fi
    echo "[ ${CYAN}WiFi Connected${RESET}        ]: $WC_FLAG
[ ${CYAN}Super User${RESET}            ]: $SU_FLAG
    "
    return 0
}

function display_evil_yuri_details () {
    local CONSCRIPT_COUNT=`fetch_conscript_count`
    local GROUP_COUNT=`fetch_group_count`
    local ARCHIVE_COUNT=`fetch_archive_count`
    echo "
[ ${RED}Conscript Commander${RESET}   ]: ${YELLOW}`whoami`${RESET}
[ ${RED}MasterMind Machine${RESET}    ]: ${YELLOW}`hostname`${RESET}
[ ${CYAN}Machine Time${RESET}          ]: ${MAGENTA}`date +%D-%T`${RESET}
[ ${CYAN}Conscripts Registered${RESET} ]: ${WHITE}$CONSCRIPT_COUNT${RESET}
[ ${CYAN}Conscripts Archived${RESET}   ]: ${WHITE}$ARCHIVE_COUNT${RESET}
[ ${CYAN}Conscript Groups${RESET}      ]: ${WHITE}$GROUP_COUNT${RESET}
    " | column; echo
    return $?
}

function display_available_victim_archives () {
    if [ ! -f "${MD_DEFAULT['aindex-file']}" ]; then
        warning_msg "No archive index file found!"\
            "({${MD_DEFAULT['aindex-file']}})"
        return 1
    fi
    local ARCHIVE_LABELS=( `fetch_all_conscript_archive_labels` )
    local FORMATTEAD_LABELS=()
    for archive_label in ${ARCHIVE_LABELS[@]}; do
        local FORMATTED_LABELS=(
            ${FORMATTED_LABELS[@]} "~ ${MAGENTA}${archive_label}${RESET}"
        )
    done
    echo "    ${CYAN}Archive Labels${RESET}
    ____________________________________________________________________________
    "
    echo "${FORMATTED_LABELS[@]}" | column
    return $?
}

function display_action_conscript_commander_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${RED}Conscript ${CYAN}Commander${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_victim_identifiers
    return 0
}

function display_action_mission_instruction_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${RED}Mission ${CYAN}Instruction${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_target
    echo -n '    '; display_formatted_setting_papertrail_flag
    echo -n '    '; display_formatted_setting_mission_instruction
    case "${MD_DEFAULT['target']}" in
        'specific')
            echo -n '    '; display_formatted_setting_protocol
            echo -n '    '; display_formatted_setting_port_number
            echo -n '    '; display_formatted_setting_victim_user
            echo -n '    '; display_formatted_setting_victim_key
            echo -n '    '; display_formatted_setting_victim_identifiers
            echo -n '    '; display_formatted_setting_victim_addresses
            ;;
        'group')
            echo -n '    '; display_formatted_setting_group_labels
            ;;
        'attribute')
            case "${MD_DEFAULT['search-criteria']}" in
                'identifier')
                    echo -n '    '; display_formatted_setting_victim_identifiers
                    ;;
                'address')
                    echo -n '    '; display_formatted_setting_victim_addresses
                    ;;
                'port')
                    echo -n '    '; display_formatted_setting_port_number
                    ;;
                'key')
                    echo -n '    '; display_formatted_setting_victim_key
                    ;;
                'user')
                    echo -n '    '; display_formatted_setting_victim_user
                    ;;
            esac
            ;;
    esac
    return 0
}

function display_action_deploy_payload_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Deploy ${RED}HYpnotiK Payload${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_target
    echo -n '    '; display_formatted_setting_payload_path
    echo -n '    '; display_formatted_setting_papertrail_flag
    echo -n '    '; display_formatted_setting_ftp_serv_address
    case "${MD_DEFAULT['target']}" in
        'specific')
            echo -n '    '; display_formatted_setting_protocol
            echo -n '    '; display_formatted_setting_port_number
            echo -n '    '; display_formatted_setting_victim_user
            echo -n '    '; display_formatted_setting_victim_key
            echo -n '    '; display_formatted_setting_victim_identifiers
            echo -n '    '; display_formatted_setting_victim_addresses
            ;;
        'group')
            echo -n '    '; display_formatted_setting_group_labels
            ;;
        'attribute')
            case "${MD_DEFAULT['search-criteria']}" in
                'identifier')
                    echo -n '    '; display_formatted_setting_victim_identifiers
                    ;;
                'address')
                    echo -n '    '; display_formatted_setting_victim_addresses
                    ;;
                'port')
                    echo -n '    '; display_formatted_setting_port_number
                    ;;
                'key')
                    echo -n '    '; display_formatted_setting_victim_key
                    ;;
                'user')
                    echo -n '    '; display_formatted_setting_victim_user
                    ;;
            esac
            ;;
    esac
    return 0
}

function display_action_deploy_minion_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Deploy ${RED}Evil Minion${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_ftp_serv_address
    echo -n '    '; display_formatted_setting_minion_path
    echo -n '    '; display_formatted_setting_papertrail_flag
    echo -n '    '; display_formatted_setting_target
    case "${MD_DEFAULT['target']}" in
        'specific')
            echo -n '    '; display_formatted_setting_protocol
            echo -n '    '; display_formatted_setting_port_number
            echo -n '    '; display_formatted_setting_victim_user
            echo -n '    '; display_formatted_setting_victim_key
            echo -n '    '; display_formatted_setting_victim_identifiers
            echo -n '    '; display_formatted_setting_victim_addresses
            ;;
        'group')
            echo -n '    '; display_formatted_setting_group_labels
            ;;
        'attribute')
            case "${MD_DEFAULT['search-criteria']}" in
                'identifier')
                    echo -n '    '; display_formatted_setting_victim_identifiers
                    ;;
                'address')
                    echo -n '    '; display_formatted_setting_victim_addresses
                    ;;
                'port')
                    echo -n '    '; display_formatted_setting_port_number
                    ;;
                'key')
                    echo -n '    '; display_formatted_setting_victim_key
                    ;;
                'user')
                    echo -n '    '; display_formatted_setting_victim_user
                    ;;
            esac
            ;;
    esac
    return 0
}

function display_action_search_victim_records_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Search ${RED}Conscript${CYAN} Records${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_search_criteria
    echo -n '    '; display_formatted_setting_protocol
    case "${MD_DEFAULT['search-criteria']}" in
        'identifier')
            echo -n '    '; display_formatted_setting_victim_identifiers
            ;;
        'adddress')
            echo -n '    '; display_formatted_setting_victim_addresses
            ;;
        'port')
            echo -n '    '; display_formatted_setting_port_number
            ;;
        'key')
            echo -n '    '; display_formatted_setting_victim_key
            ;;
        'user')
            echo -n '    '; display_formatted_setting_victim_user
            ;;
        *)
            echo -n '    '; display_formatted_setting_port_number
            echo -n '    '; display_formatted_setting_victim_user
            echo -n '    '; display_formatted_setting_victim_key
            echo -n '    '; display_formatted_setting_victim_identifiers
            echo -n '    '; display_formatted_setting_victim_addresses
            ;;
    esac
    return 0
}

function display_action_register_victims_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Register ${RED}Conscripts${CYAN} Manually${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_protocol
    echo -n '    '; display_formatted_setting_port_number
    echo -n '    '; display_formatted_setting_victim_user
    echo -n '    '; display_formatted_setting_victim_key
    echo -n '    '; display_formatted_setting_victim_identifiers
    echo -n '    '; display_formatted_setting_victim_addresses
    echo -n '    '; display_formatted_setting_ftp_serv_address
    return 0
}

function display_action_start_minion_listener_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Start ${RED}Evil Minion${CYAN} (Phone Home) Listener${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_ftp_serv_address
    echo -n '    '; display_formatted_setting_protocol
    echo -n '    '; display_formatted_setting_port_number
    echo -n '    '; display_formatted_setting_foreground_flag
    return 0
}

function display_action_setup_payload_ftp_server_data_set () {
    echo -n "${RED}"; display_header; echo -n "${RESET}"
    echo "    ${CYAN}Setup Payload FTP Server${RESET} - Action Data Set
    ____________________________________________________________________________
    "
    echo -n '    '; display_formatted_project_root
    echo -n '    '; display_formatted_setting_ftp_conf_template
    echo -n '    '; display_formatted_setting_ftp_serv_address
    return 0
}

function display_header () {
    echo "
    ____________________________________________________________________________

     *            *           *  Evil Yuri - BotNet  *           *            *
    ______________________________________________________v.${EY_VERSION}_______
                        Regards, the Alveare Solutions society.
    "
}

function display_formatted_settings () {
    display_formatted_setting_minion_dir
    display_formatted_setting_payload_dir
    display_formatted_setting_template_dir
    display_formatted_setting_victim_dir
    display_formatted_setting_minion_path
    display_formatted_setting_payload_path
    display_formatted_setting_conscript_index
    display_formatted_setting_group_index
    display_formatted_setting_archive_index
    display_formatted_setting_conf_file
    display_formatted_setting_log_file
    display_formatted_setting_source_file
    display_formatted_setting_out_file
    display_formatted_setting_ftp_conf_template
    display_formatted_setting_ftp_serv_address
    display_formatted_setting_log_lines
    display_formatted_setting_protocol
    display_formatted_setting_mission_instruction
    display_formatted_setting_port_number
    display_formatted_setting_victim_user
    display_formatted_setting_victim_key
    display_formatted_setting_victim_identifiers
    display_formatted_setting_victim_addresses
    display_formatted_setting_group_labels
    display_formatted_setting_group_size
    display_formatted_setting_deprecated_archive
    display_formatted_setting_target
    display_formatted_setting_search_criteria
    display_formatted_setting_foreground_flag
    display_formatted_setting_papertrail_flag
    display_formatted_setting_safety_flag
    return 0
}

function display_banner_file () {
    local CLEAR_SCREEN=${1:-clear-screen-on}
    cat "${MD_DEFAULT['banner-file']}" > "${MD_DEFAULT['tmp-file']}"
    case "$CLEAR_SCREEN" in
        'clear-screen-on')
            clear
            ;;
    esac; echo "${RED} `cat ${MD_DEFAULT['tmp-file']}` ${RESET}"
    return 0
}

function display_banner () {
    local CLEAR_SCREEN=${1:-clear-screen-on}
    display_banner_file "$CLEAR_SCREEN"
    display_script_banner "clear-screen-off"
    return $?
}

function display_project_settings () {
    display_formatted_settings | column
    echo; return 0
}

function display_formatted_setting_safety_flag () {
    local FORMATTED=`format_flag_colors "$MD_SAFETY"`
    echo "[ ${CYAN}Safety${RESET}              ]: ${FORMATTED:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_victim_dir () {
    if [ ! -z ${MD_DEFAULT['vctm-dir']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['vctm-dir']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Victim Directory${RESET}    ]: ${BLUE}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_conscript_index () {
    if [ ! -z ${MD_DEFAULT['cindex-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['cindex-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Conscript Index${RESET}     ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_group_index () {
    if [ ! -z ${MD_DEFAULT['gindex-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['gindex-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Group Index${RESET}         ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_archive_index () {
    if [ ! -z ${MD_DEFAULT['aindex-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['aindex-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Archive Index${RESET}       ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_source_file () {
    if [ ! -z ${MD_DEFAULT['source-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['source-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}(GC) Source File${RESET}    ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_out_file () {
    if [ ! -z ${MD_DEFAULT['out-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['out-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}(GC) Out File${RESET}       ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_group_size () {
    echo "[ ${CYAN}Group Size${RESET}          ]: ${BLUE}${MD_DEFAULT['group-size']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_project_root () {
    if [ ! -z ${MD_DEFAULT['project-path']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['project-path']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Project Root${RESET}        ]: ${BLUE}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_minion_dir () {
    if [ ! -z ${MD_DEFAULT['minion-dir']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['minion-dir']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Minions Directory${RESET}   ]: ${BLUE}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_payload_dir () {
    if [ ! -z ${MD_DEFAULT['payload-dir']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['payload-dir']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Payloads Directory${RESET}  ]: ${BLUE}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_template_dir () {
    if [ ! -z ${MD_DEFAULT['template-dir']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['template-dir']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Templates Directory${RESET} ]: ${BLUE}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_minion_path () {
    if [ ! -z ${MD_DEFAULT['minion-path']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['minion-path']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Evil Minion${RESET}         ]: ${RED}${SHORT:-Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_payload_path () {
    if [ ! -z ${MD_DEFAULT['payload-path']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['payload-path']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}HYpnotiK Payload${RESET}    ]: ${RED}${SHORT:-Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_mission_instruction () {
    local INSTRUCTION="${MD_DEFAULT['mission-instruction']}"
    if [[ "$INSTRUCTION" =~ '[space]' ]]; then
        local INSTRUCTION=`echo "$INSTRUCTION" | sed 's/\[space\]/ /g'`
    fi
    local TRUNCATED="${INSTRUCTION:0:25}"
    echo "[ ${CYAN}Mission Instruction${RESET} ]: ${MAGENTA}${TRUNCATED:-${RED}Unspecified}${RESET}..."
    return $?
}

function display_formatted_setting_foreground_flag () {
    local FORMATTED=`format_flag_colors ${MD_DEFAULT['foreground-flag']}`
    echo "[ ${CYAN}Keep In Foreground${RESET}  ]: ${FORMATTED:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_papertrail_flag () {
    local FORMATTED=`format_flag_colors ${MD_DEFAULT['papertrail-flag']}`
    echo "[ ${CYAN}Paper Trail${RESET}         ]: ${FORMATTED:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_port_number () {
    echo "[ ${CYAN}Port Number${RESET}         ]: ${WHITE}${MD_DEFAULT['port-number']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_victim_user () {
    echo "[ ${CYAN}Conscript User${RESET}      ]: ${MAGENTA}${MD_DEFAULT['victim-user']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_victim_key () {
    echo "[ ${CYAN}Conscript Key${RESET}       ]: ${MAGENTA}${MD_DEFAULT['victim-key']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_protocol () {
    echo "[ ${CYAN}Connection Protocol${RESET} ]: ${MAGENTA}${MD_DEFAULT['protocol']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_deprecated_archive () {
    echo "[ ${CYAN}Conscript Archive${RESET}   ]: ${MAGENTA}${MD_DEFAULT['deprecated-archive']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_search_criteria () {
    echo "[ ${CYAN}Search Criteria${RESET}     ]: ${MAGENTA}${MD_DEFAULT['search-criteria']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_ftp_conf_template () {
    if [ ! -z ${MD_DEFAULT['ftp-conf-template']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['ftp-conf-template']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}FTP Config Template${RESET} ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_ftp_serv_address () {
    echo "[ ${CYAN}FTP Payload Server ${RESET} ]: ${MAGENTA}${MD_DEFAULT['ftp-serv-address']:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_victim_identifiers () {
    local TRUNCATED="${MD_DEFAULT['victim-identifiers']:0:25}"
    echo "[ ${CYAN}Conscript ID${RESET}        ]: ${MAGENTA}${TRUNCATED:-${RED}Unspecified}${RESET}..."
    return $?
}

function display_formatted_setting_victim_addresses () {
    local TRUNCATED="${MD_DEFAULT['victim-addresses']:0:25}"
    echo "[ ${CYAN}Conscript IPv4${RESET}      ]: ${MAGENTA}${TRUNCATED:-${RED}Unspecified}${RESET}..."
    return $?
}

function display_formatted_setting_group_labels () {
    local TRUNCATED="${MD_DEFAULT['group-labels']:0:25}"
    echo "[ ${CYAN}Group Labels${RESET}        ]: ${MAGENTA}${TRUNCATED:-${RED}Unspecified}${RESET}..."
    return $?
}

function display_formatted_setting_conf_file () {
    if [ ! -z ${MD_DEFAULT['conf-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['conf-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Conf File${RESET}           ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_log_file () {
    if [ ! -z ${MD_DEFAULT['log-file']} ]; then
        local SHORT=`shorten_file_path "${MD_DEFAULT['log-file']}"`
    else
        local SHORT=""
    fi
    echo "[ ${CYAN}Log File${RESET}            ]: ${YELLOW}${SHORT:-${RED}Unspecified}${RESET}"
    return $?
}

function display_formatted_setting_log_lines () {
    echo "[ ${CYAN}Log Lines${RESET}           ]: ${WHITE}${MD_DEFAULT['log-lines']:-${RED}Unspecified}${RESET} lines"
    return $?
}

function display_formatted_setting_target () {
    echo "[ ${CYAN}Action Target${RESET}       ]: ${MAGENTA}${MD_DEFAULT['target']:-${RED}Unspecified}${RESET}"
    return $?
}

# CODE DUMP

