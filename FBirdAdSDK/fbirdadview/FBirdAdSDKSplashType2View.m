//
//  CuskyAdSplashType2View.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKSplashType2View.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKSplashType2View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUpGesture];
    // 1. Skip Container
    self.skipContainerView = [[UIView alloc] init];
    self.skipContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.skipContainerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.skipContainerView.layer.cornerRadius = 12.5;
    self.skipContainerView.clipsToBounds = YES;
    self.skipContainerView.layer.cornerRadius = 6;
    [self addSubview:self.skipContainerView];

    self.skipLabel = [[UILabel alloc] init];
    self.skipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.skipLabel.text = @"跳过广告";
    self.skipLabel.font = [UIFont systemFontOfSize:13];
    [self.skipContainerView addSubview:self.skipLabel];

    // 2. Main Image
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.mainImageV];

    // 3. Bottom Container
    self.bottomContainerView = [[UIView alloc] init];
    self.bottomContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.bottomContainerView];

    self.arrowImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_draw_up"]];
    self.arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.bottomContainerView addSubview:self.arrowImageView];

    self.swipeLabel = [[UILabel alloc] init];
    self.swipeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.swipeLabel.text = @"向上滑动";
    self.swipeLabel.font = [UIFont systemFontOfSize:21];
    self.swipeLabel.textColor = [UIColor whiteColor];
    [self.bottomContainerView addSubview:self.swipeLabel];

    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerNameL.text = @"跳转至博世智能出行";
    self.centerNameL.font = [UIFont systemFontOfSize:15];
    self.centerNameL.textColor = [UIColor whiteColor];
    [self.bottomContainerView addSubview:self.centerNameL];
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_ad"]];
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cornerImageView.clipsToBounds = YES;
    self.cornerImageView.userInteractionEnabled = NO;
    [self addSubview:self.cornerImageView];
}

- (void)setupConstraints {
    // Skip Container
    [NSLayoutConstraint activateConstraints:@[
        [self.skipContainerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [self.skipContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        [self.skipContainerView.heightAnchor constraintEqualToConstant:25],

        [self.skipLabel.leadingAnchor constraintEqualToAnchor:self.skipContainerView.leadingAnchor constant:8],
        [self.skipLabel.trailingAnchor constraintEqualToAnchor:self.skipContainerView.trailingAnchor constant:-8],
        [self.skipLabel.centerYAnchor constraintEqualToAnchor:self.skipContainerView.centerYAnchor],
    ]];

    // Main ImageView
    [NSLayoutConstraint activateConstraints:@[
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:30],
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
        [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
        [self.cornerImageView.heightAnchor constraintEqualToConstant:16],
    ]];

    // Bottom Container
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:50],
        [self.bottomContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [self.bottomAnchor constraintEqualToAnchor:self.bottomContainerView.bottomAnchor constant:110],
    ]];

    // Arrow
    [NSLayoutConstraint activateConstraints:@[
        [self.arrowImageView.topAnchor constraintEqualToAnchor:self.bottomContainerView.topAnchor constant:8],
        [self.arrowImageView.centerXAnchor constraintEqualToAnchor:self.bottomContainerView.centerXAnchor],
        [self.arrowImageView.widthAnchor constraintEqualToConstant:34],
        [self.arrowImageView.heightAnchor constraintEqualToConstant:22],
    ]];

    // Swipe Label
    [NSLayoutConstraint activateConstraints:@[
        [self.swipeLabel.topAnchor constraintEqualToAnchor:self.arrowImageView.bottomAnchor constant:22],
        [self.swipeLabel.centerXAnchor constraintEqualToAnchor:self.bottomContainerView.centerXAnchor],
    ]];

    // Jump Label
    [NSLayoutConstraint activateConstraints:@[
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.swipeLabel.bottomAnchor constant:8],
        [self.centerNameL.centerXAnchor constraintEqualToAnchor:self.bottomContainerView.centerXAnchor],
        [self.bottomContainerView.bottomAnchor constraintEqualToAnchor:self.centerNameL.bottomAnchor]
    ]];
}

- (void)handleSwipeUp {
    if (self.onSwipeUpTriggered) {
        self.onSwipeUpTriggered();  // 执行跳转回调
    } else {
        // 默认行为（可选）：打开一个链接或页面
//        NSLog(@"未设置跳转回调");
    }
}
@end
