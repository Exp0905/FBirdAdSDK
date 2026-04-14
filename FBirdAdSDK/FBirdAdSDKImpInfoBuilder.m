//
//  CuskyAdSDKImpInfoBuilder.m
//  Test1
//
//  Created by TWind on 2025/4/12.
// CuskyAdSDKImpInfoBuilder.m
#import "FBirdAdSDKImpInfoBuilder.h"
#import <Foundation/Foundation.h>

@implementation FBirdAdSDKImpInfoBuilder

+ (NSDictionary *)buildImpInfoWithTagID:(NSString *)tagid adtype:(int)type {
    NSString *impID = [[NSUUID UUID] UUIDString];
    NSMutableArray *assets = [NSMutableArray array];
    NSInteger nativeLayout = 501;
    // 默认 video 为空字典
    NSDictionary *video = @{};
    
    [assets addObject:@{
        @"id": @2,
        @"isrequired": @1,
        @"img": @{ @"type": @1, @"wmin": @100, @"hmin": @100 }
    }];
    [assets addObject:@{
        @"id": @3,
        @"isrequired": @1,
        @"img": @{ @"type": @2, @"wmin": @100, @"hmin": @100 }
    }];
    [assets addObject:@{
        @"id": @4,
        @"isrequired": @1,
        @"title": @{ @"len": @100 }
    }];
    [assets addObject:@{
        @"id": @5,
        @"isrequired": @1,
        @"data": @{ @"type": @1, @"len": @100 }
    }];
    [assets addObject:@{
        @"id": @6,
        @"isrequired": @1,
        @"data": @{ @"type": @11, @"len": @100 }
    }];
    
    switch (type) {
        case Splash:
            [assets addObject:@{
                @"id": @1,
                @"isrequired": @1,
                @"img": @{ @"type": @3, @"wmin": @720, @"hmin": @1280 }
            }];
        case Interstitial: {
            nativeLayout = 501;
            [assets addObject:@{
                @"id": @1,
                @"isrequired": @1,
                @"img": @{ @"type": @3, @"wmin": @720, @"hmin": @1280 }
            }];
            [assets addObject:@{
                @"id": @7,
                @"isrequired": @1,
                @"data": @{ @"type": @12, @"len": @100 }
            }];
        } break;
            
        case Banner: {
            nativeLayout = 502;
            [assets addObject:@{
                @"id": @1,
                @"isrequired": @1,
                @"img": @{ @"type": @3, @"wmin": @320, @"hmin": @50 }
            }];
            [assets addObject:@{
                @"id": @7,
                @"isrequired": @1,
                @"data": @{ @"type": @12, @"len": @100 }
            }];
        } break;
            
        case Feed: {
            nativeLayout = 3;
            [assets addObject:@{
                @"id": @1,
                @"isrequired": @1,
                @"img": @{ @"type": @3, @"wmin": @1280, @"hmin": @720 }
            }];
            [assets addObject:@{
                @"id": @7,
                @"isrequired": @1,
                @"data": @{ @"type": @12, @"len": @100 }
            }];
        } break;
            
        case Draw:
        case Video:
        case RewardVideo: {
            // 固定用 501 布局
            nativeLayout = 501;
            [assets addObject:@{
                @"id": @1,
                @"isrequired": @1,
                @"img": @{ @"type": @3, @"wmin": @720, @"hmin": @1280 }
            }];
            [assets addObject:@{
                @"id": @9,
                @"isrequired": @1,
                @"video": @{
                    @"wmin": @720,
                    @"hmin": @1280,
                    @"mimes": @[@"video/mp4"]
                }
            }];
        } break;
            
        default:
            break;
    }
    
    NSDictionary *native = @{
        @"layout": @(nativeLayout),
        @"assets": assets
    };
    
    // 组装返回字典
    NSMutableDictionary *impInfo = [@{
        @"id":         impID,
        @"appid":      @"",
        @"tagid":      tagid,
        @"bidfloor":   @1,
        @"native":     native,
        @"isdeeplink": @YES,
        @"isdownload": @YES,
        @"isul":       @YES,
        @"secure":     @1,
        @"pmp":        @{}
    } mutableCopy];
    
    // 如果 videoInfo 不为空，才加 video 字段
    if(type == RewardVideo || type == Draw || type == Video) {
        FBirdAdSDKVideoInfo *videoInfo = [[FBirdAdSDKVideoInfo alloc] init];
        videoInfo.width = 720;
        videoInfo.height = 1280;
        videoInfo.type = 2;
        videoInfo.mimes = @[@"video/mp4"];
        impInfo[@"video"] = [videoInfo toDictionary];
    }
    
    return [impInfo copy];
}
@end
