#!/bin/bash

VSCODE_VSERSION=$1
shift

BASEPATH=$(cd "$(dirname "$0")" && pwd)


PROTABLE_DATA_DIR=$BASEPATH/portable-data
if [ ! -d "$PROTABLE_DATA_DIR" ]; then
    mkdir "$PROTABLE_DATA_DIR"
fi

VSCODE_PATH=$BASEPATH/usr/share/code
USER_DATA_DIR=$PROTABLE_DATA_DIR/user-data
EXTENSIONS_DIR=$PROTABLE_DATA_DIR/extensions

# Check if VSCode path exists
if [ ! -d "$VSCODE_PATH" ]; then
    echo "Error: VSCode path does not exist: $VSCODE_PATH"
    exit 1
fi

# Check if VSCode binary is executable
if [ ! -x "$VSCODE_PATH" ]; then
    echo "Error: VSCode binary is not executable"
    exit 1
fi

# Change to VSCode directory
cd "$VSCODE_PATH" || {
    echo "Error: Cannot change to VSCode directory"
    exit 1
}

# Before launching VSCode, get the list of current Visual Studio Code window IDs.
# This allows us to compare after launch and find the new window to set WM_CLASS only for it.
PRE_WINDOW_IDS=$(xdotool search --name "Visual Studio Code" 2>/dev/null || true)
if [ -z "$PRE_WINDOW_IDS" ]; then
    echo "Pre-launch VSCode window ids: <none>"
else
    echo "Pre-launch VSCode window ids: $PRE_WINDOW_IDS"
fi

# Launch VSCode in the background so subsequent window checks can proceed
./code --user-data-dir="$USER_DATA_DIR" \
       --extensions-dir="$EXTENSIONS_DIR" \
       --disable-updates \
       "$@" 1>/dev/null 2>&1 &

# Try to find the new VSCode window ID within a certain time
# Compare the window ID list before and after launch to identify the new window.
NEW_WINDOW_ID=""
MAX_WAIT=10
SLEEPTIME=0.5
for i in $(seq 1 $MAX_WAIT); do
    sleep $SLEEPTIME
    CUR_IDS=$(xdotool search --name "Visual Studio Code" 2>/dev/null || true)
    # If no VSCode window is found, keep waiting
    if [ -z "$CUR_IDS" ]; then
        continue
    fi

    for id in $CUR_IDS; do
        found=0
        for pid in $PRE_WINDOW_IDS; do
            if [ "$id" = "$pid" ]; then
                found=1
                break
            fi
        done
        # If id is not in the pre-list, treat as new window
        if [ "$found" -eq 0 ]; then
            NEW_WINDOW_ID=$id
            break 2
        fi
    done
done

if [ -n "$NEW_WINDOW_ID" ]; then
    echo "Set WM_CLASS to VSCode-$VSCODE_VSERSION on window id $NEW_WINDOW_ID"
    xprop -id $NEW_WINDOW_ID -f WM_CLASS 8s -set WM_CLASS "VSCode-$VSCODE_VSERSION"
fi

exit 0
