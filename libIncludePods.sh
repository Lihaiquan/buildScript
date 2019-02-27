UNIVERSAL_OUTPUTFOLDER="${PROJECT_DIR}/build/"

# 创建输出目录，并删除之前的framework文件
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
rm -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.a"

# 模拟器的.a的目录
IPHONESIMULATOR_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/
# 真机的.a目录
IPHONEOS_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-iphoneos/


MAX_ARCHURE_ARR=()
MAX_A_COUNT=0
OLD_IFS="$IFS"
# 编译真机上的.a文件
function ergodicFat() {
   for element in `ls $1`
   do
     dir_or_file=$1$element
     if [ -d $dir_or_file ]
     then
        if [[ $element != build* ]]
        then
           ergodicFat $dir_or_file"/" "${IPHONESIMULATOR_OUTPUTFOLDER}"
        fi
    else
        if [[ $element !=  libPods-* ]] && [[ $element == *.a ]]
       then
           MAX_A_COUNT=$(($MAX_A_COUNT+1))
           ARCHURE=`lipo -info $dir_or_file`
           ARCHURE=${ARCHURE##*:}
           IFS=" "
           #获取到支持的架构数组
           array=($ARCHURE)
           lenth=${#array[@]}
           maxLenth=${#MAX_ARCHURE_ARR[@]}
           if [ $lenth -gt $maxLenth ]
           then
              MAX_ARCHURE_ARR=($ARCHURE);
           fi
           for each in ${array[@]}
           do
             if [ $lenth -gt 1 ]
             then
                lipo $dir_or_file  -thin $each -output  "$each-$element"
             else
               cp $dir_or_file "$2build/$each-$element"
              fi
          done
        fi
     fi
 done
 IFS=$OLD_IFS
}

function generate() {
      for each in ${MAX_ARCHURE_ARR[@]}
      do
          countNumber=`ls -l |grep "${each}"|wc -l`
         if [ $countNumber -eq  $MAX_A_COUNT ]
         then
             for libelEment in  `ls $1build/`
             do
                if [[ $libelEment == $each* ]] && [[ $libelEment == *.a ]]
                then
                   ar -x $libelEment
                fi
             done
            find "$1build/" -name "$each*" | xargs rm
            # 合成各个.o进行合成.a
            libtool -static -o "$1build/$each-${PROJECT_NAME}.a"  *.o
            find "$1build/" -name "*.o" | xargs rm
            find "$1build/" -name "_.*" | xargs rm
            mv "$1build/$each-${PROJECT_NAME}.a" "${UNIVERSAL_OUTPUTFOLDER}/$each-lib${PROJECT_NAME}.a"
       else
            find "$1build/" -name "$each*" | xargs rm
       fi
   done
}

#创建build目录
mkdir "${IPHONESIMULATOR_OUTPUTFOLDER}build"
# 删除build的.o
rm -rf "${IPHONESIMULATOR_OUTPUTFOLDER}build/*.o"
#打开文build
cd "${IPHONESIMULATOR_OUTPUTFOLDER}build"

ergodicFat "${IPHONESIMULATOR_OUTPUTFOLDER}" "${IPHONESIMULATOR_OUTPUTFOLDER}"

generate "${IPHONESIMULATOR_OUTPUTFOLDER}"

#删除build目录
rm -rf "${IPHONESIMULATOR_OUTPUTFOLDER}build"



rm -rf "${IPHONEOS_OUTPUTFOLDER}build/*"
#创建build目录
mkdir "${IPHONEOS_OUTPUTFOLDER}build"

#打开文build
cd "${IPHONEOS_OUTPUTFOLDER}build"

MAX_ARCHURE_ARR=()
MAX_A_COUNT=0
OLD_IFS="$IFS"

ergodicFat "${IPHONEOS_OUTPUTFOLDER}"  "${IPHONEOS_OUTPUTFOLDER}"

generate "${IPHONEOS_OUTPUTFOLDER}"

#删除build目录
rm -rf "${IPHONEOS_OUTPUTFOLDER}build"

open "${UNIVERSAL_OUTPUTFOLDER}"





