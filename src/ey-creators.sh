#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# CREATORS

function create_menu_controllers () {
    create_main_menu_controller
    create_evil_yuri_menu_controller
    create_stage1_menu_controller
    create_stage2_menu_controller
    create_stage3_menu_controller
    create_wifi_commander_menu_controller
    create_game_changer_menu_controller
    create_log_viewer_menu_cotroller
    create_settings_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller construction complete."
    return 0
}

function create_main_menu_controller () {
    local DESCRIPTION_SEG1=`echo "$MAIN_CONTROLLER_DESCRIPTION" | awk -F'*' '{print $1}' #| sed 's/\s{1,}$//'`
    local DESCRIPTION_SEG2=`echo "$MAIN_CONTROLLER_DESCRIPTION" | awk -F'*' '{print $2}' #| sed 's/^\s{1,}//'`
    local FORMATTED_DESCRIPTION="${CYAN}${DESCRIPTION_SEG1} * ${RED}${DESCRIPTION_SEG2}${RESET}"
    create_menu_controller "$MAIN_CONTROLLER_LABEL" \
        "$FORMATTED_DESCRIPTION" "$MAIN_CONTROLLER_OPTIONS"
    return $?
}

function create_evil_yuri_menu_controller () {
    create_menu_controller "$EVIL_YURI_CONTROLLER_LABEL" \
        "${RED}$EVIL_YURI_CONTROLLER_DESCRIPTION${RESET}" \
        "$EVIL_YURI_CONTROLLER_OPTIONS"
    info_msg "Setting ${CYAN}$EVIL_YURI_CONTROLLER_LABEL${RESET} extented"\
        "banner function ${MAGENTA}display_evil_yuri_details${RESET}..."
    set_menu_controller_extended_banner "$EVIL_YURI_CONTROLLER_LABEL" \
        'display_evil_yuri_details'
    return $?
}

function create_wifi_commander_menu_controller () {
    create_menu_controller "$WIFICOMMANDER_CONTROLLER_LABEL" \
        "${CYAN}$WIFICOMMANDER_CONTROLLER_DESCRIPTION${RESET}" \
        "$WIFICOMMANDER_CONTROLLER_OPTIONS"
    info_msg "Setting ${CYAN}$WIFICOMMANDER_CONTROLLER_LABEL${RESET} extented"\
        "banner function ${MAGENTA}display_wifi_commander_details${RESET}..."
    set_menu_controller_extended_banner "$WIFICOMMANDER_CONTROLLER_LABEL" \
        'display_wifi_commander_details'
    return $?
}

function create_stage1_menu_controller () {
    create_menu_controller "$STAGE1_CONTROLLER_LABEL" \
        "${RED}$STAGE1_CONTROLLER_DESCRIPTION${RESET}" \
        "$STAGE1_CONTROLLER_OPTIONS"
    return $?
}

function create_stage2_menu_controller () {
    create_menu_controller "$STAGE2_CONTROLLER_LABEL" \
        "${RED}$STAGE2_CONTROLLER_DESCRIPTION${RESET}" \
        "$STAGE2_CONTROLLER_OPTIONS"
    return $?
}

function create_stage3_menu_controller () {
    create_menu_controller "$STAGE3_CONTROLLER_LABEL" \
        "${RED}$STAGE3_CONTROLLER_DESCRIPTION${RESET}" \
        "$STAGE3_CONTROLLER_OPTIONS"
    return $?
}

function create_game_changer_menu_controller () {
    create_menu_controller "$GAMECHANGER_CONTROLLER_LABEL" \
        "${CYAN}$GAMECHANGER_CONTROLLER_DESCRIPTION${RESET}" \
        "$GAMECHANGER_CONTROLLER_OPTIONS"
    return $?
}

function create_log_viewer_menu_cotroller () {
    create_menu_controller "$LOGVIEWER_CONTROLLER_LABEL" \
        "${CYAN}$LOGVIEWER_CONTROLLER_DESCRIPTION${RESET}" \
        "$LOGVIEWER_CONTROLLER_OPTIONS"
    return $?
}

function create_settings_menu_controller () {
    create_menu_controller "$SETTINGS_CONTROLLER_LABEL" \
        "${CYAN}$SETTINGS_CONTROLLER_DESCRIPTION${RESET}" \
        "$SETTINGS_CONTROLLER_OPTIONS"
    info_msg "Setting ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} extented"\
        "banner function ${MAGENTA}display_project_settings${RESET}..."
    set_menu_controller_extended_banner "$SETTINGS_CONTROLLER_LABEL" \
        'display_project_settings'
    return 0
}

