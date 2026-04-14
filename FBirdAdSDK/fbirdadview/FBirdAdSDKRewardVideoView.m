//
//  FBirdAdSDKRewardVideoView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKRewardVideoView.h"
#import "FBirdAdSDKResourceManager.h"
#import "FBirdAdSDKPopupView.h" // 导入弹窗视图

@implementation FBirdAdSDKRewardVideoView {
    FBirdAdSDKPopupView *_popupView;
    BOOL _isPopupVisible; // 跟踪弹窗状态
    NSTimer *_countdownTimer;
    NSInteger _remainingSeconds;
}

// 使用代码创建视图时调用的初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews]; // 调用公共初始化方法
    }
    return self;
}

// MARK: - 公共初始化逻辑 (Common Initialization Logic)
- (void)startCountdownWithDuration:(NSInteger)duration {
    // 取消之前的定时器
    [_countdownTimer invalidate];
    _countdownTimer = nil;

    _remainingSeconds = duration;
    [self updateTimerLabel]; // 更新初始显示

    // 创建新的定时器
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateCountdown)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)updateCountdown {
    _remainingSeconds--;

    if (_remainingSeconds <= 0) {
        [_countdownTimer invalidate];
        _countdownTimer = nil;

        _timerLabel.text = @"可领奖励"; // 倒计时结束
        // 可选：自动触发某些奖励操作
        [self rewardUserAfterCountdown];
    } else {
        [self updateTimerLabel];
    }
}

- (void)updateTimerLabel {
    _timerLabel.text = [NSString stringWithFormat:@"%ld秒后可领奖励", (long)_remainingSeconds];
}

- (void)pauseCountdown {
    [_countdownTimer invalidate];
    _countdownTimer = nil;
}

- (void)resumeCountdown {
    if (_remainingSeconds > 0 && !_countdownTimer) {
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(updateCountdown)
                                                         userInfo:nil
                                                          repeats:YES];
    }
}

- (void)rewardUserAfterCountdown {
    //    CuskyLog(@"倒计时完成，发放奖励！");
    // TODO: 添加发放奖励或通知代理的逻辑
    if (self.userActionCallback) {
        self.userActionCallback(FBirdAdUserActionTypeOnAdReward);
    }
    [self closeTheView];
}

- (void)closeTheView {
    // 停止定时器
    [self pauseCountdown];

    if (self.userActionCallback) {
        self.userActionCallback(FBirdAdUserActionTypeClose);
    }
    // 动画淡出并移除
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.player) {
            if ([self.player respondsToSelector:@selector(pause)]) {
                [self.player pause];
            }
        }
    }];
}

