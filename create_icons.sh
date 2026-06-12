#!/bin/bash
set -e

PNG_PATH="$1"
if [ -z "$PNG_PATH" ]; then
  echo "Usage: $0 <path_to_png>"
  exit 1
fi

echo "Creating iconset directory..."
rm -rf icon.iconset
mkdir -p icon.iconset

echo "Resizing images using sips..."
sips -s format png -z 16 16     "$PNG_PATH" --out icon.iconset/icon_16x16.png >/dev/null
sips -s format png -z 32 32     "$PNG_PATH" --out icon.iconset/icon_16x16@2x.png >/dev/null
sips -s format png -z 32 32     "$PNG_PATH" --out icon.iconset/icon_32x32.png >/dev/null
sips -s format png -z 64 64     "$PNG_PATH" --out icon.iconset/icon_32x32@2x.png >/dev/null
sips -s format png -z 128 128   "$PNG_PATH" --out icon.iconset/icon_128x128.png >/dev/null
sips -s format png -z 256 256   "$PNG_PATH" --out icon.iconset/icon_128x128@2x.png >/dev/null
sips -s format png -z 256 256   "$PNG_PATH" --out icon.iconset/icon_256x256.png >/dev/null
sips -s format png -z 512 512   "$PNG_PATH" --out icon.iconset/icon_256x256@2x.png >/dev/null
sips -s format png -z 512 512   "$PNG_PATH" --out icon.iconset/icon_512x512.png >/dev/null
sips -s format png -z 1024 1024 "$PNG_PATH" --out icon.iconset/icon_512x512@2x.png >/dev/null

echo "Compiling to icon.icns..."
iconutil -c icns icon.iconset -o icon.icns

echo "Cleaning up..."
rm -rf icon.iconset

echo "Icon generated successfully!"
