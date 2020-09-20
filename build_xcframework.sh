#!/bin/bash

PROJECT_FILE="LTMorphingLabelDemo.xcodeproj"
SCHEME="LTMorphingLabel"
BUILD_FOLDER="Build/MorphingLabel"

mkdir -p Build

iOS Simulator
xcodebuild archive -project "$PROJECT_FILE" -scheme "$SCHEME" -configuration Release \
	-archivePath "$BUILD_FOLDER/Simulator" \
	-sdk iphonesimulator \
	SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# iOS
xcodebuild archive -project "$PROJECT_FILE" -scheme "$SCHEME" -configuration Release \
	-archivePath "$BUILD_FOLDER/iOS" \
	-sdk iphoneos \
	SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# tvOS
xcodebuild archive -project "$PROJECT_FILE" -scheme "$SCHEME" -configuration Release \
	-archivePath "$BUILD_FOLDER/tvOS" \
	-sdk appletvos \
	SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# tvOS Simulator
xcodebuild archive -project "$PROJECT_FILE" -scheme "$SCHEME" -configuration Release \
	-archivePath "$BUILD_FOLDER/tvOSSimulator" \
	-sdk appletvsimulator \
	SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# XCFramework
xcodebuild -create-xcframework \
	-framework "$BUILD_FOLDER/iOS.xcarchive/Products/Library/Frameworks/MorphingLabel.framework" \
	-framework "$BUILD_FOLDER/tvOS.xcarchive/Products/Library/Frameworks/MorphingLabel.framework" \
	-framework "$BUILD_FOLDER/Simulator.xcarchive/Products/Library/Frameworks/MorphingLabel.framework" \
	-framework "$BUILD_FOLDER/tvOSSimulator.xcarchive/Products/Library/Frameworks/MorphingLabel.framework" \
	-output Build/LTMorphingLabel.xcframework

cd Build

# Compress
zip -vry LTMorphingLabel.xcframework.zip LTMorphingLabel.xcframework/ -x "*.DS_Store"

# Checksum for Package.swift
swift package compute-checksum LTMorphingLabel.xcframework.zip

# Open in Finder
open ./
