#! /bin/bash

#!/bin/bash
#
# Script for buildling opencv.js / WASM
#
# ARG_OPTIONAL_BOOLEAN([pthreads],[p],[Use pthreads-based parallel for and/or emscripten pthread optimizations ])
# ARG_OPTIONAL_BOOLEAN([simd],[s],[Use intrinsic-based optimizations ])
# ARG_OPTIONAL_BOOLEAN([canonical_includes],[i],[Use canonical include structure, if available (requires linux build before emscriten build)])
# ARG_OPTIONAL_BOOLEAN([config_headers],[c],[Package config headers, i.e. opencv2/config.h and opencv2/opencv_modules.hpp],[on])
# ARG_POSITIONAL_SINGLE([build_mode],[OpenCV build mode. May be one of {linux, emscripten}],[])
# ARG_HELP([Build OpenCV & package build output in a zip file.])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
    local _ret="${2:-1}"
    test "${_PRINT_HELP:-no}" = yes && print_help >&2
    echo "$1" >&2
    exit "${_ret}"
}


begins_with_short_option()
{
    local first_option all_short_options='psich'
    first_option="${1:0:1}"
    test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_pthreads="off"
_arg_simd="off"
_arg_canonical_includes="off"
_arg_config_headers="on"


print_help()
{
    printf '%s\n' "Build OpenCV & package build output in a zip file."
    printf 'Usage: %s [-p|--(no-)pthreads] [-s|--(no-)simd] [-i|--(no-)canonical_includes] [-c|--(no-)config_headers] [-h|--help] <build_mode>\n' "$0"
    printf '\t%s\n' "<build_mode>: OpenCV build mode. May be one of {linux, emscripten}"
    printf '\t%s\n' "-p, --pthreads, --no-pthreads: Use pthreads-based parallel for and/or emscripten pthread optimizations  (off by default)"
    printf '\t%s\n' "-s, --simd, --no-simd: Use intrinsic-based optimizations  (off by default)"
    printf '\t%s\n' "-i, --canonical_includes, --no-canonical_includes: Use canonical include structure, if available (off by default)"
    printf '\t%s\n' "-c, --config_headers, --no-config_headers: Package config headers, i.e. opencv2/config.h and opencv2/opencv_modules.hpp (on by default)"
    printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
    _positionals_count=0
    while test $# -gt 0
    do
        _key="$1"
        case "$_key" in
            -p|--no-pthreads|--pthreads)
                _arg_pthreads="on"
                test "${1:0:5}" = "--no-" && _arg_pthreads="off"
                ;;
            -p*)
                _arg_pthreads="on"
                _next="${_key##-p}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    { begins_with_short_option "$_next" && shift && set -- "-p" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -s|--no-simd|--simd)
                _arg_simd="on"
                test "${1:0:5}" = "--no-" && _arg_simd="off"
                ;;
            -s*)
                _arg_simd="on"
                _next="${_key##-s}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    { begins_with_short_option "$_next" && shift && set -- "-s" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -i|--no-canonical_includes|--canonical_includes)
                _arg_canonical_includes="on"
                test "${1:0:5}" = "--no-" && _arg_canonical_includes="off"
                ;;
            -i*)
                _arg_canonical_includes="on"
                _next="${_key##-i}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    { begins_with_short_option "$_next" && shift && set -- "-i" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -c|--no-config_headers|--config_headers)
                _arg_config_headers="on"
                test "${1:0:5}" = "--no-" && _arg_config_headers="off"
                ;;
            -c*)
                _arg_config_headers="on"
                _next="${_key##-c}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    { begins_with_short_option "$_next" && shift && set -- "-c" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            -h*)
                print_help
                exit 0
                ;;
            *)
                _last_positional="$1"
                _positionals+=("$_last_positional")
                _positionals_count=$((_positionals_count + 1))
                ;;
        esac
        shift
    done
}


handle_passed_args_count()
{
    local _required_args_string="'build_mode'"
    test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${_positionals_count}." 1
    test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
    local _positional_name _shift_for=$1
    _positional_names="_arg_build_mode "

    shift "$_shift_for"
    for _positional_name in ${_positional_names}
    do
        test $# -gt 0 || break
        eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
        shift
    done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -eq 0 ]; then
    usage
