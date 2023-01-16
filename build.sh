#! /bin/bash

# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage () {
    echo "Usage: $(basename $0) (cmake | python)"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

# -e = exit on errors
set -e

while test $# -gt 0
do
    case "$1" in
        cmake) BUILD_CMAKE=1
            ;;
        python) BUILD_PYTHON=1
            ;;
        --*) echo "bad option $1"
            usage
            ;;
        *) echo "bad argument $1"
            usage
            ;;
    esac
    shift
done

BUILD_HOME="${OURDIR}/opencv/build_wasm"
if [ $BUILD_PYTHON ] ; then
BUILD_NAME="opencv-js"
else
BUILD_NAME="opencv-em"
fi
VERSION="4.5.0-emcc-3.1.26"
BUILD_NAME_VERSION=${BUILD_NAME}-${VERSION}

EM_FLAGS="-s WASM=1 -s USE_PTHREADS=0 "
EM_TOOLCHAIN="$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake"
OPENCV_INTRINSICS="-DCV_ENABLE_INTRINSICS=OFF -DCPU_BASELINE="" -DCPU_DISPATCH="""
OPENCV_DEFINES="-DENABLE_PIC=FALSE"
OPENCV_EXCLUDE="-DBUILD_SHARED_LIBS=OFF -DWITH_1394=OFF -DWITH_ADE=OFF -DWITH_VTK=OFF -DWITH_EIGEN=OFF -DWITH_FFMPEG=OFF -DWITH_GSTREAMER=OFF -DWITH_GTK=OFF -DWITH_GTK_2_X=OFF -DWITH_IPP=OFF -DWITH_JASPER=OFF -DWITH_JPEG=OFF -DWITH_WEBP=OFF -DWITH_OPENEXR=OFF -DWITH_OPENGL=OFF -DWITH_OPENVX=OFF -DWITH_OPENNI=OFF -DWITH_OPENNI2=OFF -DWITH_PNG=OFF -DWITH_TBB=OFF -DWITH_TIFF=OFF -DWITH_V4L=OFF -DWITH_OPENCL=OFF -DWITH_OPENCL_SVM=OFF -DWITH_OPENCLAMDFFT=OFF -DWITH_OPENCLAMDBLAS=OFF -DWITH_GPHOTO2=OFF -DWITH_LAPACK=OFF -DWITH_ITT=OFF -DWITH_QUIRC=OFF -DCV_TRACE=OFF"
OPENCV_INCLUDE="-DBUILD_ZLIB=ON"
OPENCV_MODULES_EXCLUDE="-DBUILD_opencv_imgcodecs=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_shape=OFF -DBUILD_opencv_shape=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_superres=OFF -DBUILD_opencv_videostab=OFF"
OPENCV_MODULES_INCLUDE="-DBUILD_opencv_calib3d=ON -DBUILD_opencv_dnn=ON -DBUILD_opencv_features2d=ON -DBUILD_opencv_flann=ON -DBUILD_opencv_objdetect=ON -DBUILD_opencv_photo=ON "
# OPENCV_JS="-DBUILD_opencv_js=ON "
OPENCV_CONF="${OPENCV_DEFINES} ${OPENCV_EXCLUDE} ${OPENCV_INCLUDE} ${OPENCV_MODULES_EXCLUDE} ${OPENCV_MODULES_INCLUDE} ${OPENCV_JS} -DBUILD_opencv_apps=OFF -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_IPP_IW=OFF -DBUILD_PACKAGE=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_WITH_DEBUG_INFO=OFF -DWITH_PTHREADS_PF=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF"

echo "Building OpenCV for the web with Emscripten"

cd opencv
if [ ! -d "build_wasm" ] ; then
  mkdir build_wasm
fi

if [ $BUILD_PYTHON ] ; then
  python ./platforms/js/build_js.py build_wasm --build_wasm
fi
# /BUILD_PYTHON

if [ $BUILD_CMAKE ] ; then
  cd ${OURDIR}/opencv/build_wasm
  cmake .. -GNinja -DCMAKE_TOOLCHAIN_FILE=$EM_TOOLCHAIN $OPENCV_CONF $OPENCV_INTRINSICS -DCMAKE_CXX_FLAGS="$EM_FLAGS" -DCMAKE_C_FLAGS="$EM_FLAGS"
  ninja -v
fi
# /BUILD_CMAKE

echo "Opencv.js and static libs successfully built!"
echo "Packagings libs and includes in a .zip file"

cd ${OURDIR}
    TARGET_DIR="./packaging/build_wasm"
    if [ -d ${TARGET_DIR} ] ; then
        rm -rf ${TARGET_DIR}
    fi

    # in case we need excludes later: --exclude-from=${OURDIR}/android/excludes
    if [ $BUILD_CMAKE ] ; then
      rsync -ar --files-from=./packaging/bom-cmake ${BUILD_HOME} ${TARGET_DIR}
    fi
    if [[ $BUILD_PYTHON ]]; then
      rsync -ar --files-from=./packaging/bom-python ${BUILD_HOME} ${TARGET_DIR}
    fi

    destdir=${TARGET_DIR}/em-flags.txt
    touch $destdir

    if [ -f "$destdir" ]
    then
        echo "Writing file"
        echo "$EM_FLAGS" > "$destdir"
    fi

    # TODO: copy and zip all the includes
    rsync -ra -R opencv/modules/calib3d/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/core/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/dnn/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/features2d/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/flann/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/imgproc/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/objdetect/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/photo/include ${TARGET_DIR}
    rsync -ra -R opencv/modules/video/include ${TARGET_DIR}
    rsync -ra -R opencv/include/opencv2 ${TARGET_DIR}

    #Package all into a zip file
    cd ./packaging/
    zip --filesync -r "${BUILD_NAME_VERSION}.zip" ./build_wasm
    #Clean up
    cd ..
    # rm -rf ${TARGET_DIR}
