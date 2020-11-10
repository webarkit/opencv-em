# opencv-em

A simple script utility to build with Emscripten OpenCV static libs. You can build the libs by yourself or grab them from a [Release](https://github.com/webarkit/opencv-em/releases)

## Building OpenCV with Emscripten

If you want to build the libs, you need Emscripten. Install the emsdk as suggested in the [Emscripten website](https://emscripten.org/docs/getting_started/downloads.html). Then you can clone this repository:

```
git clone https://github.com/webarkit/opencv-em.git
```

you need also to init the OpenCV submodule:

```
git submodule update --init
```
Then you can run the build script:

```
./build.sh
```

## Pre-built binaries

You don't need to build the libs you can grab from [Release](https://github.com/webarkit/opencv-em/releases)
