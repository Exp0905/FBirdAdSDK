//
//  CuskyAdSDKTopBottomBigButtonView.m
//  Test1
//
//  Created by zte1234 on 2025/5/19.
//

#import "FBirdAdSDKTopBottomBigButtonView.h"
#import "FBirdAdSDKResourceManager.h"
@implementation FBirdAdSDKTopBottomBigButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.mainImageV = [[UIImageView alloc] init];
    self.mainImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageV.clipsToBounds = YES;
    self.mainImageV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.mainImageV];
    
    self.centerDetailL = [[UILabel alloc] init];
    self.centerDetailL.text = @"多场景服务，为你提供更好的汽车消费和汽车 生活服务";
    self.centerDetailL.font = [UIFont systemFontOfSize:13];
    self.centerDetailL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.centerDetailL.numberOfLines = 0;
    self.centerDetailL.lineBreakMode = NSLineBreakByTruncatingTail;
    self.centerDetailL.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.centerDetailL];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.actionButton.backgroundColor = [UIColor colorWithRed:58/255.0 green:137/255.0 blue:247/255.0 alpha:1];
    [self.actionButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.actionButton.layer.cornerRadius = 5;
    self.actionButton.clipsToBounds = YES;
    [self addSubview:self.actionButton];
    
    self.cornerImageView = [[UIImageView alloc] init];
    self.cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cornerImageView.clipsToBounds = YES;
    self.cornerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.cornerImageView];
    
    self.closeImageView = [[UIImageView alloc] initWithImage:[FBirdAdSDKResourceManager imageNamed:@"fbirdadview_back_close"]];
    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.closeImageView];
    
}

- (void)setupConstraints {
    if (@available(iOS 11.0, *)) {
        UILayoutGuide *safeArea = self.safeAreaLayoutGuide;
        
        [NSLayoutConstraint activateConstraints:@[
            [self.closeImageView.topAnchor constraintEqualToAnchor:self.mainImageV.topAnchor constant:5],
            [self.closeImageView.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor constant:-5],
            [self.closeImageView.widthAnchor constraintEqualToConstant:20],
            [self.closeImageView.heightAnchor constraintEqualToConstant:20],
            // mainImageV
            [self.mainImageV.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
            [self.mainImageV.leadingAnchor constraintEqualToAnchor:self.actionButton.leadingAnchor],
            [self.mainImageV.trailingAnchor constraintEqualToAnchor:self.actionButton.trailingAnchor],
            [self.mainImageV.heightAnchor constraintEqualToConstant:157.6666667],
            
            // cornerImageView
            [self.cornerImageView.bottomAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor],
            [self.cornerImageView.trailingAnchor constraintEqualToAnchor:self.mainImageV.trailingAnchor],
            [self.cornerImageView.widthAnchor constraintEqualToConstant:43],
            [self.cornerImageView.heightAnchor constraintEqualToConstant:16],
            
            // detailLabel
            [self.centerDetailL.topAnchor constraintEqualToAnchor:self.mainImageV.bottomAnchor constant:10],
            [self.centerDetailL.leadingAnchor constraintEqualToAnchor:self.actionButton.leadingAnchor],
            [self.centerDetailL.trailingAnchor constraintEqualToAnchor:self.actionButton.trailingAnchor],
            [self.centerDetailL.heightAnchor constraintEqualToConstant:31.3333333],
            
            // actionButton
            [self.actionButton.topAnchor constraintEqualToAnchor:self.centerDetailL.bottomAnchor constant:15],
            [self.actionButton.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:10],
            [self.actionButton.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-10],
            [self.actionButton.heightAnchor constraintEqualToConstant:46],
            
            // bottom padding
            [self.bottomAnchor constraintEqualToAnchor:self.actionButton.bottomAnchor constant:10],
        ]];
    } else {
        // Fallback on earlier versions
    }
}

@end
