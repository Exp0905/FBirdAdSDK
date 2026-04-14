//
//  CuskyAdSDKTopBottomRightSmallButtonView.m
//  Test1
//
//  Created by zte1234 on 2025/5/23.
//

#import "FBirdAdSDKTopBottomRightSmallButtonView.h"
#import "FBirdAdSDKResourceManager.h"

@implementation FBirdAdSDKTopBottomRightSmallButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
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

    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_back_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.closeImageView];

    self.adLogoContainer = [[UIView alloc] init];
    self.adLogoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.adLogoContainer];

    UIImageView *logo = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"cuskyadview_ad"]];
    logo.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adLogoContainer addSubview:logo];
    self.cornerImageView = logo;

    self.bottomContainer = [[UIView alloc] init];
    self.bottomContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.bottomContainer];

    self.topTitle = [[UILabel alloc] init];
    self.topTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.topTitle.text = @"今日推荐";
    self.topTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.topTitle.font = [UIFont systemFontOfSize:20];
    [self.bottomContainer addSubview:self.topTitle];

    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerDetailL.text = @"小米入选世界500强感恩庆典...";
    self.centerDetailL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.centerDetailL.numberOfLines = 0; // 允许多行
    self.centerDetailL.lineBreakMode = NSLineBreakByWordWrapping; // 按单词换行，默认也可以
    self.centerDetailL.font = [UIFont systemFontOfSize:13];
    [self.bottomContainer addSubview:self.centerDetailL];

    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.actionButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:151/255.0 blue:28/255.0 alpha:1];
    [self.bottomContainer addSubview:self.actionButton];
    
    
}

- (void)setupConstraints {
    UIView *cv = self.contentView;

    [NSLayoutConstraint activateConstraints:@[
        // contentView 全填充
        [cv.topAnchor constraintEqualToAnchor:self.topAnchor],
        [cv.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [cv.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [cv.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

        // mainImageV 顶部到底部容器顶部
        [self.mainImageV.topAnchor constraintEqualToAnchor:cv.topAnchor constant:10],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:cv.leadingAnchor constant:10],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:cv.trailingAnchor constant:-10],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:self.bottomContainer.topAnchor],

        // bottomContainer 高度 80，底部贴底
        [self.bottomContainer.leadingAnchor constraintEqualToAnchor:cv.leadingAnchor constant:10],
        [self.bottomContainer.trailingAnchor constraintEqualToAnchor:cv.trailingAnchor constant:-10],
        [self.bottomContainer.bottomAnchor constraintEqualToAnchor:cv.bottomAnchor],
        [self.bottomContainer.heightAnchor constraintEqualToConstant:80],

        // topTitle 顶部靠上
        [self.topTitle.topAnchor constraintEqualToAnchor:self.bottomContainer.topAnchor constant:10],
        [self.topTitle.leadingAnchor constraintEqualToAnchor:self.bottomContainer.leadingAnchor],

        // centerDetailL 在 topTitle 下方
        [self.centerDetailL.topAnchor constraintEqualToAnchor:self.topTitle.bottomAnchor constant:10],
        [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.topTitle.leadingAnchor],
        [self.centerDetailL.trailingAnchor constraintEqualToAnchor:self.actionButton.leadingAnchor constant:-50],
        // actionButton 右对齐居中
        [self.actionButton.centerYAnchor constraintEqualToAnchor:self.bottomContainer.centerYAnchor],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:self.bottomContainer.trailingAnchor],
        [self.actionButton.widthAnchor constraintEqualToConstant:120],
        [self.actionButton.heightAnchor constraintEqualToConstant:33],

        // closeImageV 右上角固定
        [self.closeImageView.topAnchor constraintEqualToAnchor:self.mainImageV.topAnchor],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor],
        [self.closeImageView.widthAnchor constraintEqualToConstant:30],
        [self.closeImageView.heightAnchor constraintEqualToConstant:30],

        // adLogoContainer 在 mainImageV 右下角
        [self.adLogoContainer.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor],
        [self.adLogoContainer.bottomAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor],
        [self.adLogoContainer.widthAnchor constraintEqualToConstant:43],
        [self.adLogoContainer.heightAnchor constraintEqualToConstant:16],

        // logo 填满容器
        [self.cornerImageView.topAnchor constraintEqualToAnchor:self.adLogoContainer.topAnchor],
        [self.cornerImageView.bottomAnchor constraintEqualToAnchor:self.adLogoContainer.bottomAnchor],
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.adLogoContainer.leadingAnchor],
        [self.cornerImageView.trailingAnchor constraintEqualToAnchor:self.adLogoContainer.trailingAnchor],
    ]];
}
@end
