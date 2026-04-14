//
//  CuskyAdSDKDeviceInfoBuilder.h
//  Test1
//
//  Created by TWind on 2025/4/12.
//

#import <Foundation/Foundation.h>
#import "FBirdAdSDKPreferencesManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBirdAdSDKDeviceInfoBuilder : NSObject
+ (void)buildDeviceInfoWithGeo:(void (^)(NSDictionary *info))completion;
+ (NSDictionary *)buildDeviceInfoWithoutGeo;
@end

NS_ASSUME_NONNULL_END
