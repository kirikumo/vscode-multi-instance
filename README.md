# VSCode Portable Setup

This project is a set of scripts for quickly setting up a portable installation of Visual Studio Code 1.98.2 for Linux, including a custom desktop launcher and user data isolation. It is not a full distribution—just an automation tool for easy setup.

> **Note:** The version "1.98.2" is used here as a demo. You can replace it with any other VSCode version by updating the scripts and filenames accordingly.

## Features

- Portable: All user data and extensions are stored in the `portable-data` directory.
- Custom icon and desktop entry for easy launching.
- No system-wide installation required (except for desktop integration).
- Supports multiple VSCode versions side-by-side.

## Setup Instructions

1. **Download and Extract**
   - Place all files in a directory of your choice.
   - If you want to use a different VSCode version, update the version number in `setup-1_98_2.sh`.

2. **Run the Setup Script**

   ```bash
   bash setup-1_98_2.sh
   ```

   This will:
   - Download the VSCode 1.98.2 `.deb` package (or your chosen version)
   - Extract it locally
   - Change vscode icon to `vscode_yellow.png`
   - Generate a desktop entry (e.g., `vscode-1.98.2.desktop`)
   - Install the desktop entry (requires `sudo`)

3. **Launch VSCode**
   - Use the desktop menu entry: **VSCode 1.98**
   - Or run directly:

     ```bash
     bash start-target-vscode.sh 1.98.2
     ```

## File Overview

- `setup-1_98_2.sh` — Main setup script (download, extract, desktop integration)
- `start-target-vscode.sh` — Launch script (sets up portable data, WM_CLASS, etc.)
- `vscode_yellow.png` — Custom icon
- `vscode-1.98.2.desktop` — Generated desktop entry
- `portable-data/` — User data and extensions are stored here
- `usr/` — Extracted VSCode files

## Notes

- The desktop entry uses the custom icon and ensures each VSCode window is uniquely identified by version.
- You can run multiple portable VSCode versions by duplicating this folder and updating the version in the scripts and filenames.
- No files are installed outside this directory except the desktop entry and icon (for menu integration).

## Uninstall

To remove the desktop entry:

```bash
sudo rm /usr/share/applications/vscode-1.98.2.desktop
sudo update-desktop-database /usr/share/applications
```
