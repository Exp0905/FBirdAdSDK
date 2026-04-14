//
//  CuskyAdSDKCustomInterstitialView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKCustomInterstitialView.h"
#import "FBirdAdSDKResourceManager.h"
@interface FBirdAdSDKCustomInterstitialView ()
@end

@implementation FBirdAdSDKCustomInterstitialView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}



- (void)setupUI {
    // 背景遮罩
    self.backgroundColor = [UIColor clearColor];
    
    UIView *rootView = [[UIView alloc] init];
    rootView.translatesAutoresizingMaskIntoConstraints = NO;
    rootView.backgroundColor = [UIColor clearColor];
    rootView.layer.cornerRadius = 15;
    rootView.clipsToBounds = YES;
    [self addSubview:rootView];
    

    
    [NSLayoutConstraint activateConstraints:@[
        [rootView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [rootView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [rootView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.8],
        [rootView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.6],
    ]];
    
    self.contontView = rootView;
    
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageV.clipsToBounds = YES;
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:self.mainImageV];
    
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_ad"]];
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rootView addSubview:self.cornerImageView];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    containerView.layer.cornerRadius = 10;
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
    self.actionButton.layer.cornerRadius = 20;
    [containerView addSubview:self.actionButton];
    
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_back_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rootView addSubview:self.closeImageView];
    rootView.userInteractionEnabled = YES; // 必须开启交互

    // 添加约束
    [NSLayoutConstraint activateConstraints:@[
        [self.mainImageV.topAnchor constraintEqualToAnchor:rootView.topAnchor],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:rootView.bottomAnchor],
        
        // closeImageV 右上角固定
        [self.closeImageView.topAnchor constraintEqualToAnchor:rootView.topAnchor constant:10],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor constant:-10],
        [self.closeImageView.widthAnchor constraintEqualToConstant:25],
        [self.closeImageView.heightAnchor constraintEqualToConstant:25],
        
        [containerView.bottomAnchor constraintEqualToAnchor:rootView.bottomAnchor constant:-15],
        [containerView.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor constant:15],
        [containerView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor constant:-15],
        [containerView.heightAnchor constraintEqualToConstant:200],
        
        [self.adLogoImageV.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [self.adLogoImageV.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:60],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:60],
        
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.adLogoImageV.bottomAnchor constant:10],
        [self.centerNameL.centerXAnchor constraintEqualToAnchor:self.adLogoImageV.centerXAnchor],
        
        [self.centerDetailL.topAnchor constraintEqualToAnchor:self.centerNameL.bottomAnchor constant:10],
        [self.centerDetailL.centerXAnchor constraintEqualToAnchor:self.centerNameL.centerXAnchor],
        
        [self.actionButton.topAnchor constraintEqualToAnchor:self.centerDetailL.bottomAnchor constant:20],
        [self.actionButton.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:18],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-18],
        [self.actionButton.heightAnchor constraintEqualToConstant:40],
        [self.actionButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-5],
        
        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.mainImageV.topAnchor],
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.mainImageV.leadingAnchor],
        [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
        [self.cornerImageView.heightAnchor constraintEqualToConstant:16],
        
    ]];
}

@end
