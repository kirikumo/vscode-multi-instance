#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions

# fetch VSCode 1.98.2 deb package (version is stored in VSCODE_VSERSION)
VSCODE_VSERSION=1.98.2

# Resolve the directory this script lives in so paths are robust when installed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEB_FILE="$SCRIPT_DIR/vscode-$VSCODE_VSERSION.deb"

echo "Using script directory: $SCRIPT_DIR"

# download (resume if partially downloaded)
wget -c "https://update.code.visualstudio.com/$VSCODE_VSERSION/linux-deb-x64/stable" -O "$DEB_FILE"

# extract deb package into the script directory
dpkg -x "$DEB_FILE" "$SCRIPT_DIR"

# ensure pixmaps directory exists and copy icon
mkdir -p "$SCRIPT_DIR/usr/share/pixmaps"
cp "$SCRIPT_DIR/vscode_yellow.png" "$SCRIPT_DIR/usr/share/pixmaps/"

# create a desktop file in the script dir (use the version variable)
DESKTOP_FILENAME="vscode-$VSCODE_VSERSION.desktop"
DESKTOP_PATH="$SCRIPT_DIR/$DESKTOP_FILENAME"

cat > "$DESKTOP_PATH" <<EOF
[Desktop Entry]
Name=VSCode $VSCODE_VSERSION
Comment=VSCode Version $VSCODE_VSERSION
GenericName=Text Editor
Exec=$SCRIPT_DIR/start-target-vscode.sh $VSCODE_VSERSION %F
Icon=$SCRIPT_DIR/usr/share/pixmaps/vscode_yellow.png
Type=Application
StartupNotify=false
StartupWMClass=VSCode-$VSCODE_VSERSION
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode-$VSCODE_VSERSION;

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
Exec=$SCRIPT_DIR/start-target-vscode.sh $VSCODE_VSERSION --new-window %F

EOF

# install the desktop file system-wide and update the database
sudo desktop-file-install "$DESKTOP_PATH"
sudo update-desktop-database /usr/share/applications

echo "Installed $DESKTOP_FILENAME"
