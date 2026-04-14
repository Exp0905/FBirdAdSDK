// CuskyAdSDKManager.m

#import "FBirdAdSDKManager.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "FBirdAdSDKDeviceInfoBuilder.h"
#import "FBirdAdSDKUserInfoBuilder.h"
#import "FBirdAdSDKImpInfoBuilder.h"
#import "FBirdAdSDKAppInfoBuilder.h"
#import "FBirdAdSDKAESHelper.h"
#import "FBirdAdSDKPreferencesManager.h"
#import "FBirdAdSDK.h"


@implementation FBirdAdSDKManager

static BOOL kCuskyLogEnabled = false;

#pragma mark - JSON 日志辅助
void CuskyLogJSON(NSString *prefix, NSDictionary *jsonDict) {
    if (!jsonDict) return;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        NSLog(@"❌ JSON 序列化失败: %@", error);
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (prefix.length > 0) {
        jsonStr = [NSString stringWithFormat:@"%@\n%@", prefix, jsonStr];
    }
    NSUInteger maxLen = 1000, idx = 0;
    while (idx < jsonStr.length) {
        NSUInteger len = MIN(maxLen, jsonStr.length - idx);
        NSLog(@"%@", [jsonStr substringWithRange:NSMakeRange(idx, len)]);
        idx += len;
    }
}

#pragma mark - 公有：多次请求
+ (void)loadAdsWithTagID:(NSString *)tagid
                    caid:(NSString *)caid
                   adtype:(int)adtype
            requestCount:(NSInteger)requestCount
              completion:(void (^)(NSArray<FBirdAdSDKAdResponseModel *> *, NSArray<NSError *> *))completion
{
    if (requestCount <= 0) {
        if (completion) completion(@[], @[]);
        return;
    }
    
    // 1) 先一次性获取 Device 信息（含定位 & CT）
    [FBirdAdSDKDeviceInfoBuilder buildDeviceInfoWithGeo:^(NSDictionary *device) {
        NSMutableDictionary *baseDevice = [device mutableCopy];
        if (caid.length) {
            baseDevice[@"caid"] = caid;
        }
        
        // 2) 并行发起 N 次广告请求
        dispatch_group_t  group      = dispatch_group_create();
        dispatch_queue_t  syncQueue  = dispatch_queue_create("com.cusky.loadads.sync", DISPATCH_QUEUE_SERIAL);
        NSMutableArray   *allResps   = [NSMutableArray arrayWithCapacity:requestCount];
        NSMutableArray   *allErrors  = [NSMutableArray arrayWithCapacity:requestCount];
        
        NSDictionary *app    = [FBirdAdSDKAppInfoBuilder buildAppInfo];
        NSDictionary *user   = [FBirdAdSDKUserInfoBuilder buildUserInfo];
        NSDictionary *imp    = [FBirdAdSDKImpInfoBuilder buildImpInfoWithTagID:tagid adtype:adtype];
        if (kCuskyLogEnabled) {
            if (!device[@"lat"] || !device[@"lon"]) {
                NSLog(@"Location data not available, proceeding without location info.");
            } else {
                // Print latitude and longitude
                NSLog(@"Latitude: %@, Longitude: %@", device[@"lat"], device[@"lon"]);
            }
        }
        for (NSInteger i = 0; i < requestCount; i++) {
            dispatch_group_enter(group);
            [self __buildAndRequestWithTagID:tagid
                                         imp:imp
                                         app:app
                                        user:user
                                      device:baseDevice
                                  completion:^(FBirdAdSDKAdResponseModel * _Nullable resp,
                                               NSError         * _Nullable err) {
                dispatch_async(syncQueue, ^{
                    if (resp) [allResps addObject:resp];
                    if (err)  [allErrors addObject:err];
                    dispatch_group_leave(group);
                });
            }];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            // 只打印一次响应汇总
            if (kCuskyLogEnabled) {
                NSLog(@"📥 所有响应汇总:");
                for (FBirdAdSDKAdResponseModel *resp in allResps) {
                    CuskyLogJSON(@" - 响应:", resp.rawJSON);
                }
            }
            if (completion) {
                completion([allResps copy], [allErrors copy]);
            }
        });
    }];
}
//+(void) canUseIDFV

