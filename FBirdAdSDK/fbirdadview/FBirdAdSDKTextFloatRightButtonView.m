//
//  CuskyAdSDKTextFloatRightButtonView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKTextFloatRightButtonView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKTextFloatRightButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {

    // 主内容图
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.mainImageV];

    // 关闭按钮图标
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_back_close"]];
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.closeImageView];

    // "广告" 标识
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_ad"]];
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.cornerImageView];

    // 下方信息容器
    self.infoContainerView = [[UIView alloc] init];
    self.infoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.infoContainerView];

    // icon
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.adLogoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.infoContainerView addSubview:self.adLogoImageV];

    // 标题
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerNameL.font = [UIFont systemFontOfSize:15];
    self.centerNameL.textColor = [UIColor whiteColor];
    self.centerNameL.text = @"小米集团";
    
    [self.infoContainerView addSubview:self.centerNameL];

    // 描述
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerDetailL.font = [UIFont systemFontOfSize:14];
    self.centerDetailL.text = @"小米入选世界500强感恩庆典...";
    self.centerDetailL.textColor = [UIColor whiteColor];
    [self.infoContainerView addSubview:self.centerDetailL];
    
    // 先创建渐变背景视图
    self.gradientBackgroundView = [[UIView alloc] init];
    self.gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gradientBackgroundView.layer.cornerRadius = 6;
    self.gradientBackgroundView.clipsToBounds = YES;
    [self.infoContainerView addSubview:self.gradientBackgroundView];
    // 创建渐变图层
       self.gradientLayer = [CAGradientLayer layer];
       self.gradientLayer.colors = @[
           (__bridge id)[UIColor colorWithRed:0x4D/255.0 green:0x50/255.0 blue:0xF6/255.0 alpha:1].CGColor,
           (__bridge id)[UIColor colorWithRed:0xE8/255.0 green:0x28/255.0 blue:0xED/255.0 alpha:1].CGColor
       ];
       self.gradientLayer.startPoint = CGPointMake(0, 0.5);
       self.gradientLayer.endPoint = CGPointMake(1, 0.5);
       self.gradientLayer.cornerRadius = self.gradientBackgroundView.layer.cornerRadius;
    self.gradientLayer.frame = CGRectMake(0, 0, 79, 33);
       [self.gradientBackgroundView.layer insertSublayer:self.gradientLayer atIndex:0];
    // 然后创建按钮
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.actionButton setTitle:@"立即查看" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.actionButton.backgroundColor = [UIColor clearColor]; // 背景透明，展示后面的渐变层
    [self.infoContainerView addSubview:self.actionButton];
  
  

    [NSLayoutConstraint activateConstraints:@[
        // 主图
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.topAnchor constant:14],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:6],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-6],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-14],

        // 关闭图标
        [self.closeImageView.topAnchor constraintEqualToAnchor:self.mainImageV.topAnchor constant:5],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor constant:-5],
        [self.closeImageView.widthAnchor constraintEqualToConstant:20],
        [self.closeImageView.heightAnchor constraintEqualToConstant:20],

        // 广告标识
        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.mainImageV.topAnchor],
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.mainImageV.leadingAnchor],
        [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
        [self.cornerImageView.heightAnchor constraintEqualToConstant:16],

        // 信息区
        [self.infoContainerView.bottomAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor],
        [self.infoContainerView.leadingAnchor constraintEqualToAnchor:self.mainImageV.leadingAnchor],
        [self.infoContainerView.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor],
        [self.infoContainerView.heightAnchor constraintEqualToConstant:60],

        // Icon
        [self.adLogoImageV.centerYAnchor constraintEqualToAnchor:self.infoContainerView.centerYAnchor],
        [self.adLogoImageV.leadingAnchor constraintEqualToAnchor:self.infoContainerView.leadingAnchor constant:5],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:40],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:40],

        // 标题
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.adLogoImageV.topAnchor],
        [self.centerNameL.leadingAnchor constraintEqualToAnchor:self.adLogoImageV.trailingAnchor constant:10],

        // 描述
        [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.centerNameL.leadingAnchor],
        [self.centerDetailL.bottomAnchor constraintEqualToAnchor:self.adLogoImageV.bottomAnchor],
        
        [self.gradientBackgroundView.centerYAnchor constraintEqualToAnchor:self.infoContainerView.centerYAnchor],
            [self.gradientBackgroundView.trailingAnchor constraintEqualToAnchor:self.infoContainerView.trailingAnchor constant:0],
            [self.gradientBackgroundView.widthAnchor constraintEqualToConstant:79],
            [self.gradientBackgroundView.heightAnchor constraintEqualToConstant:33],
        // 按钮
        [self.actionButton.centerYAnchor constraintEqualToAnchor:self.infoContainerView.centerYAnchor],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:self.infoContainerView.trailingAnchor constant:0],
        [self.actionButton.widthAnchor constraintEqualToConstant:79],
        [self.actionButton.heightAnchor constraintEqualToConstant:33],
    ]];
}


@end
