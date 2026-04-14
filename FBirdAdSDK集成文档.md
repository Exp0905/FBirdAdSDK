# FBirdAdSDK 集成文档

## 1. 概述

FBirdAdSDK 是一个广告展示 SDK，支持多种广告类型，包括开屏广告、插屏广告、信息流广告和激励视频广告。本文档将详细介绍如何集成和使用 FBirdAdSDK。

## 2. 集成方式

### 2.1 CocoaPods 集成

在 `Podfile` 文件中添加以下依赖：

```ruby
pod 'FBirdAdSDK', :path => '/path/to/FBirdAdSDK'
```

然后运行：

```bash
pod install
```

### 2.2 手动集成

1. 将 `FBirdAdSDK.xcframework` 拖入项目中
2. 将 `FBirdAdSDKBundle.bundle` 拖入项目中
3. 在 Build Phases 的 Link Binary With Libraries 中添加所需的系统框架：
   - UIKit
   - Foundation
   - AVFoundation

## 3. 初始化 SDK

在 AppDelegate 的 `didFinishLaunchingWithOptions` 方法中初始化 SDK：

```objc
#import <FBirdAdSDK/FBirdAdSDK.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化 SDK
    [FBirdAdSDKManager initializeWithAppId:@"your_app_id"];
    
    // 设置是否允许使用 IDFV
    [FBirdAdSDKManager setCanUseIDFVState:YES];
    
    // 设置是否允许使用 IDFA
    [FBirdAdSDKManager setCanUseIDFAState:YES];
    
    // 设置个性化广告
    [FBirdAdSDKManager setCanUseLimitPersonalAdsState:YES];
    
    return YES;
}
```

## 4. 广告类型及使用方法

### 4.1 开屏广告

```objc
// 加载开屏广告
[FBirdAdSDKManager loadAdViewsWithTagID:@"your_tag_id" caid:@"your_caid" adtype:Splash requestCount:1 completion:^(NSArray<FBirdAdSDKView *> * _Nullable adViews, NSArray<NSError *> * _Nullable errors) {
    if (adViews && adViews.count > 0) {
        FBirdAdSDKView *adView = adViews.firstObject;
        adView.userActionCallback = ^(FBirdAdUserActionType actionType) {
            if ([actionType isEqualToString:FBirdAdUserActionTypeClose]) {
                // 广告关闭
            }
        };
        
        // 显示广告
        [adView showToView:self.view];
    }
}];
```

### 4.2 插屏广告

```objc
// 加载插屏广告
[FBirdAdSDKManager loadAdViewsWithTagID:@"your_tag_id" caid:@"your_caid" adtype:Interstitial requestCount:1 completion:^(NSArray<FBirdAdSDKView *> * _Nullable adViews, NSArray<NSError *> * _Nullable errors) {
    if (adViews && adViews.count > 0) {
        FBirdAdSDKView *adView = adViews.firstObject;
        adView.userActionCallback = ^(FBirdAdUserActionType actionType) {
            if ([actionType isEqualToString:FBirdAdUserActionTypeClose]) {
                // 广告关闭
            }
        };
        
        // 显示广告
        [adView showToView:self.view];
    }
}];
```

### 4.3 信息流广告

```objc
// 加载信息流广告
[FBirdAdSDKManager loadAdViewsWithTagID:@"your_tag_id" caid:@"your_caid" adtype:Feed requestCount:1 completion:^(NSArray<FBirdAdSDKView *> * _Nullable adViews, NSArray<NSError *> * _Nullable errors) {
    if (adViews && adViews.count > 0) {
        FBirdAdSDKView *adView = adViews.firstObject;
        adView.userActionCallback = ^(FBirdAdUserActionType actionType) {
            if ([actionType isEqualToString:FBirdAdUserActionTypeClickDetail]) {
                // 广告点击
            }
        };
        
        // 添加到信息流列表
        [self.tableView addSubview:adView];
        // 设置广告视图的位置和大小
        adView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 300);
    }
}];
```

### 4.4 激励视频广告

```objc
// 加载激励视频广告
[FBirdAdSDKManager loadAdViewsWithTagID:@"your_tag_id" caid:@"your_caid" adtype:RewardVideo requestCount:1 completion:^(NSArray<FBirdAdSDKView *> * _Nullable adViews, NSArray<NSError *> * _Nullable errors) {
    if (adViews && adViews.count > 0) {
        FBirdAdSDKView *adView = adViews.firstObject;
        adView.userActionCallback = ^(FBirdAdUserActionType actionType) {
            if ([actionType isEqualToString:FBirdAdUserActionTypeOnAdReward]) {
                // 发放奖励
                [self giveRewardToUser];
            } else if ([actionType isEqualToString:FBirdAdUserActionTypeClose]) {
                // 广告关闭
            }
        };
        
        // 显示广告
        [adView showToView:self.view];
    }
}];
```

## 5. 广告事件回调

FBirdAdSDK 提供了以下事件回调：

- `FBirdAdUserActionTypeClose`：广告关闭
- `FBirdAdUserActionTypeSkip`：广告跳过
- `FBirdAdUserActionTypeConfirmExit`：确认退出
- `FBirdAdUserActionTypeSwipeUp`：上滑
- `FBirdAdUserActionTypeShake`：摇一摇
- `FBirdAdUserActionTypeClickDetail`：广告点击
- `FBirdAdUserActionTypeOnAdReward`：激励视频奖励
- `FBirdAdUserActionTypeOnAdShow`：广告展示

## 6. 注意事项

1. **权限配置**：在 `Info.plist` 中添加以下权限：
   - 相机权限（如果需要）
   - 相册权限（如果需要）
   - 位置权限（如果需要）

2. **资源文件**：确保 `FBirdAdSDKBundle.bundle` 已正确添加到项目中，否则可能导致图片资源加载失败。

3. **广告加载**：建议提前加载广告，避免用户等待。

4. **广告显示**：在合适的时机显示广告，避免频繁打扰用户。

5. **内存管理**：广告显示完成后，及时移除广告视图，避免内存泄漏。

## 7. 常见问题

### 7.1 广告加载失败

- 检查网络连接
- 检查 tagID 和 caid 是否正确
- 检查 SDK 初始化是否成功

### 7.2 资源文件加载失败

- 确保 `FBirdAdSDKBundle.bundle` 已正确添加到项目中
- 确保资源文件名称正确

### 7.3 广告不显示

- 检查广告是否已加载成功
- 检查广告视图是否已添加到父视图中
- 检查广告视图的 frame 是否正确

## 8. 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 1.0.0 | 2026-04-14 | 初始版本 |

## 9. 联系方式

如有任何问题，请联系：

- 邮箱：support@fbird.com
- 电话：400-123-4567

---

**FBirdAdSDK 团队**
**2026年4月14日**