#!/usr/bin/env sh

# Library for logging functions

# Log the given message at the given level. All logs are written to stderr with a timestamp.
log() {
    level="$1"
    message="$2"
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    script_name="$(basename "$0")"
    printf >&2 "%s [%s] [%s] %b\n" "${timestamp}" "${level}" "$script_name" "${message}"
}

# Log the given message at INFO level. All logs are written to stderr with a timestamp.
log_info() {
    message="$1"
    log "INFO" "$message"
}

# Log the given message at WARN level. All logs are written to stderr with a timestamp.
log_warn() {
    message="$1"
    log "WARN" "$message"
}

# Log the given message at ERROR level. All logs are written to stderr with a timestamp.
log_error() {
    message="$1"
    log "ERROR" "$message"
}
