#!/bin/sh

#  analyze.sh
#  UserManager
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

analyze(){
    xcodebuild \
        -project "${PROJ}" \
        -scheme "${SCHEME}" \
        -sdk iphonesimulator11.2 \
        clean \
        analyze
}
