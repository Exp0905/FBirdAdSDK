//
//  PreferencesManager.m
//  Test1
//
//  Created by admin on 2025/7/4.
//

#import "FBirdAdSDKPreferencesManager.h"

@implementation FBirdAdSDKPreferencesManager

+ (instancetype)shared {
    static FBirdAdSDKPreferencesManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FBirdAdSDKPreferencesManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark 

- (void)setCanUseIDFVState:(BOOL)canuse{
    [[NSUserDefaults standardUserDefaults] setBool: canuse  forKey:@"FBird_CanUse_IDFV"];
    [[NSUserDefaults standardUserDefaults] synchronize];
};
- (BOOL)isIDFVState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"FBird_CanUse_IDFV"];
};

- (void)setCanUseIDFAState:(BOOL)canuse {
    [[NSUserDefaults standardUserDefaults] setBool:canuse  forKey:@"FBird_CanUse_IDFA"];
    [[NSUserDefaults standardUserDefaults] synchronize];
};
- (BOOL)isIDFAState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"FBird_CanUse_IDFA"];
};


- (void)setCanUseLimitPersonalAdsState:(BOOL)canuse {
    [[NSUserDefaults standardUserDefaults] setBool:canuse  forKey:@"FBird_CanUse_LimitPersonalAds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
};
- (BOOL)isLimitPersonalAdsState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"FBird_CanUse_LimitPersonalAds"];
};


@end
