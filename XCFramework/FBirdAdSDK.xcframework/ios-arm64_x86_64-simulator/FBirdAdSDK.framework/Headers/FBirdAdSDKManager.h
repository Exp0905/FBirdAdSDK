#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <FBirdAdSDK/FBirdAdSDKView.h>
#import <FBirdAdSDK/FBirdAdSDKAdResponseModel.h>
//#import "FBirdAdSDKView.h"
//#import "FBirdAdSDKAdResponseModel.h"
NS_ASSUME_NONNULL_BEGIN

@class FBirdAdSDKView;
/// 上报完成回调
typedef void (^FBirdAdSDKAdUrlCompletionBlock)(BOOL success, NSError * _Nullable error);

@interface FBirdAdSDKManager : NSObject

/// 多次请求广告
/// @param tagid 广告位 ID
/// @param caid 客户唯一标识
/// @param adtype 广告类型
/// @param requestCount 请求次数，至少 1 次
/// @param completion 所有请求完成的回调
+ (void)loadAdsWithTagID:(NSString *)tagid
                   caid:(NSString *)caid
                   adtype:(int)adtype
           requestCount:(NSInteger)requestCount
             completion:(void (^)(NSArray<FBirdAdSDKAdResponseModel *> *responses, NSArray<NSError *> *errors))completion;

/// 单次请求广告并绑定到 View
/// @param tagid 广告位 ID
/// @param caid 客户唯一标识
/// @param adtype 广告类型
/// @param requestCount 请求次数，至少 1 次
/// @param completion 单个请求完成后的回调
#pragma mark - 公有：多视图广告请求
+ (void)loadAdViewsWithTagID:(NSString *)tagid
                        caid:(NSString *)caid
                      adtype:(int)adtype
                requestCount:(NSInteger)requestCount
                  completion:(void (^)(NSArray<FBirdAdSDKView *> * _Nullable adViews, NSArray<NSError *> * _Nullable errors))completion;

/// 点击/曝光/跳转 上报处理
/// @param adResponse 广告 Bid 数据
/// @param view 广告展示视图
/// @param type 上报类型
/// @param clickPoint 点击坐标（相对于 view）
+ (void)reportClickWithAdResponse:(FBirdAdSDKBid *)adResponse
                             view:(UIView *)view
                          urlType:(FBirdAdSDKAdUrlType)type
                      clickPoint:(CGPoint)clickPoint
                       completion:(FBirdAdSDKAdUrlCompletionBlock)completion;

/// 获取当前 SDK 版本号
+ (NSString *)sdkVersion;
//是否获取IDFV
+(void)setCanUseIDFVState:(BOOL) canUse;

//是否获取IDFA
+(void)setCanUseIDFAState:(BOOL) canUse;

//个性化广告设置
+(void)setCanUseLimitPersonalAdsState:(BOOL) canUse;


@end

NS_ASSUME_NONNULL_END
