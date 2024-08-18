
# Automated Repository Setup and Command Execution

This script automates the process of cloning repositories and running specific commands in new terminal windows. It supports both macOS and WSL (Windows Subsystem for Linux) environments.

## Features

- **Check for Existing Repositories**: Avoids re-cloning if a repository already exists in the working directory.
- **Open New Terminals**: Runs commands in new terminal windows on macOS and WSL.
- **Clone and Run**: Clones specified repositories and executes provided commands.

## Requirements

- **macOS**: Uses `osascript` to open new Terminal windows.
- **WSL (Windows Subsystem for Linux)**: Uses `cmd.exe` to start `wsl.exe` for command execution in new terminals.

## Script Functions

1. **command_exists()**: Checks if a command is available on the system.
2. **is_wsl()**: Determines if the script is running under WSL.
3. **check_repo_exists()**: Checks if a specified repository is already cloned.
4. **open_new_terminal()**: Opens a new terminal window and runs the provided command.
5. **clone_and_run()**: Clones a repository and runs a command in a new terminal.

## Usage

1. **Ensure Git is Installed**: The script uses Git to clone repositories.
2. **Set Execute Permissions**: Make the script executable with the following command:
   ```bash
   chmod +x start.sh
   ```

3. **Run the Script**: Execute the script with:
   ```bash
   ./start.sh
   ```

## Repositories and Commands

- **PiperTTS-API-Wrapper**: Clones the PiperTTS-API-Wrapper repository and runs `npm start` in a new terminal.
- **Llamacpp-Server-Installer**: Clones the Llamacpp-Server-Installer repository, sets permissions for `llamacpp.sh`, and runs the script in a new terminal.

## Notes

- On macOS, the script uses `osascript` to open new Terminal windows.
- On WSL, it uses `cmd.exe` to start `wsl.exe` for running commands in new terminals.
- Ensure you have the necessary permissions and dependencies installed for the repositories and commands to work properly.