#pragma mark - 公有：多视图广告请求
+ (void)loadAdViewsWithTagID:(NSString *)tagid
                        caid:(NSString *)caid
                      adtype:(int)adtype
                requestCount:(NSInteger)requestCount
                  completion:(void (^)(NSArray<FBirdAdSDKView *> * _Nullable adViews, NSArray<NSError *> * _Nullable errors))completion
{
    [self loadAdsWithTagID:tagid
                      caid:caid
                    adtype:adtype
              requestCount:requestCount
                completion:^(NSArray<FBirdAdSDKAdResponseModel *> *responses, NSArray<NSError *> *errors) {
        
        NSMutableArray<FBirdAdSDKView *> *resultViews = [NSMutableArray array];
        
        for (FBirdAdSDKAdResponseModel *model in responses) {
            for (FBirdAdSDKBid *bid in model.seatbid.bid) {
                CGSize adSize = [self sizeForStyle:adtype];
                FBirdAdSDKView *adView = [[FBirdAdSDKView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)
                                                                        adtype:adtype];
                [adView configureWithBid:bid];
                [resultViews addObject:adView];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion([resultViews copy], [errors copy]);
            }
        });
    }];
}


// 根据广告样式返回推荐宽高（单位：pt）
#pragma mark
+(CGSize)sizeForStyle:(int)adType {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    switch (adType) {
        case Feed:
            return CGSizeMake(screenBounds.size.width, 387);
        case Interstitial:
            return screenBounds.size;
        case Banner:
            return CGSizeMake(screenBounds.size.width, 166);
        case Splash:
            return screenBounds.size;
        case RewardVideo:
            return screenBounds.size;
        case Video:
            return screenBounds.size;
        default:
            return CGSizeMake(300, 80);
    }
}

#pragma mark - 私有：网络构建 & 请求
+ (void)__buildAndRequestWithTagID:(NSString *)tagid
                               imp:(NSDictionary *)imp
                               app:(NSDictionary *)app
                              user:(NSDictionary *)user
                            device:(NSDictionary *)device
                        completion:(void (^)(FBirdAdSDKAdResponseModel * _Nullable, NSError * _Nullable))completion
{
    NSString *requestID = [[NSUUID UUID] UUIDString];
    NSDictionary *bidRequest = @{
        @"id":      requestID,
        @"version": @"2.0",
        @"imp":     @[imp],
        @"app":     app,
        @"device":  device,
        @"user":    user
    };
    if (kCuskyLogEnabled) {
        CuskyLogJSON(@"📤 Request:", bidRequest);
    }
    
    NSError *jsonError = nil;
    NSData *decryptbody = [NSJSONSerialization dataWithJSONObject:bidRequest options:0 error:&jsonError];
    if (jsonError) {
        if (completion) completion(nil, jsonError);
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:decryptbody encoding:NSUTF8StringEncoding];
    NSString *decryptedText = [FBirdAdSDKAESHelper encrypt:jsonString];
    
    NSDictionary *body= @{
        @"data" : decryptedText
    };
    if (kCuskyLogEnabled) {
        CuskyLogJSON(@"📤 Request:", body);
    }
    jsonError = nil;
    NSData *reqbody = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];
    
    if (jsonError) {
        if (completion) completion(nil, jsonError);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"https://req.adx.xlqeai.com/sdk/request"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    req.HTTPBody   = reqbody;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:req
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (completion) completion(nil, error);
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
        if (httpResp.statusCode == 200 && data) {
            NSError *parseErr;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
            if (parseErr) {
                if (completion) completion(nil, parseErr);
            } else {
                FBirdAdSDKAdResponseDataModel *date = [[FBirdAdSDKAdResponseDataModel alloc] initWithDateDictionary:json];
                NSString *resp = [FBirdAdSDKAESHelper decrypt:date.data] ;
                if(resp.length > 0) {
                    NSData *respdata = [resp dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *respjson = [NSJSONSerialization JSONObjectWithData:respdata options:0 error:&parseErr];
                    FBirdAdSDKAdResponseModel *model = [[FBirdAdSDKAdResponseModel alloc] initWithDictionary:respjson];
                    if (completion) completion(model, nil);
                }

            }
        } else {
            NSString *msg = [NSString stringWithFormat:@"状态码 %ld", (long)httpResp.statusCode];
            NSError *respErr = [NSError errorWithDomain:@"FBirdAdSDK"
                                                   code:httpResp.statusCode
                                               userInfo:@{NSLocalizedDescriptionKey: msg}];
            if (completion) completion(nil, respErr);
        }
    }];
    [task resume];
}

#pragma mark - 点击/曝光 上报
+ (void)reportClickWithAdResponse:(FBirdAdSDKBid *)adResponse
                             view:(UIView *)view
                          urlType:(FBirdAdSDKAdUrlType)type
                       clickPoint:(CGPoint)pt
                       completion:(FBirdAdSDKAdUrlCompletionBlock)completion
{
    FBirdAdSDKBid *bid = adResponse;
    if (!bid) {
        if (completion) completion(NO, [NSError errorWithDomain:@"FBirdAdSDK" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"无有效Bid"}]);
        return;
    }
    NSArray<NSString *> *rawUrls;
    switch (type) {
        case CuskyAdSDKAdUrlTypeClick:     rawUrls = bid.events.click_urls;    break;
        case CuskyAdSDKAdUrlTypeDeepLink:  rawUrls = bid.events.deeplink_urls.count>0 ? bid.events.deeplink_urls : (bid.deeplink?@[bid.deeplink]:@[]); break;
        case CuskyAdSDKAdUrlTypeImpression:rawUrls = bid.events.imp_urls.count>0       ? bid.events.imp_urls       : (bid.nurl?@[bid.nurl]:@[]);       break;
    }
    if (rawUrls.count == 0) {
        if (completion) completion(NO, [NSError errorWithDomain:@"FBirdAdSDK" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"无有效URL"}]);
        return;
    }
