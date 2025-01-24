# opencv-em

A simple script utility to build with Emscripten OpenCV static libs. You can build the libs by yourself or grab them from a [Release](https://github.com/webarkit/opencv-em/releases)
This project serves to build the OpenCV libraries for [WebARKitLib]([https://](https://github.com/webarkit/WebARKitLib/tree/dev)), but it can be customized to suit your specific needs.

## Building OpenCV with Emscripten

If you want to build the libs, you need Emscripten. Install the emsdk as suggested in the [Emscripten website](https://emscripten.org/docs/getting_started/downloads.html). Then you can clone this repository:

```
git clone https://github.com/webarkit/opencv-em.git
```

you need also to init the OpenCV submodule:

```
git submodule update --init
```
Then you can run the build script (./build.sh) with either `linux` or `emscripten` configuration. 
Note: If you'd like the include file structure to mimic a default OpenCV installation inside the generated archive for emscripten, you'll need to do both and start with a linux build:

```
./build.sh linux
```
Then, move on to the emscripten build:
```
./build.sh emscripten
```

## Pre-built binaries

You don't need to build the libs you can grab from [Releases](https://github.com/webarkit/opencv-em/releases)

## Use of pre-built binaries

You can use FetchContent in a cmake project (CMakeLists.txt):

```cmake
include(FetchContent)

FetchContent_Declare(
  build_opencv
 URL https://github.com/webarkit/opencv-em/releases/download/0.1.6/opencv-4.10.0.zip
)

FetchContent_MakeAvailable(build_opencv)
```

or you can use [curl](https://github.com/curl/curl) or [bootstrapping](https://github.com/corporateshark/bootstrapping) to download the package and make it available to your project.