// 包含所有 UI 元素的创建、配置和布局约束设置的公共方法
- (void)setupViews {
    // 设置主视图的背景颜色（可根据需要调整）
    self.backgroundColor = [UIColor blackColor];

    // --- 主图片视图 (kg3-vi-9fv) ---
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.clipsToBounds = YES; // 裁剪超出边界的内容
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit; // 内容模式为等比例缩放以适应
    self.mainImageV.userInteractionEnabled = NO; // 禁止用户交互
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO; // 关闭自动生成的约束，使用 Auto Layout
    [self addSubview:self.mainImageV]; // 将视图添加到当前视图层级

    // --- 计时器容器视图 (jfA-1y-d5B) ---
    _timerContainerView = [[UIView alloc] init];
    _timerContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3]; // 次要系统背景色
    _timerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_timerContainerView];

    // --- 计时器文本标签 (mCn-pP-7Lt) 在 timerContainerView 内部 ---
    _timerLabel = [[UILabel alloc] init];
    _timerLabel.text = @"28秒后可领金币";
    _timerLabel.font = [UIFont systemFontOfSize:13]; // 字体大小
    _timerLabel.textColor = [UIColor whiteColor];
    _timerLabel.textAlignment = NSTextAlignmentNatural; // 自然对齐
    _timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_timerContainerView addSubview:_timerLabel];

    // --- 计时器图标视图 (eKh-Ps-VDH) 在 timerContainerView 内部 ---
    _timerIconImageView = [[UIImageView alloc] init];
    _timerIconImageView.clipsToBounds = YES;
    _timerIconImageView.userInteractionEnabled = NO;
    _timerIconImageView.image = [FBirdAdSDKResourceManager imageNamed:@"fbirdadview_white_close"];
    _timerIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _timerIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_timerContainerView addSubview:_timerIconImageView];

    // --- 广告标签容器视图 (NlC-Vh-CYa) 仅包含静音按钮，位于左上角 ---
    _adTagContainerView = [[UIView alloc] init];
    _adTagContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _adTagContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_adTagContainerView];

    // --- 静音按钮图标 (原箭头图标) ---
    _adTagArrowImageView = [[UIImageView alloc] init];
    _adTagArrowImageView.image = [FBirdAdSDKResourceManager imageNamed:@"fbirdadview_volume"];
    _adTagArrowImageView.clipsToBounds = YES;
    _adTagArrowImageView.userInteractionEnabled = YES;      // 需要交互
    _adTagArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    _adTagArrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_adTagContainerView addSubview:_adTagArrowImageView];

    // --- 广告标识图片（独立放置到视频右下角）---
    _adTagImageView = [[UIImageView alloc] init];
    _adTagImageView.image = [FBirdAdSDKResourceManager imageNamed:@"fbirdadview_ad"];
    _adTagImageView.clipsToBounds = YES;
    _adTagImageView.userInteractionEnabled = NO;
    _adTagImageView.contentMode = UIViewContentModeScaleAspectFit;
    _adTagImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_adTagImageView];   // 直接添加到主视图

    // --- 底部容器视图 (RIa-P2-j9z) ---
    _bottomContainerView = [[UIView alloc] init];
    _bottomContainerView.backgroundColor = [UIColor whiteColor];
    _bottomContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_bottomContainerView];

    // --- 应用图标视图 (OEo-JS-w6B) 在 bottomContainerView 内部 ---
    _appIconImageView = [[UIImageView alloc] init];
    _appIconImageView.clipsToBounds = YES;
    _appIconImageView.userInteractionEnabled = NO;
    _appIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _appIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_bottomContainerView addSubview:_appIconImageView];

    // --- 动作按钮 (lwO-wf-lwi) 在 bottomContainerView 内部 ---
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem]; // 系统风格按钮
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.actionButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:56/255.0 blue:82/255.0 alpha:1]; //
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setTitle:@"立即试玩" forState:UIControlStateNormal]; // 默认标题
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_bottomContainerView addSubview:self.actionButton];

    // --- 应用名称标签 (i61-Jr-IIT) 在 bottomContainerView 内部 ---
    self.centerNameL = [[UILabel alloc] init];
    self.centerNameL.text = @"挪车强者";
    self.centerNameL.font = [UIFont systemFontOfSize:16];
    self.centerNameL.textColor = [UIColor blackColor];
    self.centerNameL.textAlignment = NSTextAlignmentNatural;
    self.centerNameL.translatesAutoresizingMaskIntoConstraints = NO;
    [_bottomContainerView addSubview:self.centerNameL];

    // --- 标签 Stack View (NxB-sX-g1s) 在 bottomContainerView 内部 ---
    _tagStackView = [[UIStackView alloc] init];
    _tagStackView.axis = UILayoutConstraintAxisHorizontal; // 水平方向布局
    _tagStackView.spacing = 5; // 子视图间距
    _tagStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [_bottomContainerView addSubview:_tagStackView];

    // --- 广告描述标签 (RO8-ab-Mfy) 在 bottomContainerView 内部 ---
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.text = @"谁能挪完所有车辆，我就服他！";
    self.centerDetailL.font = [UIFont systemFontOfSize:14];
    self.centerDetailL.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    [_bottomContainerView addSubview:self.centerDetailL];

    // =============== 新增弹窗组件 ===============

    // MARK: - 设置约束 (Set up Constraints)

    // 激活一组约束，使用数组方式更简洁
    [NSLayoutConstraint activateConstraints:@[
        // mainImageView 约束
        [self.mainImageV.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

        // timerContainerView 约束
        [_timerContainerView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:10],
        [_timerContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14],
        [_timerContainerView.heightAnchor constraintEqualToConstant:25],

        // timerLabel 约束 (在 timerContainerView 内部)
        [_timerLabel.centerYAnchor constraintEqualToAnchor:_timerContainerView.centerYAnchor],
        [_timerLabel.leadingAnchor constraintEqualToAnchor:_timerContainerView.leadingAnchor constant:8],

        // timerIconImageView 约束 (在 timerContainerView 内部)
        [_timerIconImageView.centerYAnchor constraintEqualToAnchor:_timerLabel.centerYAnchor],
        [_timerIconImageView.trailingAnchor constraintEqualToAnchor:_timerContainerView.trailingAnchor constant:-5],
        [_timerIconImageView.widthAnchor constraintEqualToConstant:7],
        [_timerIconImageView.heightAnchor constraintEqualToConstant:7],
        // timerLabel 和 timerIconImageView 之间的约束
        [_timerLabel.trailingAnchor constraintEqualToAnchor:_timerIconImageView.leadingAnchor constant:-5],

        // adTagContainerView 约束（左上角）
        [_adTagContainerView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:10],
        [_adTagContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:14],
        [_adTagContainerView.heightAnchor constraintEqualToConstant:25],

        // 静音按钮在容器内的约束（居中，左右留边距）
        [_adTagArrowImageView.centerYAnchor constraintEqualToAnchor:_adTagContainerView.centerYAnchor],
        [_adTagArrowImageView.leadingAnchor constraintEqualToAnchor:_adTagContainerView.leadingAnchor constant:8],
        [_adTagArrowImageView.trailingAnchor constraintEqualToAnchor:_adTagContainerView.trailingAnchor constant:-8],
        [_adTagArrowImageView.widthAnchor constraintEqualToConstant:16],
        [_adTagArrowImageView.heightAnchor constraintEqualToConstant:13],

        // 广告标识图片约束：位于 mainImageV 右下角，边距 8pt，宽高根据图片比例设定（示例 50x20）
        [_adTagImageView.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor constant:-8],
        [_adTagImageView.bottomAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor constant:-8],
        [_adTagImageView.widthAnchor constraintEqualToConstant:43],
        [_adTagImageView.heightAnchor constraintEqualToConstant:16],

        // bottomContainerView 约束
        [_bottomContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_bottomContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_bottomContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [_bottomContainerView.heightAnchor constraintEqualToConstant:200],

        // mainImageView 底部与 bottomContainerView 顶部对齐
        [self.mainImageV.bottomAnchor constraintEqualToAnchor:_bottomContainerView.topAnchor],

        // appIconImageView 约束 (在 bottomContainerView 内部)
        [_appIconImageView.centerXAnchor constraintEqualToAnchor:_bottomContainerView.centerXAnchor],
        [_appIconImageView.topAnchor constraintEqualToAnchor:_bottomContainerView.topAnchor constant:-30], 
        [_appIconImageView.widthAnchor constraintEqualToConstant:60],
        [_appIconImageView.heightAnchor constraintEqualToConstant:60],

        // appNameLabel 约束 (在 bottomContainerView 内部)
        [self.centerNameL.centerXAnchor constraintEqualToAnchor:_bottomContainerView.centerXAnchor],
        [self.centerNameL.topAnchor constraintEqualToAnchor:_appIconImageView.bottomAnchor constant:5],

        // tagStackView 约束 (在 bottomContainerView 内部)
        [_tagStackView.centerXAnchor constraintEqualToAnchor:_bottomContainerView.centerXAnchor],
        [_tagStackView.topAnchor constraintEqualToAnchor:self.centerNameL.bottomAnchor constant:5],
        [_tagStackView.heightAnchor constraintEqualToConstant:20], 

        // adDescriptionLabel 约束 (在 bottomContainerView 内部)
        [self.centerDetailL.centerXAnchor constraintEqualToAnchor:_bottomContainerView.centerXAnchor],
        [self.centerDetailL.topAnchor constraintEqualToAnchor:_tagStackView.bottomAnchor constant:5],

        // actionButton 约束 (在 bottomContainerView 内部)
        [self.actionButton.leadingAnchor constraintEqualToAnchor:_bottomContainerView.leadingAnchor constant:14],
        [self.actionButton.trailingAnchor constraintEqualToAnchor:_bottomContainerView.trailingAnchor constant:-14],
        [self.actionButton.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-15],
        [self.actionButton.heightAnchor constraintEqualToConstant:45],
        [self.actionButton.topAnchor constraintGreaterThanOrEqualToAnchor:self.centerDetailL.bottomAnchor constant:5],
    ]];

    // MARK: - 初始化时设置默认标签

    // 当视图被初始化时，调用 setTagsWithTexts: 方法并传入 nil，
    // 这将导致 Stack View 填充默认的三个标签。
    [self setTagsWithTexts:nil];

    // =============== 为关闭按钮添加点击事件 ===============
    // 确保关闭按钮已创建（如果从父类继承）
    if (!self.closeImageView) {
        self.closeImageView = [[UIImageView alloc] init];
        self.closeImageView.image = [FBirdAdSDKResourceManager imageNamed:@"fbirdadview_white_close"];
        self.closeImageView.userInteractionEnabled = YES;
        self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.closeImageView];
    }

    // 添加点击手势到倒计时容器
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handleCloseButtonTap)];
    [_timerContainerView addGestureRecognizer:closeTap];

    // =============== 为声音按钮添加点击事件 ===============
    UITapGestureRecognizer *soundTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handleSoundButtonTap)];
    [_adTagArrowImageView addGestureRecognizer:soundTap];

    // 初始化声音状态
    self.isMuted = NO;
    [self updateSoundIcon];
}

