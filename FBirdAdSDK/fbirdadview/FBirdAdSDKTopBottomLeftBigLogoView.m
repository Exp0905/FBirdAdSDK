//
//  CuskyAdSDKTopBottomLeftBigLogoView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKTopBottomLeftBigLogoView.h"

@implementation FBirdAdSDKTopBottomLeftBigLogoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    // 今日推荐 Label
    self.topTitle = [[UILabel alloc] init];
    self.topTitle.text = @"今日推荐";
    self.topTitle.font = [UIFont systemFontOfSize:17];
    self.topTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.topTitle];

    // 中间大图
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.mainImageV];

    // 底部内容 view
    UIView *bottomContainer = [[UIView alloc] init];
    bottomContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomContainer];

    // 左下角 logo 图
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV .contentMode = UIViewContentModeScaleAspectFit;
    self.adLogoImageV .translatesAutoresizingMaskIntoConstraints = NO;
    [bottomContainer addSubview:self.adLogoImageV ];

    // 企业名
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.text = @"小米集团";
    self.centerNameL.font = [UIFont systemFontOfSize:18];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomContainer addSubview:self.centerNameL];

    // 广告标题
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.text = @"小米入选世界500强感恩庆典...";
    self.centerDetailL.font = [UIFont systemFontOfSize:13];
    self.centerDetailL.textColor = [UIColor colorWithWhite:0.67 alpha:1];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomContainer addSubview:self.centerDetailL];

    // 查看按钮
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.actionButton setTitle:@"立即查看" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor colorWithRed:0.306 green:0.859 blue:0.760 alpha:1.0] forState:UIControlStateNormal];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomContainer addSubview:self.actionButton];

    // ===== 添加 Auto Layout 约束 =====

    // self.topTitle
    [NSLayoutConstraint activateConstraints:@[
        [self.topTitle.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.topTitle.topAnchor constraintEqualToAnchor:self.topAnchor constant:20]
    ]];


    // self.mainImageV
    [NSLayoutConstraint activateConstraints:@[
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.topTitle.bottomAnchor constant:15],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15],
        [self.mainImageV.widthAnchor constraintEqualToAnchor:self.mainImageV.heightAnchor multiplier:(115.0/59.0)]
    ]];

    // bottomContainer
    [NSLayoutConstraint activateConstraints:@[
        [bottomContainer.topAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor constant:20],
        [bottomContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [bottomContainer.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [bottomContainer.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];

    // self.adLogoImageV 
    [NSLayoutConstraint activateConstraints:@[
        [self.adLogoImageV .leadingAnchor constraintEqualToAnchor:bottomContainer.leadingAnchor constant:15],
        [self.adLogoImageV .centerYAnchor constraintEqualToAnchor:bottomContainer.centerYAnchor],
        [self.adLogoImageV .widthAnchor constraintEqualToConstant:80],
        [self.adLogoImageV .heightAnchor constraintEqualToConstant:107]
    ]];

    // self.centerName
    [NSLayoutConstraint activateConstraints:@[
        [self.centerNameL.leadingAnchor constraintEqualToAnchor:self.adLogoImageV .trailingAnchor constant:20],
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.adLogoImageV .topAnchor constant:20]
    ]];

    // self.centerDetailL
    [NSLayoutConstraint activateConstraints:@[
        [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.centerNameL.leadingAnchor],
        [self.centerDetailL.topAnchor constraintEqualToAnchor:self.centerNameL.bottomAnchor constant:15]
    ]];

    // self.actionButton
    [NSLayoutConstraint activateConstraints:@[
        [self.actionButton.trailingAnchor constraintEqualToAnchor:bottomContainer.trailingAnchor constant:-10],
        [self.actionButton.bottomAnchor constraintEqualToAnchor:bottomContainer.bottomAnchor constant:-10],
        [self.actionButton.widthAnchor constraintEqualToConstant:91.66],
        [self.actionButton.heightAnchor constraintEqualToConstant:34.33]
    ]];
}
@end
