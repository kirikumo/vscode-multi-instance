#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions

# Check for required tools
for cmd in wget dpkg xdotool; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command '$cmd' not found."
        echo "Please install it first."
        exit 1
    fi
done

# fetch VSCode deb package
VSCODE_VERSION=1.98.2
ICON_NAME="vscode_yellow.png"

# Resolve the directory this script lives in so paths are robust when installed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEB_FILE="$SCRIPT_DIR/vscode-$VSCODE_VERSION.deb"

echo "Using script directory: $SCRIPT_DIR"

# download (resume if partially downloaded)
echo "Downloading VSCode $VSCODE_VERSION..."
if ! wget -c "https://update.code.visualstudio.com/$VSCODE_VERSION/linux-deb-x64/stable" -O "$DEB_FILE"; then
    echo "Error: Failed to download VSCode"
    rm -f "$DEB_FILE"
    exit 1
fi

# extract deb package into the script directory
echo "Extracting package..."
if ! dpkg -x "$DEB_FILE" "$SCRIPT_DIR"; then
    echo "Error: Failed to extract package"
    exit 1
fi

# ensure pixmaps directory exists and copy icon
mkdir -p "$SCRIPT_DIR/usr/share/pixmaps"
if [ ! -f "$SCRIPT_DIR/$ICON_NAME" ]; then
    echo "Error: Custom icon '$ICON_NAME' not found"
    exit 1
fi
cp "$SCRIPT_DIR/$ICON_NAME" "$SCRIPT_DIR/usr/share/pixmaps/"

# check if code binary is present and executable
if [ ! -x "$SCRIPT_DIR/usr/share/code/code" ]; then
    echo "Error: VSCode binary not found or not executable"
    exit 1
fi

# create a desktop file in the script dir
DESKTOP_FILENAME="vscode-$VSCODE_VERSION.desktop"
DESKTOP_PATH="$SCRIPT_DIR/$DESKTOP_FILENAME"

echo "Creating desktop entry..."
cat > "$DESKTOP_PATH" <<EOF
[Desktop Entry]
Name=VSCode $VSCODE_VERSION
Comment=VSCode Version $VSCODE_VERSION
GenericName=Text Editor
Exec=$SCRIPT_DIR/start-target-vscode.sh $VSCODE_VERSION %F
Icon=$SCRIPT_DIR/usr/share/pixmaps/$ICON_NAME
Type=Application
StartupNotify=false
StartupWMClass=VSCode-$VSCODE_VERSION
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode-$VSCODE_VERSION;

[Desktop Action new-empty-window]
Name=New Empty Window
Name[cs]=Nové prázdné okno
Name[de]=Neues leeres Fenster
Name[es]=Nueva ventana vacía
Name[fr]=Nouvelle fenêtre vide
Name[it]=Nuova finestra vuota
Name[ja]=新しい空のウィンドウ
Name[ko]=새 빈 창
Name[ru]=Новое пустое окно
Name[zh_CN]=新建空窗口
Name[zh_TW]=開新空視窗
Exec=$SCRIPT_DIR/start-target-vscode.sh $VSCODE_VERSION --new-window %F

EOF

# install the desktop file system-wide and update the database
sudo desktop-file-install "$DESKTOP_PATH"
sudo update-desktop-database /usr/share/applications

echo "Installed $DESKTOP_FILENAME"
