#!/bin/sh

#  autobuild.sh
#  SpectrumCodingTest
#
#  Created by Kevin Scardina on 6/14/18.
#  Copyright © 2018 Kevin Scardina. All rights reserved.

# Configure
source configure.sh

# Analyze
source analyze.sh && analyze

# Build
source build.sh && build

# Test
source test.sh && test

# Archive
source archive.sh && archive

# Export
source export_.sh && export_
