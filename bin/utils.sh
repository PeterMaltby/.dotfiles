#!/bin/bash

# utils.sh - Common utility functions for bash scripts
# Source this file in your scripts: source ./utils.sh

# Color codes for terminal output
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_GRAY='\033[0;90m'

# Script name for logger (can be overridden)
SCRIPT_NAME="${0##*/}"

# Verbose mode flag (set with enable_verbose or -v flag)
VERBOSE=false

# Enable verbose logging
# Usage: enable_verbose
enable_verbose() {
    VERBOSE=true
}

# Parse common flags (call this in your script)
# Usage: parse_flags "$@"
parse_flags() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                enable_verbose
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
}

# Logging functions
# Debug and info only print to terminal if VERBOSE=true
# Error and warning always print to terminal
# All levels always log to systemd journal

log_debug() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${COLOR_GRAY}[DEBUG] $*${COLOR_RESET}" >&2
    fi
    logger -t "$SCRIPT_NAME" -p user.debug "DEBUG: $*"
}

log_info() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${COLOR_BLUE}[INFO] $*${COLOR_RESET}" >&2
    fi
    logger -t "$SCRIPT_NAME" -p user.info "INFO: $*"
}

log_warning() {
    echo -e "${COLOR_YELLOW}[WARNING] $*${COLOR_RESET}" >&2
    logger -t "$SCRIPT_NAME" -p user.warning "WARNING: $*"
}

log_error() {
    echo -e "${COLOR_RED}[ERROR] $*${COLOR_RESET}" >&2
    logger -t "$SCRIPT_NAME" -p user.err "ERROR: $*"
}

# Check if a command exists
# Usage: check_command "docker" || exit 1
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        log_error "Required command '$1' not found"
        return 1
    fi
}

# Check if running as root
# Usage: check_root || exit 1
check_root() {
    if [[ $EUID -eq 0 ]]; then
        return 0
    else
        log_error "This script must be run as root"
        return 1
    fi
}

# Check if file exists
# Usage: check_file "/path/to/file" || exit 1
check_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        return 0
    else
        log_error "File does not exist: $file"
        return 1
    fi
}

# Check if directory exists
# Usage: check_dir "/path/to/dir" || exit 1
check_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        return 0
    else
        log_error "Directory does not exist: $dir"
        return 1
    fi
}

# Replace/copy file with backup
# Usage: replace_file "/source/file" "/dest/file"
replace_file() {
    local source="$1"
    local dest="$2"
    
    # Check if source exists
    if [[ ! -f "$source" ]]; then
        log_error "Source file does not exist: $source"
        return 1
    fi
    
    # Create backup if destination exists
    if [[ -f "$dest" ]]; then
        local backup="${dest}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Creating backup: $backup"
        cp -p "$dest" "$backup" || {
            log_error "Failed to create backup"
            return 1
        }
    fi
    
    # Copy the file
    log_info "Copying $source to $dest"
    cp -p "$source" "$dest" || {
        log_error "Failed to copy file"
        return 1
    }
    
    log_info "File replaced successfully"
    return 0
}

# Error handler function
# Call this to handle errors and optionally exit
# Usage: handle_error "Something went wrong" 1
handle_error() {
    local message="$1"
    local exit_code="${2:-1}"
    
    log_error "$message"
    
    # Print stack trace if available
    if [[ ${#BASH_SOURCE[@]} -gt 1 ]]; then
        log_error "Stack trace:"
        local i=0
        while [[ $i -lt ${#BASH_SOURCE[@]} ]]; do
            if [[ $i -gt 0 ]]; then
                log_error "  [$i] ${BASH_SOURCE[$i]}:${BASH_LINENO[$((i-1))]} in ${FUNCNAME[$i]}"
            fi
            ((i++))
        done
    fi
    
    # Print journalctl command to view full logs
    echo -e "${COLOR_YELLOW}" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "To view full logs from this run, use:" >&2
    echo "  journalctl -t $SCRIPT_NAME --since '5 minutes ago'" >&2
    echo "Or for all logs from this script:" >&2
    echo "  journalctl -t $SCRIPT_NAME" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo -e "${COLOR_RESET}" >&2
    
    exit "$exit_code"
}

# Setup trap for error handling (call this in your main script)
# Usage: setup_error_trap
setup_error_trap() {
    set -euo pipefail
    trap 'handle_error "Script failed at line $LINENO" $?' ERR
}

# Example usage (comment out or remove in production)
# Parse flags from command line arguments
# parse_flags "$@"
#
# Or enable verbose manually
# enable_verbose
#
# check_command "ls" && log_info "ls command found"  # Only shows if -v flag used
# log_error "This always shows"  # Always visible
# log_warning "This also always shows"  # Always visible
