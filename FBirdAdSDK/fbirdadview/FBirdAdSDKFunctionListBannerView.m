//
//  CuskyAdSDKFunctionListBannerView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKFunctionListBannerView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKFunctionListBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    // 卡片容器
    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cardView];

    // 图标
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.adLogoImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.adLogoImageV.clipsToBounds = YES;
    [self.cardView addSubview:self.adLogoImageV];

    // 标题
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerNameL.font = [UIFont systemFontOfSize:18];
    self.centerNameL.text = @"聊客";
    [self.cardView addSubview:self.centerNameL];

    // 副标题
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerDetailL.font = [UIFont systemFontOfSize:13];
    self.centerDetailL.textColor = [UIColor colorWithWhite:0.667 alpha:1.0];
    self.centerDetailL.text = @"一个人很无聊，找男人交友";
    [self.cardView addSubview:self.centerDetailL];

    // 按钮
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.actionButton setTitle:@"Button" forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor systemGreenColor];
    [self.cardView addSubview:self.actionButton];

    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_ad"]];
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.cornerImageView];
    
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.closeImageView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // cardView 距离上下左右
        [self.cardView.topAnchor constraintEqualToAnchor:self.topAnchor constant:15],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-15],
        
        // icon
        [self.adLogoImageV.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:15],
        [self.adLogoImageV.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:36],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:36],
        
        // title
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.adLogoImageV.topAnchor constant:-10],
        [self.centerNameL.leadingAnchor constraintEqualToAnchor:self.adLogoImageV.trailingAnchor constant:10],
        
        // subtitle
        [self.centerDetailL.topAnchor constraintEqualToAnchor:self.centerNameL.bottomAnchor constant:15],
        [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.centerNameL.leadingAnchor],
        
        // button
        [self.actionButton.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor],
        [self.actionButton.widthAnchor constraintEqualToConstant:65],
        [self.actionButton.heightAnchor constraintEqualToConstant:33],
        
        // logo container
        [self.cornerImageView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor],
        [self.cornerImageView.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor],
        [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
        [self.cornerImageView.heightAnchor constraintEqualToConstant:16],
        // closeImageView 右上角固定
        [self.closeImageView.topAnchor constraintEqualToAnchor:self.cardView.topAnchor],
        [self.closeImageView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor],
        [self.closeImageView.widthAnchor constraintEqualToConstant:30],
        [self.closeImageView.heightAnchor constraintEqualToConstant:30],
    ]];
}

@end
