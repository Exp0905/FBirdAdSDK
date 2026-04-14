//
//  CuskyAdSDKPopupView.h
//  Test1
//
//  Created by zte1234 on 2025/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^PopupActionHandler)(void);
@interface FBirdAdSDKPopupView : UIView
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, copy, nullable) PopupActionHandler continueHandler;
@property (nonatomic, copy, nullable) PopupActionHandler exitHandler;
@property (nonatomic, assign) NSInteger remainingSeconds;
@property (nonatomic, strong) NSTimer *countdownTimer;

- (void)showInView:(UIView *)view;
- (void)startCountdownWithSeconds:(NSInteger)seconds;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
