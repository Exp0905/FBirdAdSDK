# FBirdAdSDK iOS 二进制发行包

版本：1.4.1。最低 iOS 13.0。

同一个静态 `FBirdAdSDK.xcframework` 包含 FBird 广告核心、Taku adapter 与 GroMore adapter，不包含官方聚合 SDK 的实现或资源。

## CocoaPods

在本发行目录已提交到 GitHub 且创建 `1.4.1` 标签后，宿主添加：

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'FBirdAdSDK', :git => 'https://github.com/Exp0905/FBirdAdSDK.git', :tag => '1.4.1'
  # 使用 Taku 时添加：
  # pod 'AnyThinkiOS', '6.5.80'
  # 使用 GroMore 时添加：
  # pod 'Ads-CN/BUAdSDK', '7.6.1.7'
  # pod 'Ads-CN/BUAdLive-Framework', '7.6.1.7'
  # pod 'Ads-CN/CSJMediation', '7.6.1.7'
end
```

执行 `pod install` 后打开宿主的 `.xcworkspace`。

Podspec 自动添加 SDK、资源、`-ObjC` 和可选平台符号配置。
仅使用 FBird 核心时不需要安装聚合 SDK。官方 SDK 必须在 App 启动时已链接。

## 手动集成

1. 链接 `XCFramework/FBirdAdSDK.xcframework`，选择 Do Not Embed。
2. 将 `Resources/FBirdAdSDKBundle.bundle` 加入 Copy Bundle Resources。
3. 将 `FBirdAdSDKOptionalDependencies.xcconfig` 包含到宿主构建配置中，保留完整 OTHER_LDFLAGS。
4. 按需添加官方 Taku 或 GroMore SDK 及其资源。
5. 链接 UIKit、Foundation、AVFoundation、CoreTelephony、CoreMotion 等系统框架。

## API

```objc
#import <FBirdAdSDK/FBirdAdSDK.h>

[FBirdAdSDKManager setCanUseIDFAState:YES];
[FBirdAdSDKManager setCanUseIDFVState:YES];
[FBirdAdSDKManager setCanUseLimitPersonalAdsState:NO];
```

隐私选项应在请求前按宿主的授权状态设置。SDK 通过 `FBirdAdSDKManager` 加载广告，公开接口见 framework 的 Headers。

本仓库仅发布二进制、公开接口声明、资源和集成配置，不包含 SDK 或 adapter 实现源码，也不包含开发工程和开发仓库历史。
