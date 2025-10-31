# VSCode Multi-Instance Setup

This project provides scripts for quickly setting up multiple portable instances of Visual Studio Code with version isolation. Each instance runs independently with its own user data, extensions, and window identification. Currently configured for version 1.98.2 as an example.

> **Note:** You can create multiple instances with different versions by copying the scripts and updating the version numbers. Each instance maintains separate settings and extensions.

## Features

- Portable: All user data and extensions are stored in the `portable-data` directory.
- Custom icon and desktop entry for easy launching.
- No system-wide installation required (except for desktop integration).
- Supports multiple VSCode versions side-by-side.

## Setup Instructions

1. **Clone and Configure**

   ```bash
   git clone https://github.com/kirikumo/vscode-multi-instance.git
   cd vscode-multi-instance
   ```

2. **Run the Setup Script**

   ```bash
   bash setup-1_98_2.sh
   ```

   This script will:
   - Download VSCode 1.98.2 `.deb` package
   - Extract it locally into `usr/`
   - Set up a yellow icon for easy identification
   - Create and install a desktop entry with unique window class

3. **Launch VSCode**
   - Use the desktop menu entry: **VSCode 1.98**
   - Or run directly:

     ```bash
     bash start-target-vscode.sh 1.98.2
     ```

## Project Structure

- `setup-1_98_2.sh` — Setup script that downloads and configures VSCode
- `start-target-vscode.sh` — Launch script with version isolation and window management
- `vscode_yellow.png` — Custom icon for easy identification
- `portable-data/` — Contains isolated user data and extensions
- `usr/` — Contains the extracted VSCode installation
- `vscode-1.98.2.deb` — Downloaded VSCode package
- `vscode-1.98.2.desktop` — Generated desktop entry with unique window class

## Key Features Explained

- **Version Isolation**: Each instance has its own settings, extensions, and window identification
- **Custom Window Class**: Uses `WM_CLASS` to help window managers identify different versions
- **Portable Data**: All user data and extensions are contained in `portable-data/`
- **Desktop Integration**: Only the `.desktop` file is installed system-wide for launcher integration
- **Multiple Instances**: Create more instances by copying the directory and updating version numbers

## Cleanup

To remove the desktop entry:

```bash
sudo rm /usr/share/applications/vscode-1.98.2.desktop
sudo update-desktop-database /usr/share/applications
```
