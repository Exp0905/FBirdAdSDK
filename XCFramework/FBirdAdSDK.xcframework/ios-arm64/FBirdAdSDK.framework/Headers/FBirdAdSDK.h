//
//  CuskyAdSDK.h
//  CuskyAdSDK
//
//  Created by TWind on 2025/4/12.
//

#import <Foundation/Foundation.h>
// In this header, you should import all the public headers of your framework using statements like #import <CuskyAdSDK/PublicHeader.h>
// 资产 ID 常量（用于匹配广告资源类型）
static const NSInteger ASSET_ID_IMG = 1;           // 主图
static const NSInteger ASSET_ID_ICON = 2;          // 应用图标
static const NSInteger ASSET_ID_LOGO = 3;          // 商标 Logo
static const NSInteger ASSET_ID_TITLE = 4;         // 标题
static const NSInteger ASSET_ID_DESC = 5;          // 描述文本
static const NSInteger ASSET_ID_SOURCE = 6;        // 来源信息
static const NSInteger ASSET_ID_CALL_BUTTON = 7;   // 行动按钮文案
static const NSInteger ASSET_ID_VIDEO_ORIGIN = 8;  // 普通视频
static const NSInteger ASSET_ID_VIDEO_REWARD = 9;  // 激励视频


static const NSInteger Splash = 1;  // 开屏广告
static const NSInteger Interstitial = 2;  // 插屏广告
static const NSInteger Banner = 3;  // banner广告
static const NSInteger Feed = 4;  // 信息流广告
static const NSInteger Draw = 5;  // draw
static const NSInteger Video = 6;  // 视频
static const NSInteger RewardVideo = 7;  // 激励视频


typedef NS_ENUM(NSInteger, FBirdAdSDKAdStyle) {
    CuskyAdSDKAdStyleTopBottomRightSmallButton, // 上文下文右小按钮
    CuskyAdSDKAdStyleTopBottomBigButton,     // 上文下文底部大按钮
    CuskyAdSDKAdStyleCustomInterstitial,      // 自定义一号插屏
    CuskyAdSDKAdStyleTopBottomLeftBigLogo,    // 上图下文左侧大logo
    CuskyAdSDKAdStyleFunctionListBanner,      // 功能列表banner
    CuskyAdSDKAdStyleLargeImageNoButton,      // 竖版大图封面无按钮
    CuskyAdSDKAdStyleTextFloatRightButton,   // 文字悬浮右小按钮
    CuskyAdSDKAdStyleCustomInterstitial2,     // 自定义二号插屏
    CuskyAdSDKAdStyleWiFiListBanner,         // WiFi 列表 banner
    CuskyAdSDKAdStyleSplashType1,            // 开屏广告样式一
    CuskyAdSDKAdStyleSplashType2,            // 开屏广告样式二
    CuskyAdSDKAdStyleRewardVideo,            // 激励视频
//    CuskyAdSDKAdStyleSoundListBanner,        // 铃声列表banner //先不做
    CuskyAdSDKAdStyleImageBottomButton       // 上图下文底部图按钮
};


/// 广告上报 URL 类型
typedef NS_ENUM(NSInteger, FBirdAdSDKAdUrlType) {
    CuskyAdSDKAdUrlTypeClick,       ///< click_urls
    CuskyAdSDKAdUrlTypeDeepLink,    ///< deeplink_urls
    CuskyAdSDKAdUrlTypeImpression   ///< imp_urls
};
#import <FBirdAdSDK/FBirdAdSDKManager.h>
#import <FBirdAdSDK/FBirdAdSDKAdResponseModel.h>
#import <FBirdAdSDK/FBirdAdSDKView.h>
