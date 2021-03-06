UNIVERSAL_OUTPUTFOLDER=../build/

# 创建输出目录，并删除之前的framework文件
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
rm -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework"

# 分别编译模拟器和真机的Framework
# xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"


# xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"

# 拷贝真机的framework到univer目录
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# 合并framework，输出最终的framework到build目录
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"

mv  ../"${PROJECT_NAME}"/"${CONFIGURATION}-iphonesimulator"  "${UNIVERSAL_OUTPUTFOLDER}"

mv ../"${PROJECT_NAME}"/"${CONFIGURATION}-iphoneos"  "${UNIVERSAL_OUTPUTFOLDER}"

open "${UNIVERSAL_OUTPUTFOLDER}"

rm -rf  ../"${PROJECT_NAME}"/build


