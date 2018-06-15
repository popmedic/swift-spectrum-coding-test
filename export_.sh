#!/bin/sh

#  export_.sh
#  UserManager
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

export_(){
    # Copy over iphonesimulator app
    mkdir -p "${ARTIFACTDIR}/simulator/"
    cp -r "${BUILDDIR}/Build/Products/Debug-iphonesimulator/${SCHEME}.app" "${ARTIFACTDIR}/simulator/${SCHEME}.app"
    # Export Adhoc
    xcodebuild \
        -exportArchive \
        -archivePath "${ARTIFACTDIR}${ARCHIVE}" \
        -exportOptionsPlist exportAdhocOptions.plist \
        -exportPath "${ARTIFACTDIR}/adhoc/"
    # Export App Store
    xcodebuild \
        -exportArchive \
        -archivePath "${ARTIFACTDIR}${ARCHIVE}" \
        -exportOptionsPlist exportOptions.plist \
        -exportPath "${ARTIFACTDIR}/appstore/"
}