//    NSString *urlTpl = rawUrls.firstObject;
//    NSString *urlStr = [self replaceMacrosInUrl:urlTpl fromView:view clickPoint:pt winPrice:[NSString stringWithFormat:@"%ld",(long)bid.price]];
//    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    if (kCuskyLogEnabled) {
//        NSLog(@"🔗 上报URL: %@", urlStr);
//    }
//    
//    
//    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
//        BOOL success = (!err && ((NSHTTPURLResponse*)resp).statusCode/100 == 2);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) completion(success, err);
//        });
//    }] resume];
    
    for (int i = 0; i < rawUrls.count; i++) {
        NSString *urlTpl = rawUrls[i];
        NSString *urlStr = [self replaceMacrosInUrl:urlTpl fromView:view clickPoint:pt winPrice:[NSString stringWithFormat:@"%ld",(long)bid.price]];
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        if (kCuskyLogEnabled) {
            NSLog(@"🔗 上报URL: %@", urlStr);
        }
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
            BOOL success = (!err && ((NSHTTPURLResponse*)resp).statusCode/100 == 2);
            if(i == rawUrls.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(success, err);
                });
            }
       
            if (kCuskyLogEnabled) {
                NSLog(@"🔗 上报状态: %ld", ((NSHTTPURLResponse*)resp).statusCode);
            }
        }] resume];
    }
}

#pragma mark - URL 宏替换
+ (NSString *)replaceMacrosInUrl:(NSString *)url
                        fromView:(UIView *)view
                       clickPoint:(CGPoint)pt
                         winPrice:(NSString *)winPrice
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString *ts  = [@( (long long)(now*1000) ) stringValue];
    NSString *tts = [@( (long long)now ) stringValue];
    CGRect frame = [view convertRect:view.bounds toView:UIApplication.sharedApplication.keyWindow];
    NSDictionary *map = @{
        @"__TS__":      ts,
        @"__TTS__":     tts,
        @"__WINPRICE__":winPrice,
        @"__PWIDTH__":  @((int)CGRectGetWidth(view.bounds)).stringValue,
        @"__PHEIGHT__": @((int)CGRectGetHeight(view.bounds)).stringValue,
        @"__AD_LT_X__": @((int)CGRectGetMinX(frame)).stringValue,
        @"__AD_LT_Y__": @((int)CGRectGetMinY(frame)).stringValue,
        @"__AD_RB_X__": @((int)CGRectGetMaxX(frame)).stringValue,
        @"__AD_RB_Y__": @((int)CGRectGetMaxY(frame)).stringValue,
        @"__DOWN_X__":  @((int)pt.x).stringValue,
        @"__DOWN_Y__":  @((int)pt.y).stringValue,
        @"__UP_X__":    @((int)pt.x).stringValue,
        @"__UP_Y__":    @((int)pt.y).stringValue,
        @"__SLD__":     @"0",
        @"__CLICKAREA__":@"1"
    };
    for (NSString *key in map) {
        url = [url stringByReplacingOccurrencesOfString:key withString:map[key]];
    }
    return url;
}

#pragma mark - URL 类型描述
+ (NSString *)nameForUrlType:(FBirdAdSDKAdUrlType)type {
    switch (type) {
        case CuskyAdSDKAdUrlTypeClick:      return @"点击上报";
        case CuskyAdSDKAdUrlTypeDeepLink:   return @"深度链接";
        case CuskyAdSDKAdUrlTypeImpression: return @"曝光上报";
    }
}
+ (NSString *)sdkVersion {
    return @"1.0.2";
}

+(void) setCanUseIDFVState:(BOOL) canUse{
    [[FBirdAdSDKPreferencesManager shared] setCanUseIDFVState:canUse];
}


//是否获取IDFA
+(void)setCanUseIDFAState:(BOOL) canUse{
    [[FBirdAdSDKPreferencesManager shared] setCanUseIDFAState:canUse];
    
};

//个性化广告设置
+(void)setCanUseLimitPersonalAdsState:(BOOL) canUse{
    [[FBirdAdSDKPreferencesManager shared] setCanUseLimitPersonalAdsState:canUse];
    
};
@end
