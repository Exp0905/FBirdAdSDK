#import "FBirdAdSDKPopupView.h"
#import "FBirdAdSDKResourceManager.h"

@implementation FBirdAdSDKPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}


- (void)updateTitleLabel {
    self.titleLabel.text = [NSString stringWithFormat:@"再看%ld秒可领奖励", (long)self.remainingSeconds];
}
- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    self.hidden = YES;
    
    // 背景视图 (半透明黑色)
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
    _backgroundView.alpha = 0.85;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_backgroundView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [_backgroundView addGestureRecognizer:tapGesture];
    _backgroundView.userInteractionEnabled = YES;
    // 内容视图 (白色背景)
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 18;
    _contentView.clipsToBounds = YES;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];
    
    // 图标视图
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_iconImageView];
    
    // 标题标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"再看32秒可领奖励";
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_titleLabel];
    
    // 继续观看按钮
    _continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _continueButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_continueButton setTitle:@"继续观看" forState:UIControlStateNormal];
    [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _continueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:56/255.0 blue:82/255.0 alpha:1];
    _continueButton.layer.cornerRadius = 24;
    [_continueButton addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_continueButton];
    
    // 坚持退出按钮
    _exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _exitButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_exitButton setTitle:@"坚持退出" forState:UIControlStateNormal];
    [_exitButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(exitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _exitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_exitButton];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // 内容视图居中
        [_contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_contentView.widthAnchor constraintEqualToConstant:246],
        [_contentView.heightAnchor constraintEqualToConstant:260],
        
        // 图标视图
        [_iconImageView.topAnchor constraintEqualToAnchor:_contentView.topAnchor constant:15],
        [_iconImageView.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor],
        [_iconImageView.widthAnchor constraintEqualToConstant:139],
        [_iconImageView.heightAnchor constraintEqualToConstant:95],
        
        // 标题标签
        [_titleLabel.topAnchor constraintEqualToAnchor:_iconImageView.bottomAnchor constant:10],
        [_titleLabel.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor],
        
        // 继续观看按钮
        [_continueButton.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:20],
        [_continueButton.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor],
        [_continueButton.widthAnchor constraintEqualToConstant:196],
        [_continueButton.heightAnchor constraintEqualToConstant:48],
        
        // 退出按钮
        [_exitButton.topAnchor constraintEqualToAnchor:_continueButton.bottomAnchor constant:2],
        [_exitButton.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor],
        [_exitButton.widthAnchor constraintEqualToAnchor:_continueButton.widthAnchor multiplier:0.92],
        [_exitButton.heightAnchor constraintEqualToAnchor:_continueButton.heightAnchor multiplier:0.73]
    ]];
    
    // 设置图标 (使用资源管理器)
    _iconImageView.image = [FBirdAdSDKResourceManager imageNamed:@"fbirdadview_coins"];
}
- (void)backgroundTapped {
    [self dismiss];
}
#pragma mark - 按钮事件处理
- (void)continueButtonTapped {
    [self dismiss];
    if (self.continueHandler) {
        self.continueHandler();
    }
}

- (void)exitButtonTapped {
    [self dismiss];
    if (self.exitHandler) {
        self.exitHandler();
    }
}

#pragma mark - 显示/隐藏方法

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    [view addSubview:self];
    
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
- (void)startCountdownWithSeconds:(NSInteger)seconds {
    self.remainingSeconds = seconds;
    [self updateTitleLabel];
    
//    [self.countdownTimer invalidate];
//    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                           target:self
//                                                         selector:@selector(countdownTick)
//                                                         userInfo:nil
//                                                          repeats:YES];
}

- (void)countdownTick {
    self.remainingSeconds--;
    [self updateTitleLabel];
    
    if (self.remainingSeconds <= 0) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        [self dismiss];
    }
}
@end
