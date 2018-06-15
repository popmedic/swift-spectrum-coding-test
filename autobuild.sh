#!/bin/sh

#  autobuild.sh
#  SpectrumCodingTest
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

BUILDDIR="build/"
ARTIFACTDIR="artifact/"
ARTIFACT="SpectrumCodingTest.xcarchive"
SCHEME="SpectrumCodingTest"
PROJ="SpectrumCodingTest.xcodeproj"

err_report() {
    echo "Error on line $1"
    exit
}

trap 'err_report $LINENO' ERR

# Analyze
xcodebuild \
    -project "${PROJ}" \
    -scheme "${SCHEME}" \
    -sdk iphonesimulator11.2 \
    clean \
    analyze

# Build
xcodebuild \
    -project "${PROJ}" \
    -scheme "${SCHEME}" \
    build \
	CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO

# Test
xcodebuild \
    -project "${PROJ}" \
    -scheme "${SCHEME}" \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 8,OS=11.2' \
    test

# Archive
xcodebuild \
    -project "${PROJ}" \
    -scheme "${SCHEME}" \
    -sdk iphoneos \
    -configuration AppStoreDistribution \
    -archivePath "${ARTIFACTDIR}${ARTIFACT}" \
    archive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO

# Export
xcodebuild \
    -exportArchive \
    -archivePath "${ARTIFACTDIR}${ARTIFACT}" \
    -exportOptionsPlist exportOptions.plist \
    -exportPath "${ARTIFACTDIR}"
