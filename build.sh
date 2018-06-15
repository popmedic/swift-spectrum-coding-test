#!/bin/sh

#  build.sh
#  UserManager
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

build(){
    xcodebuild \
        -project "${PROJ}" \
        -scheme "${SCHEME}" \
        -derivedDataPath "${BUILDDIR}" \
        build \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO
}
