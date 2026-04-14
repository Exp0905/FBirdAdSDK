//
//  CuskyAdSDKWiFiListBannerView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKWiFiListBannerView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKWiFiListBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    self.contentView = self;
    
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.text = @"抖音推广";
    self.centerNameL.font = [UIFont systemFontOfSize:15];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.centerNameL];
    
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.text = @"分享你的精彩生活";
    self.centerDetailL.font = [UIFont systemFontOfSize:12];
    self.centerDetailL.textColor = [UIColor colorWithWhite:0.666 alpha:1];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.centerDetailL];
    
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.adLogoImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.adLogoImageV];
    
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_back_close"]];
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.closeImageView];
    
    _adContainerView = [[UIView alloc] init];
    _adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_adContainerView];
    
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_ad"]];
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_adContainerView addSubview:self.cornerImageView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // closeImageView
        [self.closeImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
        [self.closeImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],
        [self.closeImageView.widthAnchor constraintEqualToConstant:20],
        [self.closeImageView.heightAnchor constraintEqualToConstant:20],
        
        // iconImageView
        [self.adLogoImageV.leadingAnchor constraintEqualToAnchor:self.closeImageView.trailingAnchor constant:12],
        [self.adLogoImageV.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:23],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:23],
        
        // titleLabel
        [self.centerNameL.leadingAnchor constraintEqualToAnchor:self.adLogoImageV.trailingAnchor constant:15],
        [self.centerNameL.centerYAnchor constraintEqualToAnchor:self.adLogoImageV.centerYAnchor],
        
        // subtitleLabel
        [self.centerDetailL.centerYAnchor constraintEqualToAnchor:self.centerNameL.centerYAnchor],
        [self.centerDetailL.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-50],
        
        // adContainerView
        [_adContainerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [_adContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_adContainerView.widthAnchor constraintEqualToConstant:43],
        [_adContainerView.heightAnchor constraintEqualToConstant:16],
        
        // adImageView inside adContainerView
        [self.cornerImageView.topAnchor constraintEqualToAnchor:_adContainerView.topAnchor],
        [self.cornerImageView.bottomAnchor constraintEqualToAnchor:_adContainerView.bottomAnchor],
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:_adContainerView.leadingAnchor],
        [self.cornerImageView.trailingAnchor constraintEqualToAnchor:_adContainerView.trailingAnchor],
    ]];
}


@end
