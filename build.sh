#! /bin/bash

# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage () {
    echo "Usage: $(basename $0) (linux | emscripten)"
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
        linux) BUILD_CMAKE=1
            ;;
        emscripten) BUILD_PYTHON=1
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

BUILD_HOME=" "
if [ $BUILD_PYTHON ] ; then
    BUILD_HOME="${OURDIR}/opencv_js"
else
    BUILD_HOME="${OURDIR}/libs/opencv/build_wasm"
fi

if [ $BUILD_PYTHON ] ; then
BUILD_NAME="opencv-js"
else
BUILD_NAME="opencv"
fi

OPENCV_VERSION="4.7.0"
VERSION=""
if [ $BUILD_PYTHON ] ; then
    VERSION="${OPENCV_VERSION}-emcc-3.1.26"
else
    VERSION=${OPENCV_VERSION}
fi

BUILD_NAME_VERSION=${BUILD_NAME}-${VERSION}

COMPILATION_FLAGS=" -std=c++14"
EM_TOOLCHAIN="$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake"
OPENCV_INTRINSICS="-DCV_ENABLE_INTRINSICS=OFF -DCPU_BASELINE="" -DCPU_DISPATCH="""
OPENCV_DEFINES="-DENABLE_PIC=FALSE"
OPENCV_EXCLUDE="-DBUILD_SHARED_LIBS=OFF -DBUILD_JAVA=OFF -DWITH_1394=OFF -DWITH_ADE=OFF -DWITH_VTK=OFF -DWITH_EIGEN=OFF -DWITH_FFMPEG=OFF -DWITH_GSTREAMER=OFF -DWITH_GTK=OFF -DWITH_GTK_2_X=OFF -DWITH_IPP=OFF -DWITH_JASPER=OFF -DWITH_JPEG=OFF -DWITH_WEBP=OFF -DWITH_OPENEXR=OFF -DWITH_OPENGL=OFF -DWITH_OPENVX=OFF -DWITH_OPENNI=OFF -DWITH_OPENNI2=OFF -DWITH_PNG=OFF -DWITH_TBB=OFF -DWITH_TIFF=OFF -DWITH_V4L=OFF -DWITH_OPENCL=OFF -DWITH_OPENCL_SVM=OFF -DWITH_OPENCLAMDFFT=OFF -DWITH_OPENCLAMDBLAS=OFF -DWITH_GPHOTO2=OFF -DWITH_LAPACK=OFF -DWITH_ITT=OFF -DWITH_QUIRC=OFF -DCV_TRACE=OFF"
OPENCV_INCLUDE="-DBUILD_ZLIB=ON"
OPENCV_MODULES_EXCLUDE="-DBUILD_opencv_dnn=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_imgcodecs=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_python3=OFF -DBUILD_opencv_shape=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_superres=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_videostab=OFF"
OPENCV_MODULES_INCLUDE="-DBUILD_opencv_calib3d=ON -DBUILD_opencv_core=ON -DBUILD_opencv_features2d=ON -DBUILD_opencv_flann=ON -DBUILD_opencv_video=ON "
OPENCV_EXTRA_MODULES_EXCLUDE="-DBUILD_opencv_bgsegm=OFF -DBUILD_opencv_bioinspired=OFF -DBUILD_opencv_fuzzy=OFF -DBUILD_opencv_hfs=OFF -DBUILD_opencv_img_hash=OFF -DBUILD_opencv_intensity_transform=OFF -DBUILD_opencv_line_descriptor=OFF -DBUILD_opencv_optflow=OFF -DBUILD_opencv_phase_unwrapping=OFF -DBUILD_opencv_plot=OFF -DBUILD_opencv_rapid=OFF -DBUILD_opencv_reg=OFF -DBUILD_opencv_rgbd=OFF -DBUILD_opencv_saliency=OFF -DBUILD_opencv_stereo=OFF -DBUILD_opencv_structured_light=OFF -DBUILD_opencv_surface_matching=OFF -DBUILD_opencv_tracking=OFF -DBUILD_opencv_ximgproc=OFF -DBUILD_opencv_xobjdetect=OFF -DBUILD_opencv_xphoto=OFF" 
OPENCV_EXTRA_MODULES_INCLUDE="-DBUILD_opencv_xfeatures2d=ON "
OPENCV_EXTRA_MODULES_PATH="-DOPENCV_EXTRA_MODULES_PATH=../../libs/opencv_contrib/modules"
OPENCV_CONF="${OPENCV_DEFINES} ${OPENCV_EXCLUDE} ${OPENCV_INCLUDE} ${OPENCV_MODULES_EXCLUDE} ${OPENCV_EXTRA_MODULES_INCLUDE} ${OPENCV_EXTRA_MODULES_EXCLUDE} ${OPENCV_MODULES_INCLUDE} ${OPENCV_EXTRA_MODULES}  -DBUILD_opencv_apps=OFF -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_IPP_IW=OFF -DBUILD_PACKAGE=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_WITH_DEBUG_INFO=OFF -DWITH_PTHREADS_PF=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF"

