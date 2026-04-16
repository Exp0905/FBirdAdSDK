//
//  CuskyAdSDKView.h
//  Test1
//
//  Created by TWind on 2025/4/26.
//

#import <UIKit/UIKit.h>
//#import "CuskyAdSDK.h"
//#import "CuskyAdSDKAdResponseModel.h"
#import <FBirdAdSDK/FBirdAdSDK.h>
#import <FBirdAdSDK/FBirdAdSDKAdResponseModel.h>
//#import "FBirdAdSDK.h"
//#import "FBirdAdSDKAdResponseModel.h"
NS_ASSUME_NONNULL_BEGIN

// CuskyADSDKSynAdRenderVideoModel.h (or in the .m file if it's a private method)
@interface FBirdAdSDKSynAdRenderVideoModel : NSObject
@property (nonatomic, copy) NSString *url;              // 视频播放URL
@property (nonatomic, copy) NSString *cover;            // 视频封面图片URL
@property (nonatomic, assign) NSInteger duration;       // 视频时长
@property (nonatomic, assign) NSInteger width;          // 视频宽度 (如果AdmObject中有此信息)
@property (nonatomic, assign) NSInteger height;         // 视频高度 (如果AdmObject中有此信息)

- (NSDictionary *)toDictionary; // Add this method declaration
@end

// SynAdRenderModel.h (or in the .m file if it's a private method)
@interface FBirdAdSDKSynAdRenderModel : NSObject
@property (nonatomic, copy) NSString *imgUrl;           // 主图片URL
@property (nonatomic, copy) NSString *iconUrl;          // 图标URL
@property (nonatomic, copy) NSString *logoUrl;          // Logo URL (可能与iconUrl相同或不同)
@property (nonatomic, copy) NSString *title;            // 标题文本
@property (nonatomic, copy) NSString *desc;             // 描述文本
@property (nonatomic, copy) NSString *source;           // 来源文本
@property (nonatomic, copy) NSString *callButtonText;   // 行动按钮文本
@property (nonatomic, strong) FBirdAdSDKSynAdRenderVideoModel *videoModel; // Change id to specific class
@property (nonatomic, strong) NSArray<NSString *> *impUrls;         // 曝光跟踪URL
@property (nonatomic, strong) NSArray<NSString *> *clickUrls;       // 点击跟踪URL
@property (nonatomic, strong) NSArray<NSString *> *deeplinkUrls;    // Deeplink URL
@property (nonatomic, assign) double *sws;
@property (nonatomic, assign) double *swc;
@property (nonatomic, assign) double *swu;
@property (nonatomic, assign) double *swf;
- (NSDictionary *)toDictionary; // Add this method declaration
@end

/// 广告用户行为类型定义
typedef NSString * FBirdAdUserActionType NS_STRING_ENUM;
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeClose;        ///< 点击关闭广告
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeSkip;         ///< 点击跳过广告
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeConfirmExit;  ///< 点击坚持退出广告
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeSwipeUp;     ///< 向上滑动行为
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeShake;       ///< 设备晃动行为
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeClickDetail; ///< 用户点击详情
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeOnAdReward; ///< 奖励发放
FOUNDATION_EXPORT FBirdAdUserActionType const FBirdAdUserActionTypeOnAdShow; ///< 广告展示


/// 广告用户行为回调（如关闭、跳过、退出等）
typedef void(^FBirdAdUserActionCallback)(FBirdAdUserActionType actionType);

// 前向声明
@class FBirdAdSDKView;

@protocol FBirdAdSDKViewDelegate <NSObject>
- (void)adViewDidShake:(FBirdAdSDKView *)adView;
@end

@interface FBirdAdSDKView : UIView
@property (nonatomic, weak) id<FBirdAdSDKViewDelegate> delegate;
@property (nonatomic, strong) UILabel *topTitle; // 标题素材
@property (nonatomic, strong) UILabel *centerNameL; // 来源素材
@property (nonatomic, strong) UILabel *centerDetailL; // 描述素材
@property (nonatomic, strong) UIImageView *adLogoImageV; //logo视图 图标素材
@property (nonatomic, strong) UIImageView *mainImageV; //主图片素材
@property (nonatomic, strong) UIButton *actionButton; //行动按钮文本素材
@property (nonatomic, strong) UIImageView *closeImageView; //关闭按钮
@property (nonatomic, strong) UIImageView *cornerImageView; //广告图片
@property (nonatomic, strong) FBirdAdSDKBid * bid;
/// 广告用户行为事件回调属性
@property (nonatomic, copy) FBirdAdUserActionCallback userActionCallback;
// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame adtype:(int)adtype sensitivity:(double)sensitivity;
// 配置视图内容
- (void)configureWithBid:(FBirdAdSDKBid *)bid;
- (void)showToView:(UIView *)containerView;
/// 关闭当前广告视图，从父视图中移除
- (void)closeAdView;
/// 处理摇一摇事件
- (void)handleShakeEvent;
//自渲染点击事件
- (void)registerClickableViews:(NSArray<UIView *> *)views;
@end

NS_ASSUME_NONNULL_END
