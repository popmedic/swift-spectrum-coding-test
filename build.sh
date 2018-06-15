#!/bin/sh

#  build.sh
#  SpectrumCodingTest
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

build(){
    xcodebuild \
        -project "${PROJ}" \
        -scheme "${SCHEME}" \
        build \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO
}
