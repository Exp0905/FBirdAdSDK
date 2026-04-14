//
//  CuskyAdSDKView.h
//  Test1
//
//  Created by TWind on 2025/4/26.
//

#import <UIKit/UIKit.h>
//#import "CuskyAdSDK.h"
//#import "CuskyAdSDKAdResponseModel.h"
#import <CuskyAdSDK/FBirdAdSDK.h>
#import <CuskyAdSDK/FBirdAdSDKAdResponseModel.h>
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

- (NSDictionary *)toDictionary; // Add this method declaration
@end


@interface FBirdAdSDKView : UIView
@property (nonatomic, strong) UILabel *topTitle; // 标题素材
@property (nonatomic, strong) UILabel *centerNameL; // 来源素材
@property (nonatomic, strong) UILabel *centerDetailL; // 描述素材
@property (nonatomic, strong) UIImageView *adLogoImageV; //logo视图 图标素材
@property (nonatomic, strong) UIImageView *mainImageV; //主图片素材
@property (nonatomic, strong) UIButton *actionButton; //行动按钮文本素材
@property (nonatomic, strong) UIImageView *closeImageView; //关闭按钮
@property (nonatomic, strong) UIImageView *cornerImageView; //广告图片
@property (nonatomic, strong) FBirdAdSDKBid * bid;
// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame adtype:(FBirdAdType)adType;
// 配置视图内容
- (void)configureWithBid:(FBirdAdSDKBid *)bid;
/// 关闭当前广告视图，从父视图中移除
- (void)closeAdView;
@end

NS_ASSUME_NONNULL_END