fi

# -e = exit on errors
set -e

while test $# -gt 0
do
    case "$_arg_build_mode" in
        linux) BUILD_CMAKE=1
            ;;
        emscripten) BUILD_PYTHON=1
            ;;
        --*) echo "bad option $_arg_build_mode"
            print_help
            ;;
        *) echo "bad argument $_arg_build_mode"
            print_help
            ;;
    esac
    shift
done

BUILD_HOME=" "
BUILD_HOME_BASE=""
if [ $BUILD_PYTHON ] ; then
    if [ "${_arg_simd}" = off ] ; then
        BUILD_HOME_BASE="opencv_js"
    else
        BUILD_HOME_BASE="opencv_js_simd"
    fi
    BUILD_HOME="${OURDIR}/${BUILD_HOME_BASE}"
else
    BUILD_HOME="${OURDIR}/libs/opencv/build_opencv"
fi

INSTALL_HOME_POSTFIX="libs/opencv/install_opencv"
INSTALL_HOME_ABSOLUTE="${OURDIR}/${INSTALL_HOME_POSTFIX}"

if [ $BUILD_PYTHON ] ; then
    BUILD_NAME="opencv-js"
else
    BUILD_NAME="opencv"
fi

OPENCV_VERSION_MAJOR=$(cat ${OURDIR}/libs/opencv/modules/core/include/opencv2/core/version.hpp | pcregrep -o1  '#define\sCV_VERSION_MAJOR\s+(\d+)')
OPENCV_VERSION_MINOR=$(cat ${OURDIR}/libs/opencv/modules/core/include/opencv2/core/version.hpp | pcregrep -o1  '#define\sCV_VERSION_MINOR\s+(\d+)')
OPENCV_VERSION_REVISION=$(cat ${OURDIR}/libs/opencv/modules/core/include/opencv2/core/version.hpp | pcregrep -o1  '#define\sCV_VERSION_REVISION\s+(\d+)')
OPENCV_VERSION_STATUS="$(cat libs/opencv/modules/core/include/opencv2/core/version.hpp | pcregrep -o1  '#define\sCV_VERSION_STATUS\s+["](.*)["]')"  

OPENCV_VERSION="${OPENCV_VERSION_MAJOR}.${OPENCV_VERSION_MINOR}.${OPENCV_VERSION_REVISION}"
VERSION=""
if [ $BUILD_PYTHON ] ; then
    VERSION="${OPENCV_VERSION}-emcc-3.1.38"
else
    VERSION=${OPENCV_VERSION}
fi

BUILD_NAME_VERSION="${BUILD_NAME}-${VERSION}"

COMPILATION_FLAGS=" -std=c++14"
# not currently used, but may be used by passing `-DCMAKE_TOOLCHAIN_FILE="$EM_TOOLCHAIN"` to cmake
EM_TOOLCHAIN="$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake"

if [ "${_arg_simd}" = on ] ; then
    OPENCV_INTRINSICS="-DCV_ENABLE_INTRINSICS=ON"
    OPENCV_EM_INTRINSICES="--simd"
    BUILD_NAME_VERSION="${BUILD_NAME_VERSION}-simd"
else
    OPENCV_INTRINSICS="-DCV_ENABLE_INTRINSICS=OFF"
    OPENCV_EM_INTRINSICES=""
fi
if [ "${_arg_pthreads}" = on ] ; then
    OPENCV_PTHREDS="-DWITH_PTHREADS_PF=ON"
    OPENCV_EM_PTHREADS="--threads"
    BUILD_NAME_VERSION="${BUILD_NAME_VERSION}-pthreads"
else
    OPENCV_PTHREDS="-DWITH_PTHREADS_PF=OFF"
    OPENCV_EM_PTHREADS=""
fi

OPENCV_CPU_OPTIMIZATIONS="-DCPU_BASELINE="" -DCPU_DISPATCH="""
OPENCV_DEFINES="-DENABLE_PIC=FALSE"
OPENCV_EXCLUDE="-DBUILD_SHARED_LIBS=OFF -DBUILD_JAVA=OFF -DWITH_1394=OFF -DWITH_ADE=OFF -DWITH_VTK=OFF -DWITH_EIGEN=OFF -DWITH_GTK=OFF -DWITH_GTK_2_X=OFF -DWITH_IPP=OFF -DWITH_JASPER=OFF -DWITH_JPEG=OFF -DWITH_WEBP=OFF -DWITH_OPENEXR=OFF -DWITH_OPENGL=OFF -DWITH_OPENVX=OFF -DWITH_OPENNI=OFF -DWITH_OPENNI2=OFF -DWITH_PNG=OFF -DWITH_TBB=OFF -DWITH_TIFF=OFF -DWITH_OPENCL=OFF -DWITH_OPENCL_SVM=OFF -DWITH_OPENCLAMDFFT=OFF -DWITH_OPENCLAMDBLAS=OFF -DWITH_GPHOTO2=OFF -DWITH_LAPACK=OFF -DWITH_ITT=OFF -DWITH_QUIRC=OFF -DCV_TRACE=OFF"
OPENCV_INCLUDE="-DWITH_V4L=ON_-DWITH_FFMPEG=ON -DWITH_GSTREAMER=ON -DBUILD_OPENJPEG=ON -DWITH_JPEG=ON -DBUILD_ZLIB=ON"
OPENCV_MODULES_EXCLUDE="-DBUILD_opencv_dnn=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_python3=OFF -DBUILD_opencv_shape=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_superres=OFF -DBUILD_opencv_videostab=OFF"
OPENCV_MODULES_INCLUDE="-DBUILD_opencv_calib3d=ON -DBUILD_opencv_core=ON -DBUILD_opencv_features2d=ON -DBUILD_opencv_flann=ON -DBUILD_opencv_imgcodecs=ON -DBUILD_opencv_video=ON -DBUILD_opencv_videoio=ON "
OPENCV_EXTRA_MODULES_EXCLUDE="-DBUILD_opencv_bgsegm=OFF -DBUILD_opencv_bioinspired=OFF -DBUILD_opencv_fuzzy=OFF -DBUILD_opencv_hfs=OFF -DBUILD_opencv_img_hash=OFF -DBUILD_opencv_intensity_transform=OFF -DBUILD_opencv_line_descriptor=OFF -DBUILD_opencv_optflow=OFF -DBUILD_opencv_phase_unwrapping=OFF -DBUILD_opencv_plot=OFF -DBUILD_opencv_rapid=OFF -DBUILD_opencv_reg=OFF -DBUILD_opencv_rgbd=OFF -DBUILD_opencv_saliency=OFF -DBUILD_opencv_stereo=OFF -DBUILD_opencv_structured_light=OFF -DBUILD_opencv_surface_matching=OFF -DBUILD_opencv_tracking=OFF -DBUILD_opencv_ximgproc=OFF -DBUILD_opencv_xobjdetect=OFF -DBUILD_opencv_xphoto=OFF"
OPENCV_EXTRA_MODULES_INCLUDE="-DBUILD_opencv_xfeatures2d=ON "
OPENCV_EXTRA_MODULES_PATH=" -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules/xfeatures2d ../ "
OPENCV_CONF="${OPENCV_DEFINES} ${OPENCV_EXCLUDE} ${OPENCV_INCLUDE} ${OPENCV_MODULES_EXCLUDE} ${OPENCV_EXTRA_MODULES_INCLUDE} ${OPENCV_EXTRA_MODULES_EXCLUDE} ${OPENCV_MODULES_INCLUDE} -DBUILD_opencv_apps=OFF -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_IPP_IW=OFF -DBUILD_PACKAGE=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_WITH_DEBUG_INFO=OFF -DWITH_PTHREADS_PF=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF ${OPENCV_EXTRA_MODULES_PATH} "

if [ $BUILD_PYTHON ] ; then
  echo "Building OpenCV for the web with Emscripten"
  docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) -e "EMSCRIPTEN=/emsdk/upstream/emscripten" emscripten/emsdk:3.1.38 emcmake python3 ./libs/opencv/platforms/js/build_js.py ${BUILD_HOME_BASE} --config="./opencv.webarkit_config.py" --build_wasm \
   ${OPENCV_EM_INTRINSICES} \
   ${OPENCV_EM_PTHREADS} \
   --cmake_option="-DBUILD_opencv_dnn=OFF" \
   --cmake_option="-DBUILD_opencv_objdetect=OFF" \
   --cmake_option="-DBUILD_opencv_photo=OFF" \
   --cmake_option="-DBUILD_opencv_imgcodecs=ON" \
   --cmake_option="-DBUILD_opencv_xfeatures2d=ON"  \
   --cmake_option="-DOPENCV_EXTRA_MODULES_PATH=./../libs/opencv_contrib/modules" \
   --build_flags=" -fwasm-exceptions -mbulk-memory -mnontrapping-fptoint -sWASM_BIGINT -sSUPPORT_LONGJMP=wasm "
