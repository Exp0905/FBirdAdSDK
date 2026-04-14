//
//  CuskyAdSDKLargeImageNoButtonView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKLargeImageNoButtonView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKLargeImageNoButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.containerView];
    
    // main image
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageV.layer.cornerRadius = 10;
    self.mainImageV.clipsToBounds = true;
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.mainImageV];
    
    // close button image
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_back_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.containerView addSubview:self.closeImageView];
    
    // ad tag
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_ad"]];
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.containerView addSubview:self.cornerImageView];
    
    // bottom view
    self.bottomView = [[UIView alloc] init];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.bottomView];
    
    // icon
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.adLogoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.bottomView addSubview:self.adLogoImageV];
    
    // title label
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerNameL.font = [UIFont systemFontOfSize:12];
    self.centerNameL.text = @"捕鱼新纪元-超级电玩";
    [self.bottomView addSubview:self.centerNameL];
    
    // desc label
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerDetailL.font = [UIFont systemFontOfSize:10];
    self.centerDetailL.text = @"一款超好玩的街机捕鱼棋牌...";
    [self.bottomView addSubview:self.centerDetailL];
    
    [self setupConstraints];
}

- (void)setupConstraints {
  
    // containerView
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10]
    ]];

    // main image
    [NSLayoutConstraint activateConstraints:@[
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
    ]];

    // close button
    [NSLayoutConstraint activateConstraints:@[
        [self.closeImageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:5],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-5],
        [self.closeImageView.widthAnchor constraintEqualToConstant:20],
        [self.closeImageView.heightAnchor constraintEqualToConstant:20]
    ]];

    // ad tag
    [NSLayoutConstraint activateConstraints:@[
        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:5],
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:5],
        [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
        [self.cornerImageView.heightAnchor constraintEqualToConstant:16]
    ]];

    // bottom view
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.bottomView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.bottomView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
        [self.bottomView.heightAnchor constraintEqualToConstant:60]
    ]];

    // icon
    [NSLayoutConstraint activateConstraints:@[
        [self.adLogoImageV.leadingAnchor constraintEqualToAnchor:self.bottomView.leadingAnchor constant:5],
        [self.adLogoImageV.centerYAnchor constraintEqualToAnchor:self.bottomView.centerYAnchor],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:24],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:24]
    ]];

    // title
    [NSLayoutConstraint activateConstraints:@[
        [self.centerNameL.leadingAnchor constraintEqualToAnchor:self.adLogoImageV.trailingAnchor constant:5],
        [self.centerNameL.trailingAnchor constraintEqualToAnchor:self.bottomView.trailingAnchor constant:-5],
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.adLogoImageV.topAnchor constant:-8]
    ]];

    // desc
    [NSLayoutConstraint activateConstraints:@[
        [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.centerNameL.leadingAnchor],
        [self.centerDetailL.trailingAnchor constraintEqualToAnchor:self.bottomView.trailingAnchor constant:-5],
        [self.centerDetailL.bottomAnchor constraintEqualToAnchor:self.adLogoImageV.bottomAnchor]
    ]];
}


@end
