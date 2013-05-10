# These functions assume the following vars are declared :
# LOGFILE, and eventually LOGLEVEL.

__LIBABT_LOGGING_DEFAULT_LOGLEVEL=warn

__libabt_logging_get_message() {
    echo "[`date +'%y-%m-%d %H:%M:%S'`] $*"
}

logdebug() {
    case "$LOGLEVEL" in
        debug)
            __libabt_logging_get_message "[debug] $*" >> $LOGFILE
            
#            __libabt_logging_get_message "[debug] $input" >> $LOGFILE
            ;;
        *)
            # Do nothing
            exit 0
            ;;
    esac
}

loginfo() {
    case "$LOGLEVEL" in
        debug|info)
            __libabt_logging_get_message "[info] $*" >> $LOGFILE
            echo "$@"
            ;;
        *)
            # Do nothing
            exit 0
            ;;
    esac
}

logwarn() {
    case "$LOGLEVEL" in
        debug|info|warn|"")
            __libabt_logging_get_message "[warning] $*" >> $LOGFILE
            echo "Warning: $@"
            ;;
        *)
            # Do nothing
            exit 0
            ;;
    esac
}

logerr() {
    case "$LOGLEVEL" in
        debug|info|warn|error)
            __libabt_logging_get_message "[error] $*" >> $LOGFILE
            echo "Error: $@" 1>&2 
            ;;
        *)
            # Do nothing
            exit 0
            ;;
    esac
}
logerror() {
    logerr $@
}

logcrit() {
    # Always log that !
    __libabt_logging_get_message "[critical] $@" >> $LOGFILE
    echo "[CRIT] $@" 1>&2
}

# Function Log : first argument must be the 
# logging level
log() {
    # Get the logging level
    if [ ! -z "$1" ]; then
        case "$1" in
            debug)
                shift && logdebug $*
                ;;
            info)
                shift && loginfo $*
                ;;
            warn|warning)
                shift && logwarn $*
                ;;
            error|err)
                shift && logerr $*
                ;;
            critical|crit)
                shift && logcrit $*
                ;;
            *)
                logdebug "No loglevel $1 found. Printing to STDOUT."
                echo "$*"
                ;;
        esac
    else
        if [ -z "$LOGLEVEL" ]; then
            LOGLEVEL=$DEFAULT_LOGLEVEL
            logwarn "LOGLEVEL undefined. Assuming $__LIBABT_LOGGING_DEFAULT_LOGLEVEL as the default loglevel."
        fi
        logwarn "log: Missing arguments."
    fi
    exit 0
}


