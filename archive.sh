#!/bin/bash
# archive.sh - Compile universal binary, build an Xcode Archive (.xcarchive),
# and copy it to Xcode's Archives folder so it appears in the Xcode Organizer.
set -e

echo "=== Creating Universal Xcode Archive ==="

# 1. Setup temp build directories
BUILD_DIR="build_temp"
rm -rf "$BUILD_DIR" AGQuota.xcarchive
mkdir -p "$BUILD_DIR"

SDK_PATH=$(xcrun --show-sdk-path --sdk macosx)

# 2. Compile for arm64 (Apple Silicon) - target macOS 13.0 to support SMAppService
echo "Compiling for arm64 (Apple Silicon)..."
swiftc -target arm64-apple-macosx13.0 -sdk "$SDK_PATH" -O main.swift -o "$BUILD_DIR/AGQuota_arm64"

# 3. Compile for x86_64 (Intel) - target macOS 13.0 to support SMAppService
echo "Compiling for x86_64 (Intel)..."
swiftc -target x86_64-apple-macosx13.0 -sdk "$SDK_PATH" -O main.swift -o "$BUILD_DIR/AGQuota_x86_64"

# 4. Create Universal Binary using lipo
echo "Creating Universal Binary..."
lipo -create "$BUILD_DIR/AGQuota_arm64" "$BUILD_DIR/AGQuota_x86_64" -output "$BUILD_DIR/AGQuota"

# Verify the architectures
file "$BUILD_DIR/AGQuota"

# 5. Build the AGQuota.app structure inside the archive
ARCHIVE_APP_DIR="AGQuota.xcarchive/Products/Applications/AGQuota.app"
mkdir -p "$ARCHIVE_APP_DIR/Contents/MacOS"
mkdir -p "$ARCHIVE_APP_DIR/Contents/Resources"

mv "$BUILD_DIR/AGQuota" "$ARCHIVE_APP_DIR/Contents/MacOS/"
cp Info.plist "$ARCHIVE_APP_DIR/Contents/"

if [ -f icon.icns ]; then
  cp icon.icns "$ARCHIVE_APP_DIR/Contents/Resources/"
fi

# Clean temp directory
rm -rf "$BUILD_DIR"

# 6. Find valid signing identity and team
echo "Finding valid Apple Development signing identity..."
SIGNING_IDENTITY=$(security find-identity -v -p codesigning | grep "Apple Development:" | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$SIGNING_IDENTITY" ]; then
  echo "Warning: No Apple Development certificate found, falling back to ad-hoc signing."
  SIGNING_IDENTITY="-"
  TEAM_KEY=""
else
  TEAM_ID=$(echo "$SIGNING_IDENTITY" | sed -E 's/.*\(([^)]+)\).*/\1/')
  echo "Found signing identity: $SIGNING_IDENTITY"
  echo "Found Team ID: $TEAM_ID"
  TEAM_KEY="<key>DevelopmentTeam</key>
	<string>$TEAM_ID</string>"
fi

echo "Signing app bundle with identity: $SIGNING_IDENTITY..."
codesign -s "$SIGNING_IDENTITY" --force --options runtime --entitlements AGQuota.entitlements --deep "$ARCHIVE_APP_DIR"

# 7. Generate Info.plist for the archive
CREATION_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat <<EOF > AGQuota.xcarchive/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>ApplicationProperties</key>
	<dict>
		<key>ApplicationPath</key>
		<string>Applications/AGQuota.app</string>
		<key>Architectures</key>
		<array>
			<string>x86_64</string>
			<string>arm64</string>
		</array>
		<key>CFBundleIdentifier</key>
		<string>com.iservice.AGQuota</string>
		<key>CFBundleShortVersionString</key>
		<string>1.1.2</string>
		<key>CFBundleVersion</key>
		<string>18</string>
		<key>SigningIdentity</key>
		<string>$SIGNING_IDENTITY</string>
	</dict>
	<key>ArchiveVersion</key>
	<integer>2</integer>
	<key>CreationDate</key>
	<date>$CREATION_DATE</date>
	$TEAM_KEY
	<key>Name</key>
	<string>AGQuota</string>
	<key>SchemeName</key>
	<string>AGQuota</string>
</dict>
</plist>
EOF

# 8. Copy to Xcode Archives directory
DATE_DIR=$(date +"%Y-%m-%d")
XCODE_ARCHIVES_DIR="$HOME/Library/Developer/Xcode/Archives/$DATE_DIR"
mkdir -p "$XCODE_ARCHIVES_DIR"

TIMESTAMP=$(date +"%d-%m-%Y, %H.%M")
DEST_ARCHIVE="$XCODE_ARCHIVES_DIR/AGQuota $TIMESTAMP.xcarchive"

cp -R AGQuota.xcarchive "$DEST_ARCHIVE"
rm -rf AGQuota.xcarchive

echo "=== Xcode Archive Created Successfully! ==="
echo "Archive placed at: $DEST_ARCHIVE"
echo "It will now appear in your Xcode Organizer window under AGQuota."
