#import "FBirdAdSDKImageBottomButtonView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKImageBottomButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    // containerView (iSr-T4-Kix)
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 10;
    self.containerView.clipsToBounds = YES;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.containerView];

    // mainImageV (XL3-zN-fah)
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.mainImageV];

    // bottomContainerView (WXz-Da-YMP)
    self.bottomContainerView = [[UIView alloc] init];
    self.bottomContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.bottomContainerView];

    // centerDetailL (GQY-jJ-h9T)
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.text = @"我是广告我是广告我是广告我是文案我是文案我是广告我是广告我是广告我是";
    self.centerDetailL.numberOfLines = 0;
    self.centerDetailL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.centerDetailL.lineBreakMode = NSLineBreakByTruncatingTail;
    self.centerDetailL.textAlignment = NSTextAlignmentNatural;
    self.centerDetailL.font = [UIFont systemFontOfSize:15];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomContainerView addSubview:self.centerDetailL];

    // actionButton (ddn-za-9QK)
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.actionButton setTitle:@"立即查看" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:18];
    UIImage *buttonImage = [FBirdAdSDKResourceManager imageNamed:@"fbirdadview_button"];
    [self.actionButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    self.actionButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomContainerView addSubview:self.actionButton];

    // cornerImageView (ghm-Rq-hPl)
    self.cornerImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_ad"]];
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cornerImageView.clipsToBounds = YES;
    self.cornerImageView.userInteractionEnabled = NO;
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.cornerImageView];

    // closeImageView (m3d-Fi-fSv)
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_back_close"]];
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.closeImageView.clipsToBounds = YES;
    self.closeImageView.userInteractionEnabled = NO;
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.closeImageView];
}

- (void)setupConstraints {
    // containerView constraints (iSr-T4-Kix)
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:30],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-30]
    ]];

    // mainImageV constraints (XL3-zN-fah)
    [NSLayoutConstraint activateConstraints:@[
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:self.bottomContainerView.topAnchor],
    ]];

    // bottomContainerView constraints (WXz-Da-YMP)
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomContainerView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.bottomContainerView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.bottomContainerView.heightAnchor constraintEqualToConstant:130],
        [self.bottomContainerView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
    ]];

    // centerDetailL constraints (GQY-jJ-h9T)
    [NSLayoutConstraint activateConstraints:@[
        [self.centerDetailL.topAnchor constraintEqualToAnchor:self.bottomContainerView.topAnchor constant:13],
        [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.bottomContainerView.leadingAnchor constant:13],
        [self.centerDetailL.trailingAnchor constraintEqualToAnchor:self.bottomContainerView.trailingAnchor constant:-13],
        [self.centerDetailL.heightAnchor constraintEqualToConstant:36], // 可根据需要自动布局
    ]];

    // actionButton constraints (ddn-za-9QK)
    [NSLayoutConstraint activateConstraints:@[
        [self.actionButton.topAnchor constraintEqualToAnchor:self.centerDetailL.bottomAnchor constant:10],
        [self.actionButton.centerXAnchor constraintEqualToAnchor:self.bottomContainerView.centerXAnchor],
        [self.actionButton.widthAnchor constraintEqualToConstant:272],
        [self.actionButton.heightAnchor constraintEqualToConstant:81]
    ]];

    // cornerImageView constraints (ghm-Rq-hPl)
    [NSLayoutConstraint activateConstraints:@[
        [self.cornerImageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.cornerImageView.bottomAnchor constraintEqualToAnchor:self.bottomContainerView.topAnchor],
        [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
        [self.cornerImageView.heightAnchor constraintEqualToConstant:16]
    ]];

    // closeImageView constraints (m3d-Fi-fSv)
    [NSLayoutConstraint activateConstraints:@[
        [self.closeImageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:10],
        [self.closeImageView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-10],
        [self.closeImageView.widthAnchor constraintEqualToConstant:30],
        [self.closeImageView.heightAnchor constraintEqualToConstant:30]
    ]];
}
@end
