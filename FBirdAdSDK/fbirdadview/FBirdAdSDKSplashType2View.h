//
//  CuskyAdSDKSplashType2View.h
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBirdAdSDKSplashType2View : FBirdAdSDKView
@property (nonatomic, strong) UIView *skipContainerView;
@property (nonatomic, strong) UILabel *skipLabel;
@property (nonatomic, strong) UIView *bottomContainerView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *swipeLabel;
@property (nonatomic, copy) void (^onSwipeUpTriggered)(void);

@end

NS_ASSUME_NONNULL_END
