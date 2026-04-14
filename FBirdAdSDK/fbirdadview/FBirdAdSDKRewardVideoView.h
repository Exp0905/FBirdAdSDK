//
//  CuskyAdSDKRewardVideoView.h
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKView.h"
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface FBirdAdSDKRewardVideoView : FBirdAdSDKView
// 这样外部类可以访问它们以设置图片或文本，但不能直接重新分配这些对象。
@property (nonatomic, strong, readonly) UIView *timerContainerView;       // 计时器容器视图
@property (nonatomic, strong, readonly) UILabel *timerLabel;              // 计时器文本标签
@property (nonatomic, strong, readonly) UIImageView *timerIconImageView;  // 计时器图标视图
@property (nonatomic, strong, readonly) UIView *adTagContainerView;       // 广告标签容器视图
@property (nonatomic, strong, readonly) UILabel *adTagLabel;              // 广告标签文本
@property (nonatomic, strong, readonly) UIImageView *adTagArrowImageView; // 广告标签箭头图标
@property (nonatomic, strong, readonly) UIView *adTagSeparatorView;       // 广告标签分隔线
@property (nonatomic, strong, readonly) UIView *bottomContainerView;      // 底部容器视图
@property (nonatomic, strong, readonly) UIImageView *appIconImageView;    // 应用图标视图
@property (nonatomic, strong, readonly) UIStackView *tagStackView;        // 标签的 Stack

// 声音控制相关
@property (nonatomic, assign) BOOL isMuted; // 静音状态
@property (nonatomic, strong) AVPlayer *player;

// 声音控制方法
- (void)toggleMuteStatus;

/**
 * MARK: - 动态设置标签的方法
 *
 * 根据提供的字符串数组设置 UIStackView 中的标签。
 * 如果 tagTexts 为 nil 或空数组，将使用默认的三个标签（“多人推荐”、“马上了解”、“不要错过”）。
 *
 * @param tagTexts 包含 NSString 对象的数组，每个字符串都将成为一个标签。
 * 传入 nil 或空数组以使用默认标签。
 */
- (void)setTagsWithTexts:(nullable NSArray<NSString *> *)tagTexts;

- (void)startCountdownWithDuration:(NSInteger)duration;
@end

NS_ASSUME_NONNULL_END