fi
# /BUILD_PYTHON

if [ $BUILD_CMAKE ] ; then
  cd libs/opencv
  if [ ! -d "build_opencv" ] ; then
    mkdir build_opencv
    echo "mkdir build_opencv"
  fi
  cd build_opencv
  echo "Building OpenCV with Ninja"
  cmake .. -GNinja $OPENCV_CONF $OPENCV_INTRINSICS $OPENCV_CPU_OPTIMIZATIONS -DCMAKE_CXX_FLAGS="$COMPILATION_FLAGS" -DCMAKE_C_FLAGS="$COMPILATION_FLAGS" -DCMAKE_INSTALL_PREFIX="$INSTALL_HOME_ABSOLUTE"
  ninja -v
  ninja install
fi
# /BUILD_CMAKE

if [ $BUILD_PYTHON ] ; then
    echo "Opencv.js and static libs successfully built!"
else
    echo "Opencv static libs successfully built!"
fi

echo "Packagings libs and includes in a .zip file..."

cd ${OURDIR}
    TARGET_DIR="./packaging/build_opencv"
    if [ -d ${TARGET_DIR} ] ; then
        rm -rf ${TARGET_DIR}
    fi

    # in case we need excludes later: --exclude-from=${OURDIR}/android/excludes
    if [ $BUILD_CMAKE ] ; then
      rsync -ar --files-from=./packaging/bom-cmake ${BUILD_HOME} ${TARGET_DIR}
    fi
    if [ $BUILD_PYTHON ] || [ $BUILD_PYTHON_SIMD ] ; then
      rsync -ar --files-from=./packaging/bom-python ${BUILD_HOME} ${TARGET_DIR}
    fi

    destdir=${TARGET_DIR}/em-flags.txt
    touch $destdir

    if [ -f "$destdir" ] ; then
        echo "Writing files"
        echo "$EM_FLAGS" > "$destdir"
    fi

    # TODO: copy and zip all the includes
    if [ -d "$INSTALL_HOME_ABSOLUTE" ] && [ "${_arg_canonical_includes}" = on ] ; then
        echo "Copying installed includes"
        rsync -ra $INSTALL_HOME_POSTFIX/include ${TARGET_DIR}
    else
        echo "Copying source includes"
        rsync -ra -R libs/opencv/modules/calib3d/include ${TARGET_DIR}
        rsync -ra -R libs/opencv/modules/core/include ${TARGET_DIR}
        rsync -ra -R libs/opencv/modules/features2d/include ${TARGET_DIR}
        rsync -ra -R libs/opencv/modules/flann/include ${TARGET_DIR}
        if [ $BUILD_CMAKE ] ; then
            rsync -ra -R libs/opencv/modules/imgcodecs/include ${TARGET_DIR}
        fi
        rsync -ra -R libs/opencv/modules/imgproc/include ${TARGET_DIR}
        rsync -ra -R libs/opencv/modules/video/include ${TARGET_DIR}
        if [ $BUILD_CMAKE ] ; then
            rsync -ra -R libs/opencv/modules/videoio/include ${TARGET_DIR}
        fi
        rsync -ra -R libs/opencv/include/opencv2 ${TARGET_DIR}
        rsync -ra -R libs/opencv_contrib/modules/xfeatures2d/include ${TARGET_DIR}
    fi

    if [ ${_arg_config_headers} = off ]
    then
        rm -rf ${TARGET_DIR}/opencv2
    fi

    # Package all into a zip file
    cd ./packaging/
    zip --filesync -r "${BUILD_NAME_VERSION}.zip" ./build_opencv
    # Clean up
    cd ..
    rm -rf ${TARGET_DIR}

# ] <-- needed because of Argbash
