#!/bin/bash

set -e

###########################
# 配置参数
###########################
SCHEME="FBirdAdSDK"
FRAMEWORK_NAME="${SCHEME}.framework"
RESOURCE_BUNDLE_TARGET="FBirdAdSDKBundle"
RESOURCE_BUNDLE_NAME="${RESOURCE_BUNDLE_TARGET}.bundle"

CONFIGURATION="Release"
BUILD_DIR="./build"
OUTPUT_DIR="./XCFramework"
OUTPUT_XCFRAMEWORK="${OUTPUT_DIR}/${SCHEME}.xcframework"

###########################
# 清理旧内容
###########################
rm -rf "${BUILD_DIR}" "${OUTPUT_DIR}"
echo "🧹 清理完成"

###########################
# Step 0: 资源文件说明
###########################
echo "📦 资源文件说明：Media.xcassets 已包含在 FBirdAdSDK target 中"
echo "✅ 构建时会自动编译为 Assets.car 并包含在 framework 中"

# 资源 Bundle 路径（实际构建时会自动生成）
RESOURCE_BUNDLE_NAME="FBirdAdSDKBundle.bundle"
RESOURCE_SRC_PATH=""

# 跳过单独构建资源 Bundle，使用主 target 生成的 Assets.car

###########################
# Step 1: 构建模拟器 Framework
###########################
echo "🛠️ 构建模拟器 Framework"

xcodebuild archive \
  -scheme "${SCHEME}" \
  -configuration "${CONFIGURATION}" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "${BUILD_DIR}/simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

SIMULATOR_FRAMEWORK_PATH="${BUILD_DIR}/simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}"
SIMULATOR_RESOURCES_PATH="${SIMULATOR_FRAMEWORK_PATH}/Resources"
mkdir -p "${SIMULATOR_RESOURCES_PATH}"

# 拷贝资源 Bundle 到模拟器 framework（使用主 target 生成的 Assets.car）
echo "✅ 资源文件已通过主 target 包含在 framework 中"

# 拷贝静态资源文件到模拟器 framework
if [ -d "./Resources" ]; then
  cp -R "./Resources" "${SIMULATOR_RESOURCES_PATH}/"
  echo "✅ 已拷贝静态资源文件到模拟器 framework"
else
  echo "⚠️  找不到静态资源目录，跳过拷贝"
fi

###########################
# Step 2: 构建真机 Framework
###########################
echo "🛠️ 构建真机 Framework"

xcodebuild archive \
  -scheme "${SCHEME}" \
  -configuration "${CONFIGURATION}" \
  -destination "generic/platform=iOS" \
  -archivePath "${BUILD_DIR}/device.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

DEVICE_FRAMEWORK_PATH="${BUILD_DIR}/device.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}"
DEVICE_RESOURCES_PATH="${DEVICE_FRAMEWORK_PATH}/Resources"
mkdir -p "${DEVICE_RESOURCES_PATH}"

# 拷贝资源 Bundle 到真机 framework（使用主 target 生成的 Assets.car）
echo "✅ 资源文件已通过主 target 包含在 framework 中"

# 拷贝静态资源文件到真机 framework
if [ -d "./Resources" ]; then
  cp -R "./Resources" "${DEVICE_RESOURCES_PATH}/"
  echo "✅ 已拷贝静态资源文件到真机 framework"
else
  echo "⚠️  找不到静态资源目录，跳过拷贝"
fi

###########################
# Step 3: 创建 XCFramework
###########################
echo "📦 创建 XCFramework..."

mkdir -p "${OUTPUT_DIR}"

xcodebuild -create-xcframework \
  -framework "${SIMULATOR_FRAMEWORK_PATH}" \
  -framework "${DEVICE_FRAMEWORK_PATH}" \
  -output "${OUTPUT_XCFRAMEWORK}"

###########################
# Step 4: 资源文件说明
###########################
echo "📦 资源文件说明："
echo "✅ 资源文件已通过主 target 包含在 framework 中"
echo "✅ 构建时会自动编译为 Assets.car 并嵌入到 framework 中"
echo "📝 使用说明：无需单独添加资源文件，直接集成 framework 即可"

echo "🎉 构建完成："
echo "🧩 Framework: ${OUTPUT_XCFRAMEWORK}"
echo "🖼️ 资源文件: 已包含在 framework 中"


