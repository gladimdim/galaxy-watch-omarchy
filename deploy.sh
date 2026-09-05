#!/usr/bin/env bash
# ==============================================================================
# Omarchy Galaxy Watch Deployment Helper
# ==============================================================================
set -e

APK_PATH="app/build/outputs/apk/debug/app-debug.apk"

echo "=========================================="
echo "  Omarchy Watch Face Deployment Script    "
echo "=========================================="

if [ ! -f "$APK_PATH" ]; then
    echo "APK not found. Building debug APK first..."
    ./gradlew assembleDebug
fi

echo "Available ADB devices:"
adb devices

echo ""
echo "Select an action:"
echo "1) Sideload watch face APK to connected watch"
echo "2) Pair new watch via Wireless Debugging (Wear OS 4/5)"
echo "3) Connect to watch IP"
echo "4) Rebuild APK and deploy"
echo "5) Exit"
echo ""

read -rp "Enter choice [1-5]: " choice

case "$choice" in
    1)
        echo "Installing $APK_PATH..."
        adb install -r "$APK_PATH"
        echo "✅ Watch face installed successfully!"
        echo "👉 On your Galaxy Watch, long-press the current watch face, swipe right, tap 'Add watch face', and select 'Omarchy'."
        ;;
    2)
        read -rp "Enter Watch IP:Port for pairing (e.g. 192.168.1.50:37123): " pair_addr
        read -rp "Enter 6-digit Wi-Fi pairing code: " pair_code
        adb pair "$pair_addr" "$pair_code"
        echo ""
        read -rp "Now enter the main Wireless Debugging IP:Port (under 'IP address & Port'): " conn_addr
        adb connect "$conn_addr"
        echo "Connected! Installing APK..."
        adb install -r "$APK_PATH"
        ;;
    3)
        read -rp "Enter Watch IP:Port (e.g. 192.168.1.50:5555): " conn_addr
        adb connect "$conn_addr"
        adb devices
        ;;
    4)
        echo "Building fresh APK..."
        ./gradlew assembleDebug
        echo "Installing..."
        adb install -r "$APK_PATH"
        echo "✅ Done!"
        ;;
    5)
        exit 0
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac
