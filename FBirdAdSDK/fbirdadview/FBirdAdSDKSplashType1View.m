//
//  CuskyAdSplashType1View.m
//

#import "FBirdAdSDKSplashType1View.h"
#import "FBirdAdSDKResourceManager.h"
@interface FBirdAdSDKSplashType1View ()

@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger remainingSeconds;

@end

@implementation FBirdAdSDKSplashType1View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentView];
    
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.mainImageV];
    
    self.adLogoContainerView = [[UIView alloc] init];
    self.adLogoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.adLogoContainerView];
    
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_ad"]];
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cornerImageView.clipsToBounds = YES;
    self.cornerImageView.userInteractionEnabled = NO;
    [self.adLogoContainerView addSubview:self.cornerImageView];
    
    self.skipView = [[UIView alloc] init];
    self.skipView.translatesAutoresizingMaskIntoConstraints = NO;
    self.skipView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.skipView.layer.cornerRadius = 12.5;
    self.skipView.clipsToBounds = YES;
    [self.contentView addSubview:self.skipView];
    
    self.countdownLabel = [[UILabel alloc] init];
    self.countdownLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.countdownLabel.text = @"4s";
    self.countdownLabel.textColor = UIColor.whiteColor;
    self.countdownLabel.font = [UIFont systemFontOfSize:13];
    [self.skipView addSubview:self.countdownLabel];
    
    self.skipLabel = [[UILabel alloc] init];
    self.skipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.skipLabel.text = @"跳过";
    self.skipLabel.textColor = UIColor.whiteColor;
    self.skipLabel.font = [UIFont systemFontOfSize:13];
    [self.skipView addSubview:self.skipLabel];
    
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.separatorLine.backgroundColor = [UIColor whiteColor];
    [self.skipView addSubview:self.separatorLine];
    
    self.shakeView = [[UIView alloc] init];
    self.shakeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.shakeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.shakeView.layer.cornerRadius = 40;
    self.shakeView.clipsToBounds = YES;
    [self.contentView addSubview:self.shakeView];
    
    self.shakeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_shake"]];
    self.shakeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.shakeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.shakeImageView.clipsToBounds = YES;
    self.shakeImageView.userInteractionEnabled = NO;
    [self.shakeView addSubview:self.shakeImageView];
    
    self.shakeLabel = [[UILabel alloc] init];
    self.shakeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.shakeLabel.text = @"晃一晃跳转";
    self.shakeLabel.font = [UIFont systemFontOfSize:17];
    self.shakeLabel.textColor = [UIColor secondarySystemGroupedBackgroundColor];
    [self.shakeView addSubview:self.shakeLabel];
    
    // 添加跳过点击手势
    self.skipView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipTapped)];
    [self.skipView addGestureRecognizer:tap];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        
        [self.adLogoContainerView.widthAnchor constraintEqualToConstant:43],
        [self.adLogoContainerView.heightAnchor constraintEqualToConstant:16],
        [self.adLogoContainerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-0],
        [self.adLogoContainerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16],
        
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.adLogoContainerView.leadingAnchor],
        [self.cornerImageView.trailingAnchor constraintEqualToAnchor:self.adLogoContainerView.trailingAnchor],
        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.adLogoContainerView.topAnchor],
        [self.cornerImageView.bottomAnchor constraintEqualToAnchor:self.adLogoContainerView.bottomAnchor],
        
        [self.skipView.widthAnchor constraintEqualToConstant:75],
        [self.skipView.heightAnchor constraintEqualToConstant:25],
        [self.skipView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:60],
        [self.skipView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-18],
        
        [self.countdownLabel.leadingAnchor constraintEqualToAnchor:self.skipView.leadingAnchor constant:8],
        [self.countdownLabel.centerYAnchor constraintEqualToAnchor:self.skipView.centerYAnchor],
        
        [self.separatorLine.leadingAnchor constraintEqualToAnchor:self.countdownLabel.trailingAnchor constant:8],
        [self.separatorLine.topAnchor constraintEqualToAnchor:self.skipView.topAnchor constant:8],
        [self.separatorLine.bottomAnchor constraintEqualToAnchor:self.skipView.bottomAnchor constant:-8],
        [self.separatorLine.widthAnchor constraintEqualToConstant:1],
        
        [self.skipLabel.leadingAnchor constraintEqualToAnchor:self.separatorLine.trailingAnchor constant:8],
        [self.skipLabel.centerYAnchor constraintEqualToAnchor:self.skipView.centerYAnchor],
        [self.skipLabel.trailingAnchor constraintEqualToAnchor:self.skipView.trailingAnchor constant:-8],
        
        [self.shakeView.widthAnchor constraintEqualToConstant:267],
        [self.shakeView.heightAnchor constraintEqualToConstant:80],
        [self.shakeView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.shakeView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-70],
        
        [self.shakeImageView.widthAnchor constraintEqualToConstant:24],
        [self.shakeImageView.heightAnchor constraintEqualToConstant:33],
        [self.shakeImageView.leadingAnchor constraintEqualToAnchor:self.shakeView.leadingAnchor constant:63],
        [self.shakeImageView.centerYAnchor constraintEqualToAnchor:self.shakeView.centerYAnchor],
        
        [self.shakeLabel.leadingAnchor constraintEqualToAnchor:self.shakeImageView.trailingAnchor constant:15],
        [self.shakeLabel.centerYAnchor constraintEqualToAnchor:self.shakeView.centerYAnchor],
    ]];
}

#pragma mark - 倒计时相关

- (void)startCountdownFrom:(NSInteger)seconds {
    [self stopCountdown];
    
    self.remainingSeconds = seconds;
    self.countdownLabel.text = [NSString stringWithFormat:@"%lds", (long)self.remainingSeconds];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(countdownTick)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)countdownTick {
    self.remainingSeconds--;
    if (self.remainingSeconds <= 0) {
        [self stopCountdown];
        if ([self.delegate respondsToSelector:@selector(splashViewDidSkip:)]) {
            [self.delegate splashViewDidSkip:self];
        }
    } else {
        self.countdownLabel.text = [NSString stringWithFormat:@"%lds", (long)self.remainingSeconds];
    }
}

- (void)stopCountdown {
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

- (void)skipTapped {
    [self stopCountdown];
    if ([self.delegate respondsToSelector:@selector(splashViewDidSkip:)]) {
        [self.delegate splashViewDidSkip:self];
    }
}
- (BOOL)canBecomeFirstResponder {
   return YES;
}

- (void)didMoveToWindow {
   [super didMoveToWindow];
   if (self.window) {
       [self becomeFirstResponder];
   } else {
       [self resignFirstResponder];
   }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
   if (motion == UIEventSubtypeMotionShake) {
       // 通知控制器跳转，或者自己做事
       if ([self.delegate respondsToSelector:@selector(splashViewDidShake:)]) {
           [self.delegate splashViewDidShake:self];
       }
   }
}
@end
