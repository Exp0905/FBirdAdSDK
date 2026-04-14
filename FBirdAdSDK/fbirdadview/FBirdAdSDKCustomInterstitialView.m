//
//  CuskyAdSDKCustomInterstitialView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKCustomInterstitialView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKCustomInterstitialView

- (instancetype)initWithFrame:(CGRect)frame {
    // 固定为屏幕大小（以iPhone 12尺寸为例）
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:screenBounds];
//    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 创建渐变层
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds; // 让渐变层大小与view一致
    
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    
    gl.colors = @[
        (__bridge id)[UIColor colorWithRed:52/255.0 green:123/255.0 blue:231/255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:29/255.0 green:117/255.0 blue:236/255.0 alpha:1].CGColor
    ];
    gl.locations = @[@(0.0), @(1.0)];
    
    // 添加渐变层到self.view的layer最底层
    [self.layer insertSublayer:gl atIndex:0];
    //    self.backgroundColor = UIColor.whiteColor;
    
    UIView *rootView = [[UIView alloc] init];
    rootView.translatesAutoresizingMaskIntoConstraints = NO;
    rootView.backgroundColor = UIColor.clearColor;
    [self addSubview:rootView];
    
    [NSLayoutConstraint activateConstraints:@[
        [rootView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [rootView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [rootView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [rootView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
    
    self.contontView = rootView;
    
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:self.mainImageV];
    
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_ad"]];
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rootView addSubview:self.cornerImageView];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:containerView];
    
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.adLogoImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:self.adLogoImageV];
    
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.font = [UIFont systemFontOfSize:17];
    self.centerNameL.textColor = UIColor.whiteColor;
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:self.centerNameL];
    
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.font = [UIFont systemFontOfSize:13];
    self.centerDetailL.textColor = UIColor.whiteColor;
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:self.centerDetailL];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.actionButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.actionButton.backgroundColor = UIColor.whiteColor;
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.actionButton.layer.cornerRadius = 25;
    [containerView addSubview:self.actionButton];
    
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_back_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rootView addSubview:self.closeImageView];
    rootView.userInteractionEnabled = YES; // 必须开启交互

    // 添加约束
    [NSLayoutConstraint activateConstraints:@[
        [self.mainImageV.topAnchor constraintEqualToAnchor:rootView.topAnchor constant:92],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor constant:15],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor constant:-15],
        [self.mainImageV.heightAnchor constraintEqualToAnchor:self.mainImageV.widthAnchor multiplier:193.0/345.0],
        // closeImageV 右上角固定
        [self.closeImageView.topAnchor constraintEqualToAnchor:rootView.topAnchor constant:40],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor constant:-40],
        [self.closeImageView.widthAnchor constraintEqualToConstant:30],
        [self.closeImageView.heightAnchor constraintEqualToConstant:30],
        
        [containerView.topAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor constant:43],
        [containerView.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor constant:15],
        [containerView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor constant:-15],
        
        [self.adLogoImageV.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [self.adLogoImageV.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:72],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:72],
        
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.adLogoImageV.bottomAnchor constant:20],
        [self.centerNameL.centerXAnchor constraintEqualToAnchor:self.adLogoImageV.centerXAnchor],
        
        [self.centerDetailL.topAnchor constraintEqualToAnchor:self.centerNameL.bottomAnchor constant:20],
        [self.centerDetailL.centerXAnchor constraintEqualToAnchor:self.centerNameL.centerXAnchor],
        
        [self.actionButton.topAnchor constraintEqualToAnchor:self.centerDetailL.bottomAnchor constant:30],
        [self.actionButton.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:18],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-18],
        [self.actionButton.heightAnchor constraintEqualToConstant:50],
        [self.actionButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-5],
        
        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.mainImageV.topAnchor],
        [self.cornerImageView.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor],
        [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
        [self.cornerImageView.heightAnchor constraintEqualToConstant:16],
        
    ]];
}

@end
