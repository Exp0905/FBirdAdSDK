//
//  CuskyAdSDKImageTopTextBottomView.m
//  Test1
//
//  Created by zte1234 on 2025/4/19.
//
#import "FBirdAdSDKImageTopTextBottomView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKImageTopTextBottomView

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

    // topTitle
    self.topTitle = [[UILabel alloc] init];
    self.topTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.topTitle.text = @"今日推荐";
    self.topTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.topTitle.font = [UIFont systemFontOfSize:17];
    self.topTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.topTitle];

    // centerContainer (蓝色背景)
    self.centerContainer = [[UIView alloc] init];
    self.centerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerContainer.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.centerContainer];

    // centerIconImageV
    self.adLogoImageV = [[UIImageView alloc] init];
    self.adLogoImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.adLogoImageV.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.centerContainer addSubview:self.adLogoImageV];

    // centerNameL
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerNameL.text = @"小米集团";
    self.centerNameL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.centerNameL.font = [UIFont systemFontOfSize:15];
    [self.centerContainer addSubview:self.centerNameL];

    // centerDetailL
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerDetailL.text = @"小米入选世界500强感恩庆典...";
    self.centerDetailL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.centerDetailL.font = [UIFont systemFontOfSize:13];
    self.centerDetailL.numberOfLines = 1;
    self.centerDetailL.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.centerContainer addSubview:self.centerDetailL];

    // centerBtn
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.actionButton setTitle:@"查看" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:169/255.0 blue:91/255.0 alpha:1];
    [self.centerContainer addSubview:self.actionButton];

    // mainImageV
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.mainImageV];
    
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_back_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.closeImageView];
}

- (void)setupConstraints {
    UIView *cv = self.contentView;

    [NSLayoutConstraint activateConstraints:@[
        // contentView 填充 self
        [cv.topAnchor constraintEqualToAnchor:self.topAnchor],
        [cv.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [cv.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [cv.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [self.closeImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-5],
        [self.closeImageView.widthAnchor constraintEqualToConstant:20],
        [self.closeImageView.heightAnchor constraintEqualToConstant:20],
        
        // topTitle 顶部居中，距离上边15，宽高由内容撑开
        [self.topTitle.topAnchor constraintEqualToAnchor:cv.topAnchor constant:15],
        [self.topTitle.centerXAnchor constraintEqualToAnchor:cv.centerXAnchor],

        // centerContainer 顶部在 topTitle 下方 10pt，左右15pt，固定高60
        [self.centerContainer.topAnchor constraintEqualToAnchor:self.topTitle.bottomAnchor constant:10],
        [self.centerContainer.leadingAnchor constraintEqualToAnchor:cv.leadingAnchor constant:15],
        [self.centerContainer.trailingAnchor constraintEqualToAnchor:cv.trailingAnchor constant:-15],
        [self.centerContainer.heightAnchor constraintEqualToConstant:60],

        // centerIconImageV 宽高40，垂直居中，左边贴容器左边
        [self.adLogoImageV.leadingAnchor constraintEqualToAnchor:self.centerContainer.leadingAnchor],
        [self.adLogoImageV.centerYAnchor constraintEqualToAnchor:self.centerContainer.centerYAnchor],
        [self.adLogoImageV.widthAnchor constraintEqualToConstant:40],
        [self.adLogoImageV.heightAnchor constraintEqualToConstant:40],

        // centerNameL 顶部和 centerIconImageV 顶部对齐，左边距离 icon 10pt
        [self.centerNameL.topAnchor constraintEqualToAnchor:self.adLogoImageV.topAnchor],
        [self.centerNameL.leadingAnchor constraintEqualToAnchor:self.adLogoImageV.trailingAnchor constant:10],

        // centerDetailL 底部和 centerIconImageV 底部对齐，左边和 centerNameL 左对齐
        [self.centerDetailL.bottomAnchor constraintEqualToAnchor:self.adLogoImageV.bottomAnchor],
        [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.centerNameL.leadingAnchor],

        // centerBtn 宽65，高33，垂直居中，右边贴容器右边
        [self.actionButton.trailingAnchor constraintEqualToAnchor:self.centerContainer.trailingAnchor],
        [self.actionButton.centerYAnchor constraintEqualToAnchor:self.centerContainer.centerYAnchor],
        [self.actionButton.widthAnchor constraintEqualToConstant:65],
        [self.actionButton.heightAnchor constraintEqualToConstant:33],

        // centerNameL 右边 <= centerBtn 左边（防止重叠）
        [self.centerNameL.trailingAnchor constraintLessThanOrEqualToAnchor:self.actionButton.leadingAnchor constant:-10],
        [self.centerDetailL.trailingAnchor constraintLessThanOrEqualToAnchor:self.actionButton.leadingAnchor constant:-10],

        // mainImageV 顶部在 centerContainer 底部 10pt，左右与 centerContainer 对齐，底部距离 contentView 底部10pt
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.centerContainer.bottomAnchor constant:10],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.centerContainer.leadingAnchor],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.centerContainer.trailingAnchor],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:cv.bottomAnchor constant:-10],
    ]];
}
@end

