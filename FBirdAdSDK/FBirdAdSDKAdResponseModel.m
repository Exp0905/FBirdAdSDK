//
//  AdResponseModel.m
//  Test1
//
//  Created by zte1234 on 2025/4/19.
//

// AdResponseModel.m
#import "FBirdAdSDKAdResponseModel.h"
@implementation FBirdAdSDKVideoInfo
- (NSDictionary *)toDictionary {
    return @{
        @"w": @(self.width),
        @"h": @(self.height),
        @"type": @(self.type),
        @"mimes": self.mimes ?: @[]
    };
}
@end
@implementation FBirdSDKVideoContent
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _url = dict[@"url"] ?: @"";
        _cover = dict[@"cover"] ?: @"";
        _duration = [dict[@"duration"] integerValue];
    }
    return self;
}
@end

@implementation FBirdAdSDKNativeImage
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _h = [dict[@"h"] integerValue];
        _w = [dict[@"w"] integerValue];
        _type = [dict[@"type"] integerValue];
        _url = dict[@"url"] ?: @"";
    }
    return self;
}
@end

@implementation FBirdAdSDKNativeTitle
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _text = dict[@"text"] ?: @"";
    }
    return self;
}
@end

@implementation FBirdAdSDKNativeData
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _value = dict[@"value"] ?: @"";
    }
    return self;
}
@end

@implementation FBirdAdSDKNativeAsset
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _assetId = [dict[@"id"] integerValue];
        _isrequired = [dict[@"isrequired"] boolValue];
        
        if (dict[@"img"]) {
            _img = [[FBirdAdSDKNativeImage alloc] initWithDictionary:dict[@"img"]];
        }
        if (dict[@"title"]) {
            _title = [[FBirdAdSDKNativeTitle alloc] initWithDictionary:dict[@"title"]];
        }
        if (dict[@"video"]) {
            _video = [[FBirdSDKVideoContent alloc] initWithDictionary:dict[@"video"]];
        }
        if (dict[@"data"]) {
            _data = [[FBirdAdSDKNativeData alloc] initWithDictionary:dict[@"data"]];
        }
    }
    return self;
}
@end

@implementation FBirdAdSDKNativeContent
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSMutableArray *assets = [NSMutableArray new];
        for (NSDictionary *assetDict in dict[@"assets"]) {
            [assets addObject:[[FBirdAdSDKNativeAsset alloc] initWithDictionary:assetDict]];
        }
        _assets = [assets copy];
    }
    return self;
}
@end

@implementation FBirdAdSDKAdmObject
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _video = [[FBirdSDKVideoContent alloc] initWithDictionary:dict[@"video"]];
        _native = [[FBirdAdSDKNativeContent alloc] initWithDictionary:dict[@"native"]];
    }
    return self;
}
@end

@implementation FBirdAdSDKTrackingEvents
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _imp_urls = dict[@"imp_urls"] ?: @[];
        _click_urls = dict[@"click_urls"] ?: @[];
        _deeplink_urls = dict[@"deeplink_urls"] ?: @[];
    }
    return self;
}
@end

@implementation FBirdAdSDKBid
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _target = dict[@"target"] ?: @"";
        _deeplink = dict[@"deeplink"] ?: @"";
        _action = dict[@"action"] ?: @"0";
        _bidId = dict[@"id"] ?: @"";
        _crid = dict[@"crid"] ?: @"0";    // 修正类型
        _price = [dict[@"price"] integerValue];
        _impid = dict[@"impid"] ?: @"";
        _admobject = [[FBirdAdSDKAdmObject alloc] initWithDictionary:dict[@"admobject"]];
        _adid = dict[@"adid"] ?: @"";
        _nurl = dict[@"nurl"] ?: @"";
        _events = [[FBirdAdSDKTrackingEvents alloc] initWithDictionary:dict[@"events"]];
    }
    return self;
}
@end

@implementation FBirdAdSDKSeatBid
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSMutableArray *bids = [NSMutableArray new];
        for (NSDictionary *bidDict in dict[@"bid"]) {
            [bids addObject:[[FBirdAdSDKBid alloc] initWithDictionary:bidDict]];
        }
        _bid = [bids copy];
    }
    return self;
}
@end

@implementation FBirdAdSDKAdResponseModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _responseId = dict[@"id"] ?: @"";
        _bidid = dict[@"bidid"] ?: @"";
        _seatbid = [[FBirdAdSDKSeatBid alloc] initWithDictionary:dict[@"seatbid"]];
        _rawJSON = dict; // 保存原始数据
    }
    return self;
}
@end

@implementation FBirdAdSDKAdResponseDataModel
- (instancetype)initWithDateDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _data = dict[@"data"] ?: @"";
        _rawJSON = dict; // 保存原始数据
    }
    return self;
}
@end
