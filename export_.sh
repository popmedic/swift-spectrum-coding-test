#!/bin/sh

#  export_.sh
#  SpectrumCodingTest
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

export_(){
    xcodebuild \
        -exportArchive \
        -archivePath "${ARTIFACTDIR}${ARTIFACT}" \
        -exportOptionsPlist exportOptions.plist \
        -exportPath "${ARTIFACTDIR}"
}
