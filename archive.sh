#!/bin/sh

#  archive.sh
#  UserManager
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

archive(){
    xcodebuild \
        -project "${PROJ}" \
        -scheme "${SCHEME}" \
        -sdk iphoneos \
        -configuration Release \
        -archivePath "${ARTIFACTDIR}${ARTIFACT}" \
        archive \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO
}
