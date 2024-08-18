#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to determine if running under WSL
is_wsl() {
    if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null || [ -n "$WSLENV" ]; then
        return 0  # True, running under WSL
    else
        return 1  # False, not running under WSL
    fi
}

# Function to check if a repository is already cloned
check_repo_exists() {
    local repo_name=$1

    if [ -d "$repo_name" ]; then
        echo "Repository $repo_name already exists. Skipping clone."
        return 1
    else
        return 0
    fi
}

# Function to open a new terminal and run commands
open_new_terminal() {
    local command=$1
    local os

    os=$(uname)

    if [[ $os == Darwin ]]; then
        # macOS - using osascript to open new Terminal windows
        osascript -e "
        tell application \"Terminal\"
            activate
            do script \"$command\"
        end tells
        "
    elif [[ $os == Linux && is_wsl ]]; then
        # WSL - using wsl to run commands in new terminal instances
        cmd.exe /c start wsl.exe -e bash -c "$command"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

# Function to construct the command to clone a repository and run commands
clone_and_run() {
    local repo_url=$1
    local final_command=$2
    local os_type=$3
    local repo_name=$(basename "$repo_url" .git)
    
    local full_command="cd $(pwd) && git clone $repo_url && cd $repo_name && $final_command"
    
    # Check if repository directory already exists
    if check_repo_exists "$repo_name"; then
        local full_command="cd $(pwd) && git clone $repo_url && cd $repo_name && $final_command"
        echo "Executing command: $full_command"
        open_new_terminal "$full_command" "$os_type"
        echo "Starting $repo_name server..."
    else
        local full_command="cd $(pwd) && cd $repo_name && $final_command"
        echo "Executing command: $full_command"
        open_new_terminal "$full_command" "$os_type"
        echo "Starting $repo_name server..."
    fi
}

# First terminal: Clone PiperTTS-API-Wrapper and run npm start
clone_and_run "https://github.com/flukexp/PiperTTS-API-Wrapper.git" "npm start" "$os_type"

# Second terminal: Clone Llamacpp-Server-Installer, set permissions, and run llamacpp.sh
clone_and_run "https://github.com/flukexp/Llamacpp-Server-Installer.git" "chmod +x ./llamacpp.sh && ./llamacpp.sh" "$os_type"
