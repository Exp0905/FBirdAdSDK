//
//  CuskyAdSDKCustomInterstitial2View.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKCustomInterstitial2View.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKCustomInterstitial2View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    // 卡片背景
    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.layer.cornerRadius = 8;
    self.cardView.clipsToBounds = YES;
    [self addSubview:self.cardView];
    
    // 顶部图标
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.adLogoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.adLogoImageV];
    
    // 主图片
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.cardView addSubview:self.mainImageV];
    
    // 广告标识容器
    self.adTagContainer = [[UIView alloc] init];
    self.adTagContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.adTagContainer];
    
    // 广告标识图
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_ad"]];
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.adTagContainer addSubview:self.cornerImageView];
    
    // 标题
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerNameL.font = [UIFont systemFontOfSize:18];
    self.centerNameL.text = @"开心小农场";
    self.centerNameL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.cardView addSubview:self.centerNameL];
    
    // 副标题
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerDetailL.font = [UIFont systemFontOfSize:15];
    self.centerDetailL.text = @"玩开心小农场，登录领一元！";
    self.centerDetailL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self.cardView addSubview:self.centerDetailL];
    
    // 下载按钮
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.layer.cornerRadius = 6;
    self.actionButton.clipsToBounds = YES;
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.actionButton.backgroundColor = [UIColor clearColor]; //
    [self.actionButton setTitle:@"立即下载" forState:UIControlStateNormal];
    [self.cardView addSubview:self.actionButton];
    // 创建渐变图层
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0x4D/255.0 green:0x50/255.0 blue:0xF6/255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0xE8/255.0 green:0x28/255.0 blue:0xED/255.0 alpha:1].CGColor
    ];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.cornerRadius = self.actionButton.layer.cornerRadius;
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width - 70, 40);
    [self.actionButton.layer insertSublayer:self.gradientLayer atIndex:0];
    // 关闭按钮图片
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_back_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.cardView addSubview:self.closeImageView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // 卡片布局
        [self.cardView.topAnchor constraintEqualToAnchor:self.topAnchor constant:55],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-25],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-25],

        // 顶部图标
        [self.adLogoImageV.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.adLogoImageV.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:-30],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:60],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:60],

        // 关闭按钮
        [self.closeImageView.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:10],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-10],
        [self.closeImageView.widthAnchor constraintEqualToConstant:20],
        [self.closeImageView.heightAnchor constraintEqualToConstant:20],

        // 标题
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:45],
        [self.centerNameL.centerXAnchor constraintEqualToAnchor:self.cardView.centerXAnchor],

        // 副标题
        [self.centerDetailL.topAnchor constraintEqualToAnchor:self.centerNameL.bottomAnchor constant:15],
        [self.centerDetailL.centerXAnchor constraintEqualToAnchor:self.cardView.centerXAnchor],

        // 主图
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.centerDetailL.bottomAnchor constant:25],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:8],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-8],

        // 广告标
        [self.adTagContainer.topAnchor constraintEqualToAnchor:self.mainImageV.topAnchor constant:5],
        [self.adTagContainer.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor constant:-5],
        [self.adTagContainer.widthAnchor constraintEqualToConstant:43],
        [self.adTagContainer.heightAnchor constraintEqualToConstant:16],

        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.adTagContainer.topAnchor],
        [self.cornerImageView.bottomAnchor constraintEqualToAnchor:self.adTagContainer.bottomAnchor],
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.adTagContainer.leadingAnchor],
        [self.cornerImageView.trailingAnchor constraintEqualToAnchor:self.adTagContainer.trailingAnchor],

        // 下载按钮
        [self.actionButton.topAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor constant:25],
        [self.actionButton.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:10],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-10],
        [self.actionButton.heightAnchor constraintEqualToConstant:40],
        [self.actionButton.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-20],
    ]];
}

@end
