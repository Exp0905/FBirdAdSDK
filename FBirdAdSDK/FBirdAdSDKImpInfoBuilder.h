//
//  CuskyAdSDKImpInfoBuilder.h
//  Test1
//
//  Created by TWind on 2025/4/12.
//

#import <Foundation/Foundation.h>
#import "FBirdAdSDKManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface FBirdAdSDKImpInfoBuilder : NSObject
+ (NSDictionary *)buildImpInfoWithTagID:(NSString *)tagid adtype:(int)adtype;
@end

NS_ASSUME_NONNULL_END
