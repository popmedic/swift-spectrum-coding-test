#!/bin/sh

#  test.sh
#  SpectrumCodingTest
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

test(){
    xcodebuild \
        -project "${PROJ}" \
        -scheme "${SCHEME}" \
        -sdk iphonesimulator \
        -destination 'platform=iOS Simulator,name=iPhone 8,OS=11.2' \
        -enableCodeCoverage YES \
        test
}
