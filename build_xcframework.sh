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
# Step 0: 构建资源 Bundle（跳过签名）
###########################
echo "📦 构建资源 Bundle：${RESOURCE_BUNDLE_NAME}"

xcodebuild -target "${RESOURCE_BUNDLE_TARGET}" \
  -configuration "${CONFIGURATION}" \
  -sdk iphonesimulator \
  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_DIR}" \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

RESOURCE_SRC_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${RESOURCE_BUNDLE_NAME}"

if [ ! -d "${RESOURCE_SRC_PATH}" ]; then
  echo "❌ 找不到资源 Bundle"
  exit 1
fi

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

# 拷贝资源 Bundle 到模拟器 framework
if [ -d "${RESOURCE_SRC_PATH}" ]; then
  cp -R "${RESOURCE_SRC_PATH}" "${SIMULATOR_RESOURCES_PATH}/"
  echo "✅ 已拷贝资源 Bundle 到模拟器 framework"
else
  echo "⚠️  找不到资源 Bundle，跳过拷贝"
fi

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

# 拷贝资源 Bundle 到真机 framework
if [ -d "${RESOURCE_SRC_PATH}" ]; then
  cp -R "${RESOURCE_SRC_PATH}" "${DEVICE_RESOURCES_PATH}/"
  echo "✅ 已拷贝资源 Bundle 到真机 framework"
else
  echo "⚠️  找不到资源 Bundle，跳过拷贝"
fi

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
# Step 4: 单独导出资源 Bundle（供宿主应用使用）
###########################
OUTPUT_RESOURCE_DIR="${OUTPUT_DIR}/Resources"
RESOURCE_BUNDLE_EXPORT_PATH="${OUTPUT_RESOURCE_DIR}/${RESOURCE_BUNDLE_NAME}"
mkdir -p "${OUTPUT_RESOURCE_DIR}"

if [ -d "${RESOURCE_SRC_PATH}" ]; then
  cp -R "${RESOURCE_SRC_PATH}" "${RESOURCE_BUNDLE_EXPORT_PATH}"
  echo "✅ 已单独导出资源 Bundle：${RESOURCE_BUNDLE_EXPORT_PATH}"
  echo "📝 使用说明：请将此资源 Bundle 添加到宿主应用的 'Copy Bundle Resources' 中"
else
  echo "⚠️  找不到资源 Bundle，跳过单独导出"
fi

echo "🎉 构建完成："
echo "🧩 Framework: ${OUTPUT_XCFRAMEWORK}"
echo "🖼️ 资源 Bundle: ${RESOURCE_BUNDLE_EXPORT_PATH}"