#pragma mark - 公共方法：设置标签 (Public Method: setTagsWithTexts)

- (void)setTagsWithTexts:(nullable NSArray<NSString *> *)tagTexts {
    for (UIView *subview in self.tagStackView.arrangedSubviews) {
        [self.tagStackView removeArrangedSubview:subview]; // 从 Stack View 的管理中移除
        [subview removeFromSuperview]; // 从父视图层级中移除
    }

    // 2. 确定要使用的标签文本：如果传入了数组，则使用该数组；否则使用默认数组。
    NSArray<NSString *> *textsToUse = tagTexts;
    if (!tagTexts || tagTexts.count == 0) {
        // 如果传入的 tagTexts 为 nil 或空，则使用这些默认标签
        textsToUse = @[@"多人推荐", @"马上了解", @"不要错过"];
    }

    // 3. 根据选定的文本数组添加新的标签
    for (NSString *text in textsToUse) {
        UIColor *bgColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        // 使用辅助方法创建并配置标签
        UILabel *tagLabel = [self createTagLabelWithText:text backgroundColor:bgColor];
        // 将新标签添加到 Stack View 的 arrangedSubviews 数组中
        [self.tagStackView addArrangedSubview:tagLabel];
        // Stack View 会自动处理子视图的布局。
    }
}

