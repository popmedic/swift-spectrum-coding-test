#!/bin/sh

#  configure.sh
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
