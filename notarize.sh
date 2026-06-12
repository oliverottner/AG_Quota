#!/bin/bash
# notarize.sh - Package, Sign, Notarize, and Staple AGQuota for external sharing
set -e

# ==============================================================================
# CONFIGURATION
# Replace these with your actual Apple Developer account details
# ==============================================================================
DEVELOPER_ID_IDENTITY="Developer ID Application: Oliver Ottner (XXXXXXXXXX)"
KEYCHAIN_PROFILE_NAME="notary-profile" # Recommended: Store credentials using: xcrun notarytool store-credentials
# Alternatively, you can use:
# APPLE_ID="your-apple-id@email.com"
# TEAM_ID="XXXXXXXXXX"
# PASSWORD="your-app-specific-password"
# ==============================================================================

echo "=== Starting Release & Notarization Build ==="

# 1. Clean previous build
echo "Cleaning previous builds..."
rm -rf AGQuota AGQuota.app AGQuota.zip

# 2. Compile Swift source with optimization
echo "Compiling Swift source in release mode..."
SDK_PATH=$(xcrun --show-sdk-path --sdk macosx)
swiftc -O -sdk "$SDK_PATH" main.swift -o AGQuota

# 3. Create app bundle structure
echo "Packaging into AGQuota.app bundle..."
mkdir -p AGQuota.app/Contents/MacOS
mkdir -p AGQuota.app/Contents/Resources
mv AGQuota AGQuota.app/Contents/MacOS/
cp Info.plist AGQuota.app/Contents/

if [ -f icon.icns ]; then
  echo "Copying application icon..."
  cp icon.icns AGQuota.app/Contents/Resources/
fi

# 4. Codesign with Developer ID Identity and Secure Timestamp
echo "Signing app with Developer ID Identity: $DEVELOPER_ID_IDENTITY..."
codesign --force --options runtime --deep --sign "$DEVELOPER_ID_IDENTITY" --timestamp AGQuota.app

# 5. Verify local signature
echo "Verifying signature..."
codesign --verify --verbose AGQuota.app
spctl --assess --verbose --type execute AGQuota.app

# 6. Compress App for Notarization
echo "Compressing app bundle..."
ditto -c -k --keepParent AGQuota.app AGQuota.zip

# 7. Submit to Apple Notary Service
echo "Submitting to Apple Notary Service..."
# Note: This assumes you have stored your credentials using:
# xcrun notarytool store-credentials "notary-profile" --apple-id "..." --team-id "..."
# If you prefer using environment variables or raw arguments, modify the command below.
xcrun notarytool submit AGQuota.zip --keychain-profile "$KEYCHAIN_PROFILE_NAME" --wait

# 8. Staple the notarization ticket to the App
echo "Stapling notarization ticket..."
xcrun stapler staple AGQuota.app

# 9. Final Verification
echo "Verifying final notarization status..."
spctl --assess --verbose --type execute AGQuota.app

echo "=== Release Build Complete and Notarized! ==="
echo "You can now distribute AGQuota.app or AGQuota.zip to other users."