#pragma mark - 辅助方法：创建标签 (Helper Method: createTagLabelWithText)

// 这个私有辅助方法封装了创建和设置标签 UILabel 样式的所有逻辑，确保样式一致性。
- (UILabel *)createTagLabelWithText:(NSString *)text backgroundColor:(UIColor *)bgColor {
    UILabel *label = [[UILabel alloc] init];
    label.opaque = NO; // 不透明度
    label.userInteractionEnabled = NO; // 禁止用户交互
    label.contentMode = UIViewContentModeLeft; // 内容模式，这里通常不影响文本标签
    label.text = text; // 设置文本
    label.textAlignment = NSTextAlignmentCenter; // 文本居中对齐，标签通常这样显示
    label.lineBreakMode = NSLineBreakByTruncatingTail; // 文本过长时尾部省略
    label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // 基线调整
    label.adjustsFontSizeToFitWidth = NO; // 不自动调整字体大小以适应宽度
    label.backgroundColor = bgColor; // 背景颜色
    label.font = [UIFont systemFontOfSize:10]; // 字体大小
    label.textColor = [UIColor blackColor]; // 文本颜色
    label.translatesAutoresizingMaskIntoConstraints = NO; // **对于 Stack View 的子视图，此属性必须设置为 NO**，否则 Auto Layout 会冲突

    label.layer.cornerRadius = 4; // 示例圆角半径
    label.layer.masksToBounds = YES; // 确保圆角效果可见（裁剪超出图层的部分）

    // 如果需要标签有最小宽度以避免内容过短时显示过窄，可以添加如下约束：
    // [label.widthAnchor constraintGreaterThanOrEqualToConstant:40].active = YES;

    return label;
}

#pragma mark - 按钮点击处理
// 处理关闭按钮点击
- (void)handleCloseButtonTap {
    // 暂停倒计时
    [self pauseCountdown];

    // 创建弹窗
    _popupView = [[FBirdAdSDKPopupView alloc] initWithFrame:self.bounds];
    [_popupView startCountdownWithSeconds:_remainingSeconds];

    // 设置按钮处理
    __weak typeof(self) weakSelf = self;
    _popupView.continueHandler = ^{
        [weakSelf resumeAdPlayback];
    };

    _popupView.exitHandler = ^{
        [weakSelf closeTheView];
    };
    if (self.player) {
        if ([self.player respondsToSelector:@selector(pause)]) {
            [self.player pause];
        }
    }

    // 显示弹窗
    [_popupView showInView:self];
    _isPopupVisible = YES;
}

// 处理声音按钮点击
- (void)handleSoundButtonTap {
    [self toggleMuteStatus];
}

#pragma mark - 声音控制
// 切换静音状态
- (void)toggleMuteStatus {
    self.isMuted = !self.isMuted;
    [self updateSoundIcon];
    if (self.player) {
        self.player.muted = self.isMuted;
    }
    // 实际应用中控制广告音频
    if (self.isMuted) {
        //        CuskyLog(@"广告已静音");
    } else {
        //        CuskyLog(@"广告恢复声音");
    }
}

// 更新声音图标
- (void)updateSoundIcon {
    NSString *imageName = self.isMuted ? @"fbirdadview_muted" : @"fbirdadview_volume";
    _adTagArrowImageView.image = [FBirdAdSDKResourceManager imageNamed:imageName];
}

#pragma mark - 弹窗控制方法
- (void)resumeAdPlayback {
    // 恢复倒计时
    [self resumeCountdown];

    // 继续播放广告
    if (self.player) {
        if ([self.player respondsToSelector:@selector(play)]) {
            [self.player play];
        }
    }
}

@end
