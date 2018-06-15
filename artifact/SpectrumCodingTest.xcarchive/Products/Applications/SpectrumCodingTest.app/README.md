# Spectrum's Coding Test for iOS

## Objective

To fulfill the requirements in [this document](My_Spectrum_-_Xamarin_Test.pdf).

## Requirements

- XCode version 9.2
- Command line tools

## Build

### From XCode

1) Load the project file [SpectrumCodingTest.xcodeproj](SpectrumCodingTest.xcodeproj/) into XCode  
2) Select the SpectrumCodingTest scheme
3) Select what device you would like to run on
4) Click on the XCode's run button

### From the Terminal

From the terminal you can analyze, build, test, archive, export, or autobuild the entire project.  Start by `cd` to the project directory (the directory with [SpectrumCodingTest.xcodeproj](SpectrumCodingTest.xcodeproj/) in it)

**Analyze**

This will use XCode's static analysis on the project.

```
source configure.sh && \
source analyze.sh && \
analyze
```

**Build**

This will build the project without using any code signing.

```
source configure.sh && \
source build.sh && \
build
```

**Test**

This will run the unit test in the project.

```
source configure.sh && \
source test.sh && \
test
```

**Archive**

This will generate an non-codesigned archive of the project in `${PROJECT_DIR}/archive/SpectrumCodingTest.xcarchive`.

```
source configure.sh && \
source archive.sh && \
archive.sh
```