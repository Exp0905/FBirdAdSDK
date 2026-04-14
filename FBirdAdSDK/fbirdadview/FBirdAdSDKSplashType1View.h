//
//  CuskyAdSDKSplashType1View.h
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FBirdAdSplashType1ViewDelegate <NSObject>

- (void)splashViewDidSkip:(UIView *)splashView;
- (void)splashViewDidShake:(UIView *)splashView;

@end

@interface FBirdAdSDKSplashType1View : FBirdAdSDKView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *adLogoContainerView;
//跳过
@property (nonatomic, strong) UIView *skipView;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UILabel *skipLabel;
@property (nonatomic, strong) UIView *separatorLine;

@property (nonatomic, strong) UIView *shakeView;
@property (nonatomic, strong) UIImageView *shakeImageView;
@property (nonatomic, strong) UILabel *shakeLabel;
@property (nonatomic, weak) id<FBirdAdSplashType1ViewDelegate> delegate;

- (void)startCountdownFrom:(NSInteger)seconds;
- (void)stopCountdown;
@end

NS_ASSUME_NONNULL_END
