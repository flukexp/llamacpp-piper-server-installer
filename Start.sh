#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "${BLUE}==================== $1 ====================${NC}"
}

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error occurred: $1${NC}"
        exit 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if git is installed
check_git() {
    if command_exists git; then
        echo -e "${GREEN}Git is installed.${NC}"
    else
        echo -e "${RED}Git is not installed. Please install Git first.${NC}"
        exit 1
    fi
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
        echo -e "${YELLOW}Repository $repo_name already exists. Skipping clone.${NC}"
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
        end tell
        "
    elif [[ $os == Linux && is_wsl ]]; then
        # WSL - using cmd.exe to run commands in new terminal instances
        cmd.exe /c start wsl.exe -e bash -c "$command"
    else
        echo -e "${RED}Unsupported OS for opening new terminals.${NC}"
        exit 1
    fi
}

# Function to construct the command to clone a repository and run commands
clone_and_run() {
    local repo_url=$1
    local final_command=$2
    local repo_name=$(basename "$repo_url" .git)
    
    # Check if repository directory already exists
    if check_repo_exists "$repo_name"; then
        local full_command="cd $(pwd) && git clone $repo_url && cd $repo_name && $final_command"
        echo -e "${BLUE}Executing command: $full_command${NC}"
        open_new_terminal "$full_command"
        echo -e "${GREEN}Starting $repo_name server...${NC}"
    else
        local full_command="cd $(pwd) && cd $repo_name && $final_command"
        echo -e "${BLUE}Executing command: $full_command${NC}"
        open_new_terminal "$full_command"
        echo -e "${GREEN}Starting $repo_name server...${NC}"
    fi
}

# Print header for setup
print_header "Starting Installer Script"

# Check if Git is installed
check_git

# First terminal: Clone PiperTTS-API-Wrapper and run piper_installer.sh
print_header "Setting up PiperTTS-API-Wrapper"
clone_and_run "https://github.com/flukexp/PiperTTS-API-Wrapper.git" "chmod +x ./piper_installer.sh && ./piper_installer.sh"

# Second terminal: Clone Llamacpp-Server-Installer, set permissions, and run llamacpp.sh
print_header "Setting up Llamacpp-Server-Installer"
clone_and_run "https://github.com/flukexp/Llamacpp-Server-Installer.git" "chmod +x ./llamacpp.sh && ./llamacpp.sh"

echo -e "${GREEN}Setup complete. All commands executed successfully.${NC}"
