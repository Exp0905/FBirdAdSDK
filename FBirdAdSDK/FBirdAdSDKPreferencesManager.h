//
//  PreferencesManager.h
//  Test1
//
//  Created by admin on 2025/7/4.
//
#import <Foundation/Foundation.h>

@interface FBirdAdSDKPreferencesManager : NSObject

+ (instancetype)shared;


- (void)setCanUseIDFVState:(BOOL)canuse;
- (BOOL)isIDFVState;

- (void)setCanUseIDFAState:(BOOL)canuse;
- (BOOL)isIDFAState;


- (void)setCanUseLimitPersonalAdsState:(BOOL)canuse;
- (BOOL)isLimitPersonalAdsState;

@end
