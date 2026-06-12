#!/bin/bash
set -e

echo "=== Building AGQuota Menu Bar App ==="

# 1. Clean previous build if any
rm -rf AGQuota AGQuota.app

# 2. Compile Swift source
echo "Compiling Swift source..."
SDK_PATH=$(xcrun --show-sdk-path --sdk macosx)
swiftc -sdk "$SDK_PATH" main.swift -o AGQuota

# 3. Create app bundle structure
echo "Packaging into AGQuota.app bundle..."
mkdir -p AGQuota.app/Contents/MacOS
mkdir -p AGQuota.app/Contents/Resources
mv AGQuota AGQuota.app/Contents/MacOS/
cp Info.plist AGQuota.app/Contents/

# Copy icon if it exists
if [ -f icon.icns ]; then
  echo "Copying application icon..."
  cp icon.icns AGQuota.app/Contents/Resources/
fi

# 4. Codesign locally
echo "Codesigning app bundle..."
codesign -s - --force --deep AGQuota.app

# 5. Relaunch app
echo "Restarting application..."
killall AGQuota 2>/dev/null || true
open AGQuota.app || true

echo "=== Build and Run Successful! ==="