if [ $BUILD_PYTHON ] ; then
  echo "Building OpenCV for the web with Emscripten"
  docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) -e "EMSCRIPTEN=/emsdk/upstream/emscripten"  emscripten/emsdk:3.1.26 emcmake python3 ./libs/opencv/platforms/js/build_js.py opencv_js --config="./opencv.webarkit_config.py" --build_wasm --cmake_option="-DBUILD_opencv_dnn=OFF"  --cmake_option="-DBUILD_opencv_objdetect=OFF" --cmake_option="-DBUILD_opencv_photo=OFF" --cmake_option="-DBUILD_opencv_imgcodecs=ON" --cmake_option="-DBUILD_opencv_xfeatures2d=ON"  --cmake_option="-DOPENCV_EXTRA_MODULES_PATH=./../libs/opencv_contrib/modules/" --build_flags="-Oz -s EXPORT_ES6=1 -s USE_ES6_IMPORT_META=0"
fi
# /BUILD_PYTHON

if [ $BUILD_CMAKE ] ; then
  cd libs/opencv
  if [ ! -d "build_wasm" ] ; then
    mkdir build_wasm
    echo "mkdir build_wasm"
  fi
  cd build_wasm
  echo "Building OpenCV with Ninja"
  cmake .. -GNinja $OPENCV_CONF $OPENCV_INTRINSICS -DCMAKE_CXX_FLAGS="$COMPILATION_FLAGS" -DCMAKE_C_FLAGS="$COMPILATION_FLAGS"
  ninja -v
fi
# /BUILD_CMAKE

if [ $BUILD_PYTHON ] ; then
    echo "Opencv.js and static libs successfully built!"
else
    echo "Opencv static libs successfully built!"
fi

echo "Packagings libs and includes in a .zip file..."

cd ${OURDIR}
    TARGET_DIR="./packaging/build_wasm"
    if [ -d ${TARGET_DIR} ] ; then
        rm -rf ${TARGET_DIR}
    fi

    # in case we need excludes later: --exclude-from=${OURDIR}/android/excludes
    if [ $BUILD_CMAKE ] ; then
      rsync -ar --files-from=./packaging/bom-cmake ${BUILD_HOME} ${TARGET_DIR}
    fi
    if [ $BUILD_PYTHON ]; then
      rsync -ar --files-from=./packaging/bom-python ${BUILD_HOME} ${TARGET_DIR}
    fi

    destdir=${TARGET_DIR}/em-flags.txt
    touch $destdir

    if [ -f "$destdir" ]
    then
        echo "Writing files"
        echo "$EM_FLAGS" > "$destdir"
    fi

    # TODO: copy and zip all the includes
    rsync -ra -R libs/opencv/modules/calib3d/include ${TARGET_DIR}
    rsync -ra -R libs/opencv/modules/core/include ${TARGET_DIR}
    rsync -ra -R libs/opencv/modules/features2d/include ${TARGET_DIR}
    rsync -ra -R libs/opencv/modules/flann/include ${TARGET_DIR}
    rsync -ra -R libs/opencv/modules/imgproc/include ${TARGET_DIR}
    rsync -ra -R libs/opencv/modules/video/include ${TARGET_DIR}
    rsync -ra -R libs/opencv/include/opencv2 ${TARGET_DIR}
    rsync -ra -R libs/opencv_contrib/modules/xfeatures2d/include ${TARGET_DIR}

    #Package all into a zip file
    cd ./packaging/
    zip --filesync -r "${BUILD_NAME_VERSION}.zip" ./build_wasm
    #Clean up
    cd ..
    # rm -rf ${TARGET_DIR}
