#!/bin/bash

# Source icon path
ICON="assets/icon.png"

# Verify icon exists
if [ ! -f "$ICON" ]; then
    echo "Error: $ICON not found!"
    exit 1
fi

echo "Generating Android icons..."
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi

sips -z 48 48 "$ICON" --out android/app/src/main/res/mipmap-mdpi/ic_launcher.png
sips -z 72 72 "$ICON" --out android/app/src/main/res/mipmap-hdpi/ic_launcher.png
sips -z 96 96 "$ICON" --out android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
sips -z 144 144 "$ICON" --out android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
sips -z 192 192 "$ICON" --out android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

echo "Generating iOS icons (simplified set)..."
mkdir -p ios/Runner/Assets.xcassets/AppIcon.appiconset

# Base sizes for iOS
sips -z 20 20 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png
sips -z 40 40 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png
sips -z 60 60 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png
sips -z 29 29 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png
sips -z 58 58 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png
sips -z 87 87 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png
sips -z 40 40 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png
sips -z 80 80 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png
sips -z 120 120 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png
sips -z 120 120 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png
sips -z 180 180 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png
sips -z 76 76 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png
sips -z 152 152 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png
sips -z 167 167 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png
sips -z 1024 1024 "$ICON" --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png

echo "Generating Web icons..."
sips -z 16 16 "$ICON" --out web/favicon.png
sips -z 192 192 "$ICON" --out web/icons/Icon-192.png
sips -z 512 512 "$ICON" --out web/icons/Icon-512.png
sips -z 192 192 "$ICON" --out web/icons/Icon-maskable-192.png
sips -z 512 512 "$ICON" --out web/icons/Icon-maskable-512.png

echo "Icons generated successfully!"
