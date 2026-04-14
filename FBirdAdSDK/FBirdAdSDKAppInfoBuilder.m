//
//  AppInfoBuilder.m
//  Test1
//
//  Created by TWind on 2025/4/12.
//

#import "FBirdAdSDKAppInfoBuilder.h"

@implementation FBirdAdSDKAppInfoBuilder
+ (NSDictionary *)buildAppInfo {
    NSBundle *bundle = [NSBundle mainBundle];
    return @{
        @"bundle": [bundle bundleIdentifier] ?: @"cn.syn.ad.sdk",
        @"name": [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: @"",
        @"version": [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @""
    };
}
@end
