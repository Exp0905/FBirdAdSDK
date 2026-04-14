//
//  AdResponseModel.h
//  Test1
//
//  Created by zte1234 on 2025/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 视频模型
@interface FBirdSDKVideoContent : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, assign) NSInteger duration;
@end

#pragma mark - 图片模型
@interface FBirdAdSDKNativeImage : NSObject
@property (nonatomic, assign) NSInteger h;
@property (nonatomic, assign) NSInteger w;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *url;
@end

#pragma mark - 标题模型
@interface FBirdAdSDKNativeTitle : NSObject
@property (nonatomic, copy) NSString *text;
@end

#pragma mark - 数据模型
@interface FBirdAdSDKNativeData : NSObject
@property (nonatomic, copy) NSString *value;
@end

#pragma mark - 资源单元
@interface FBirdAdSDKNativeAsset : NSObject
@property (nonatomic, assign) NSInteger assetId;
@property (nonatomic, assign) BOOL isrequired;
@property (nonatomic, strong) FBirdAdSDKNativeImage *img;
@property (nonatomic, strong) FBirdAdSDKNativeTitle *title;
@property (nonatomic, strong) FBirdSDKVideoContent *video;
@property (nonatomic, strong) FBirdAdSDKNativeData *data;
@end

#pragma mark - 原生广告内容
@interface FBirdAdSDKNativeContent : NSObject
@property (nonatomic, strong) NSArray<FBirdAdSDKNativeAsset *> *assets;
@end

#pragma mark - 广告对象
@interface FBirdAdSDKAdmObject : NSObject
@property (nonatomic, strong) FBirdSDKVideoContent *video;
@property (nonatomic, strong) FBirdAdSDKNativeContent *native;
@end

#pragma mark - 事件跟踪
@interface FBirdAdSDKTrackingEvents : NSObject
@property (nonatomic, strong) NSArray<NSString *> *imp_urls;
@property (nonatomic, strong) NSArray<NSString *> *click_urls;
@property (nonatomic, strong) NSArray<NSString *> *deeplink_urls;
@end

#pragma mark - 竞价单元
@interface FBirdAdSDKBid : NSObject
@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *deeplink;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *bidId;
@property (nonatomic, copy) NSString *crid;  // 修改为NSString类型
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy) NSString *impid;
@property (nonatomic, strong) FBirdAdSDKAdmObject *admobject;
@property (nonatomic, copy) NSString *adid;
@property (nonatomic, copy) NSString *nurl;
@property (nonatomic, strong) FBirdAdSDKTrackingEvents *events;
@end

#pragma mark - 席位竞价
@interface FBirdAdSDKSeatBid : NSObject
@property (nonatomic, strong) NSArray<FBirdAdSDKBid *> *bid;
@end

#pragma mark - 完整响应
@interface FBirdAdSDKAdResponseModel : NSObject
@property (nonatomic, copy) NSString *responseId;
@property (nonatomic, copy) NSString *bidid;
@property (nonatomic, strong) FBirdAdSDKSeatBid *seatbid;
/// 原始 JSON 字典（用于调试、数据透传等）
@property (nonatomic, strong, nullable) NSDictionary *rawJSON;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

#pragma mark - 完整响应
@interface FBirdAdSDKAdResponseDataModel : NSObject
@property (nonatomic, copy) NSString *data;
/// 原始 JSON 字典（用于调试、数据透传等）
@property (nonatomic, strong, nullable) NSDictionary *rawJSON;
- (instancetype)initWithDateDictionary:(NSDictionary *)dict;

@end

#pragma mark - 请求视频模型
@interface FBirdAdSDKVideoInfo : NSObject

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray<NSString *> *mimes;

- (NSDictionary *)toDictionary;

@end
NS_ASSUME_NONNULL_END

