//
//  CuskyAdSDKView.m
//  Test1
//
//  Created by TWind on 2025/4/26.
//

#import "FBirdAdSDKView.h"
#import <AVFoundation/AVFoundation.h>
// 导入所有广告样式的具体子类头文件
#import "FBirdAdSDKImageTopTextBottomView.h"      // 上文下图样式
#import "FBirdAdSDKTopBottomRightSmallButtonView.h" // 上文下文右小按钮
#import "FBirdAdSDKTopBottomBigButtonView.h"      // 上文下文底部大按钮
#import "FBirdAdSDKCustomInterstitialView.h"      // 自定义一号插屏
#import "FBirdAdSDKTopBottomLeftBigLogoView.h"    // 上图下文左侧大 Logo 样式
#import "FBirdAdSDKFunctionListBannerView.h"      // 功能列表 Banner 样式
#import "FBirdAdSDKLargeImageNoButtonView.h"      // 竖版大图封面无按钮
#import "FBirdAdSDKTextFloatRightButtonView.h"    // 文字悬浮右小按钮
#import "FBirdAdSDKCustomInterstitial2View.h"     // 自定义二号插屏
#import "FBirdAdSDKWiFiListBannerView.h"          // WiFi 列表 banner
#import "FBirdAdSDKSplashType1View.h"            // 开屏广告样式一
#import "FBirdAdSDKSplashType2View.h"            // 开屏广告样式二
#import "FBirdAdSDKRewardVideoView.h"            // 激励视频
//#import "CuskyAdSoundListBannerView.h"        // 铃声列表 banner
#import "FBirdAdSDKImageBottomButtonView.h"       // 上图下文底部图按钮
#import "FBirdAdSDKResourceManager.h"
// 引入 Objective-C Runtime 头文件
#import <objc/runtime.h>
#import "FBirdAdSDK.h"
// 设置为 1 打开日志打印，0 关闭所有 SDK 内部日志
#define CuskyAdSDK_LOG_ENABLED 1

#if CuskyAdSDK_LOG_ENABLED
    #define CuskyLog(fmt, ...) NSLog((@"[FBirdAdSDK] " fmt), ##__VA_ARGS__)
#else
    #define CuskyLog(fmt, ...)
#endif

@interface FBirdAdSDKView()<FBirdAdSplashType1ViewDelegate>
@property (nonatomic, strong) FBirdAdSDKBid * currentBid;
@property (nonatomic, assign) FBirdAdSDKAdStyle style;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL hasPlayedOnce;
@property (nonatomic, assign) NSTimeInterval playedSeconds;
@property (nonatomic, strong) id timeObserver;
@end
@implementation FBirdAdSDKView

- (instancetype)initWithFrame:(CGRect)frame adtype:(FBirdAdType)adtype {
    self = [super initWithFrame:frame];
    if (self) {
        Class adClass = nil;
        // 根据传入的广告样式枚举值，选择具体的广告视图子类
        switch (adtype) {
            case Feed:
                @try {
                    NSInteger random = arc4random_uniform((uint32_t)6);
                    CuskyLog(@"Feed_random: %li", random);
                    if(random == 0) {
                        adClass = [FBirdAdSDKImageTopTextBottomView class];
                        self.style = CuskyAdSDKAdStyleImageBottomButton;
                        break;
                    } else if(random == 1){
                        adClass = [FBirdAdSDKTopBottomRightSmallButtonView class];
                        self.style = CuskyAdSDKAdStyleTopBottomRightSmallButton;
                        break;
                    }else if(random == 2){
                        adClass = [FBirdAdSDKTopBottomLeftBigLogoView class];
                        self.style = CuskyAdSDKAdStyleTopBottomLeftBigLogo;
                        break;
                    }else if(random == 3){
                        adClass = [FBirdAdSDKLargeImageNoButtonView class];
                        self.style = CuskyAdSDKAdStyleLargeImageNoButton;
                        break;
                    }else if(random == 4){
                        adClass = [FBirdAdSDKTextFloatRightButtonView class];
                        self.style = CuskyAdSDKAdStyleTextFloatRightButton;
                        break;
                    }else if(random == 5){
                        adClass = [FBirdAdSDKImageBottomButtonView class];
                        self.style = CuskyAdSDKAdStyleImageBottomButton;
                        break;
                    }
                    
                } @catch (NSException *exception) {
                   
                } @finally {
                   
                }
            case Interstitial:
                adClass = [FBirdAdSDKCustomInterstitialView class];
                self.style = CuskyAdSDKAdStyleCustomInterstitial;
//                adClass = [FBirdAdSDKCustomInterstitial2View class];
                break;
            case Banner:
                adClass = [FBirdAdSDKFunctionListBannerView class];
                self.style = CuskyAdSDKAdStyleFunctionListBanner;
//                adClass = [FBirdAdSDKWiFiListBannerView class];
                break;
            case Splash:
                adClass = [FBirdAdSDKSplashType1View class];
                self.style = CuskyAdSDKAdStyleSplashType1;
//                adClass = [FBirdAdSDKSplashType2View class];
                break;
            case RewardVideo:
                adClass = [FBirdAdSDKRewardVideoView class];
                self.style = CuskyAdSDKAdStyleRewardVideo;
                break;
            case Draw:
            case Video:
//                adClass = [FBirdAdSDKImageBottomButtonView class];
                break;
        }
        // 使用 Runtime 获取类名并动态创建实例，确保是 CuskyAdSDKView 的子类
        if (adClass && class_getSuperclass(adClass) == [FBirdAdSDKView class]) {
            self = [[NSClassFromString(NSStringFromClass(adClass)) alloc] initWithFrame:frame];
        }
       
        [self commonInit]; // 调用通用初始化方法
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}
- (void)playerDidFinish:(NSNotification *)notification {
    CuskyLog(@"视频播放结束");
    self.hasPlayedOnce = YES;
    // 停止播放器播放
    [self.player pause];
}

- (void)playVideoWithURL:(NSString *)videoURL duration:(NSTimeInterval)duration {
    if ([self isEmpty:videoURL]) {
        CuskyLog(@"视频URL为空，无法播放");
        return;
    }
    
    if (self.hasPlayedOnce) {
        CuskyLog(@"视频已经播放过一次，不重复播放");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:videoURL];
    if (!url) {
        CuskyLog(@"视频URL格式错误");
        return;
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:item];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidFinish:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    
    if (!self.playerLayer) {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.mainImageV.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.mainImageV.layer addSublayer:self.playerLayer];
    } else {
        self.playerLayer.player = self.player;
    }
    
    self.playedSeconds = 0;
    if (self.style == CuskyAdSDKAdStyleRewardVideo){
        FBirdAdSDKRewardVideoView * vc =  (FBirdAdSDKRewardVideoView*) self;
        vc.player = self.player;
    }
    // 添加时间观察者，周期1秒，记录播放时间，达到时长停止播放
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:^(CMTime time) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        strongSelf.playedSeconds = CMTimeGetSeconds(time);
        if (strongSelf.playedSeconds >= duration) {
            [strongSelf.player pause];
            strongSelf.hasPlayedOnce = YES;
            CuskyLog(@"视频播放达到时长，自动停止");
            // 这里可以发送通知或执行其他逻辑
        }
    }];
    
    [self.player play];
}

- (void)commonInit {
    // 设置默认背景颜色为白色
   
    if (self.style == CuskyAdSDKAdStyleFunctionListBanner) {
        self.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    }else if (self.style == CuskyAdSDKAdStyleCustomInterstitial2){
        self.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }else if (self.style == CuskyAdSDKAdStyleSplashType1){
        self.backgroundColor = [UIColor whiteColor];
        FBirdAdSDKSplashType1View * vc =  (FBirdAdSDKSplashType1View*) self;
        vc.delegate = self;
        [vc startCountdownFrom:5];
    }else if (self.style == CuskyAdSDKAdStyleSplashType2){
        self.backgroundColor = [UIColor whiteColor];
        FBirdAdSDKSplashType2View * vc =  (FBirdAdSDKSplashType2View*) self;
        vc.onSwipeUpTriggered = ^{
            [self splashViewhandleSwipeUp];
        };
    }else if (self.style == CuskyAdSDKAdStyleImageBottomButton){
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:145/255.0 blue:255/255.0 alpha:1];
        
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    if (self.closeImageView) {
        
        self.closeImageView.image = [FBirdAdSDKResourceManager imageNamed:@"cuskyadview_back_close"];
        self.closeImageView.userInteractionEnabled = YES; // 必须开启交互
        // 添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAdView)];
        [self.closeImageView addGestureRecognizer:tapGesture];
    }
    if (self.actionButton) {
        [self.actionButton addTarget:self action:@selector(handleAdActionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.cornerImageView) {
        self.cornerImageView.image = [FBirdAdSDKResourceManager imageNamed:@"cuskyadview_ad"];
    }
}
- (void)configureWithBid:(FBirdAdSDKBid *)bid {
    // 确保 bid 对象及其 admobject 存在，否则无法处理
    if (!bid || !bid.admobject) {
        CuskyLog(@"[ERROR] Bid object or admobject is nil. Cannot configure.");
        return;
    }
    self.bid = bid;
    [self notifyAdDidShow:bid];
    // 初始化一个渲染模型，用于存储从 bid 中解析出的广告素材信息。
    // 实际应用中，这个渲染模型可能会是你的自定义 View Model，用于绑定到 UI 元素。
    FBirdAdSDKSynAdRenderModel *renderModel = [[FBirdAdSDKSynAdRenderModel alloc] init];

    // --- 处理原生广告内容 (assets) ---
    // 遍历广告对象中的所有资源单元 (assets)
    if (bid.admobject.native && bid.admobject.native.assets) {
        for (FBirdAdSDKNativeAsset *asset in bid.admobject.native.assets) {
            switch (asset.assetId) {
                case ASSET_ID_IMG: // 主图片素材 (如广告大图)
                    if (asset.img && ![self isEmpty:asset.img.url]) {
                        renderModel.imgUrl = asset.img.url; // 设置主图片URL
                        [self loadImageWithURLString:renderModel.imgUrl  intoImageView:self.mainImageV placeholderImage:nil];
                    }
                    break;
                case ASSET_ID_ICON: // 图标素材 (如应用图标)
                    if (asset.img && ![self isEmpty:asset.img.url]) {
                        renderModel.logoUrl = asset.img.url; // 设置Logo URL
                        [self loadImageWithURLString:renderModel.logoUrl  intoImageView:self.adLogoImageV placeholderImage:nil];
                        
//                        renderModel.iconUrl = asset.img.url; // 设置图标URL
//                        [self loadImageWithURLString:renderModel.iconUrl  intoImageView:self.adLogoImageV placeholderImage:nil];
                    }
                    break;
                case ASSET_ID_LOGO: // Logo素材 (如品牌Logo)
                    if (asset.img && ![self isEmpty:asset.img.url]) {
                        renderModel.logoUrl = asset.img.url; // 设置Logo URL
                        [self loadImageWithURLString:renderModel.logoUrl  intoImageView:self.adLogoImageV placeholderImage:nil];
                    }
                    break;
                case ASSET_ID_TITLE: // 标题素材
                    if (asset.title && ![self isEmpty:asset.title.text]) {
                        renderModel.title = asset.title.text; // 设置标题文本
                        self.topTitle.text = renderModel.title;
                    }
                    break;
                case ASSET_ID_DESC: // 描述素材
                    if (asset.data && ![self isEmpty:asset.data.value]) {
                        renderModel.desc = asset.data.value; // 设置描述文本
                        self.centerDetailL.text = renderModel.desc;
                    }
                    break;
                case ASSET_ID_SOURCE: // 来源素材 (如广告主名称)
                    if (asset.data && ![self isEmpty:asset.data.value]) {
                        renderModel.source = asset.data.value; // 设置来源文本
                        self.centerNameL.text = renderModel.source;
                    }
                    break;
                case ASSET_ID_CALL_BUTTON: // 行动按钮文本素材 (如“立即下载”、“查看详情”)
                    if (asset.data && ![self isEmpty:asset.data.value]) {
                        renderModel.callButtonText = asset.data.value; // 设置行动按钮文本
                        [self.actionButton setTitle:renderModel.callButtonText forState:UIControlStateNormal];
                    }
                    break;
                case ASSET_ID_VIDEO_ORIGIN: // 原始视频素材 (此处的视频信息通常在 admobject.video 中处理)
                case ASSET_ID_VIDEO_REWARD: // 激励视频素材 (此处的视频信息通常在 admobject.video 中处理)
                    // 视频内容统一在 admobject.video 中处理，这里不做额外处理
                    break;
                default:
                    // 忽略未知或不处理的 assetId
                    break;
            }
        }
    }

    // --- 处理视频内容 (video) ---
    if (bid.admobject.video) {
        FBirdSDKVideoContent *videoContent = bid.admobject.video;
        if (![self isEmpty:videoContent.url]) {
            FBirdAdSDKSynAdRenderVideoModel *videoModel = [[FBirdAdSDKSynAdRenderVideoModel alloc] init];
            videoModel.url = videoContent.url;      // 视频播放URL
            videoModel.cover = videoContent.cover;  // 视频封面URL
            videoModel.duration = videoContent.duration; // 视频时长
            if (self.style == CuskyAdSDKAdStyleRewardVideo){
                FBirdAdSDKRewardVideoView * vc =  (FBirdAdSDKRewardVideoView*) self;
                [vc startCountdownWithDuration:videoContent.duration];
//                [vc startCountdownFrom:5];
            }
            // 注意：AdResponseModel.h 中 CuskyAdSDKVideoContent 没有 width 和 height 属性。
            // 如果需要这些属性，它们可能来自其他的 AdObject 字段或需要在解析时通过其他方式获取。
            // 参照 PDF 中的 Java 代码，有一个 videoModel.wicth 和 videoModel.nezent，
            // 但对应的是 admobjectOTO.video.000 和 admobjectötb.video.，这看起来像是解析错误或自定义扩展。
            // 如果实际 JSON 响应中有这些字段，您需要扩展 CuskyAdSDKVideoContent 或从 admobject 根部解析。
            // 目前，根据 AdResponseModel.h 不处理宽度和高度。

            renderModel.videoModel = videoModel; // 将解析好的视频模型设置到渲染模型中

            // 如果主图片URL为空，则使用视频封面作为主图片，以确保有视觉内容展示
            if ([self isEmpty:renderModel.imgUrl] && ![self isEmpty:videoContent.cover]) {
                renderModel.imgUrl = videoContent.cover;
                [self loadImageWithURLString:renderModel.imgUrl  intoImageView:self.mainImageV placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
                // 播放视频，传入视频时长
                [self playVideoWithURL:videoContent.url duration:videoContent.duration];
            }
        }
    }

    // --- 处理 bid.action 字段 (行动按钮文本) ---
    // 根据 PDF 中图片标注：“bid里面的action 1为查看详情, 2,立即下载”
    if (![self isEmpty:bid.action]) {
        if ([bid.action isEqualToString:@"1"]) {
            renderModel.callButtonText = @"查看详情"; // 设置行动按钮文本为“查看详情”
            [self.actionButton setTitle:renderModel.callButtonText forState:UIControlStateNormal];
        } else if ([bid.action isEqualToString:@"2"]) {
            renderModel.callButtonText = @"立即下载"; // 设置行动按钮文本为“立即下载”
            [self.actionButton setTitle:renderModel.callButtonText forState:UIControlStateNormal];
        }
        // 如果 bid.action 有其他值，或者需要保持 assetId_CALL_BUTTON 设置的值，则这里需要根据业务逻辑调整优先级
    }

    // --- 处理事件跟踪URL ---
    if (bid.events) {
        renderModel.impUrls = bid.events.imp_urls;         // 曝光跟踪URL
        renderModel.clickUrls = bid.events.click_urls;     // 点击跟踪URL
        renderModel.deeplinkUrls = bid.events.deeplink_urls; // Deeplink URL
    }

    // 将 renderModel 转换为字典并打印
    CuskyLog(@"[DEBUG] Ad configured successfully with title: %@, imgUrl: %@", renderModel.title, renderModel.imgUrl);
 
}


#pragma mark - 通用广告行为方法
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:NSClassFromString(@"CuskyAdImageBottomButtonView")];

    CuskyLog(@"📦 framework 路径: %@", frameworkBundle.bundlePath);

    NSURL *resourceBundleURL = [frameworkBundle URLForResource:@"CuskyAdSDKBundle" withExtension:@"bundle"];
    CuskyLog(@"📦 资源 bundle URL: %@", resourceBundleURL);

    if (!resourceBundleURL) {
        CuskyLog(@"❌ 找不到 CuskyAdSDKBundle.bundle，检查是否拷贝到 framework 内部");
        return nil;
    }

    NSBundle *resourceBundle = [NSBundle bundleWithURL:resourceBundleURL];

    if (!resourceBundle) {
        CuskyLog(@"❌ 创建资源 bundle 失败");
        return nil;
    }

    UIImage *image = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];

    if (!image) {
        CuskyLog(@"❌ 图片加载失败: %@", imageName);
    }

    return image;
}
/// 关闭当前广告视图，从父视图中移除
- (void)closeAdView {
    CuskyLog(@"🚫 广告视图关闭");
    [self removeFromSuperview];
    // 停止播放器（如果存在）
       if (self.player) {
           if ([self.player respondsToSelector:@selector(pause)]) {
               [self.player pause];
           }
       }
}

/// 广告展示完成（可在显示动画完成后调用）
- (void)notifyAdDidShow:(FBirdAdSDKBid *)bid {
    CuskyLog(@"✅ 广告展示完成");
    // 可以通知上层代理/打点逻辑/播放动画等
    //调用展示完成
    [FBirdAdSDKManager reportClickWithAdResponse:bid view:self urlType:CuskyAdSDKAdUrlTypeImpression clickPoint:self.center completion:^(BOOL success, NSError * _Nullable error) {
        CuskyLog(@"调用展示完成-----》%ld--NSError-%@",success,error);
    }];
}
- (void)handleAdActionButtonClick:(UIButton *)sender {
    if (!self.bid) return; // bid 是广告数据
    
    CGPoint clickPoint = [sender convertPoint:CGPointMake(sender.bounds.size.width / 2, sender.bounds.size.height / 2)
                                        toView:self]; // 点击点可定为按钮中心点
    [self notifyAdDidClick:self.bid view:sender clickPoint:clickPoint];
}
/// 广告点击行为（可以在跳转或上报后调用）
- (void)notifyAdDidClick:(FBirdAdSDKBid *)bid view:(UIView*)view clickPoint:(CGPoint)clickPoint{
    CuskyLog(@"📊 广告点击已记录");
    // 可以进行点击上报、打开链接等操作
    __weak typeof(self) weakSelf = self;
    [FBirdAdSDKManager reportClickWithAdResponse:bid view:view urlType:CuskyAdSDKAdUrlTypeClick clickPoint:clickPoint completion:^(BOOL success, NSError * _Nullable error) {
        CuskyLog(@"调用广告点击行为-----》%ld--NSError-%@",success,error);
        [weakSelf notifyAdDidDeepLink:bid view:view clickPoint:clickPoint];
    }];
}
- (void)notifyAdDidDeepLink:(FBirdAdSDKBid *)bid view:(UIView *)view clickPoint:(CGPoint)clickPoint {
    if (!bid || (!bid.deeplink && !bid.target)) return;

    // 1. 生成 deeplink 和 fallback target 链接
    NSString *deeplinkStr = bid.deeplink;
    NSString *targetStr = bid.target;
    
    NSURL *deeplinkURL = [NSURL URLWithString:deeplinkStr];
    UIApplication *app = [UIApplication sharedApplication];

    // 2. 优先尝试打开 deeplink
    if (deeplinkURL && [app canOpenURL:deeplinkURL]) {
        [app openURL:deeplinkURL options:@{} completionHandler:^(BOOL success) {
            CuskyLog(@"打开 deeplink %@，结果：%d", deeplinkStr, success);
        }];
        
    }else{
        NSLog(@"deeplink 打开失败");
    }
    // 4. 上报点击行为（无论成功与否都要上报）
    [FBirdAdSDKManager reportClickWithAdResponse:bid
                                            view:view
                                         urlType:CuskyAdSDKAdUrlTypeDeepLink
                                      clickPoint:clickPoint
                                       completion:^(BOOL success, NSError * _Nullable error) {
        CuskyLog(@"调用打开链接行为上报 -----》%ld--NSError-%@", (long)success, error);
    }];
   
}

#pragma mark - FBirdAdSplashType1ViewDelegate
- (void)splashViewhandleSwipeUp {
    CuskyLog(@"检测到向上滑动");
    [self notifyAdDidClick:self.bid view:self clickPoint:self.center];
}
- (void)splashViewDidSkip:(UIView *)splashView {
    CuskyLog(@"用户跳过启动广告");
    // 这里做关闭广告页操作，比如dismiss或pop
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)splashViewDidShake:(UIView *)splashView {
    CuskyLog(@"用户晃动设备，跳转广告页面");
    [self notifyAdDidClick:self.bid view:self clickPoint:self.center];
    // 这里处理晃动跳转逻辑
    // 例如打开广告链接，或跳转到其他页面
}
- (BOOL)isEmpty:(nullable NSString *)string {
    // A string is considered "empty" if it's nil, has zero length, or contains only whitespace.
    return string == nil || string.length == 0 || [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}
/**
 * @brief 异步下载网络图片并设置到 UIImageView，支持占位图
 * @param urlString 图片 URL 字符串
 * @param imageView 需要设置图片的 UIImageView
 * @param placeholder 占位图，url无效或下载失败时显示
 */
- (void)loadImageWithURLString:(NSString *)urlString
                 intoImageView:(UIImageView *)imageView
              placeholderImage:(UIImage *)placeholder {
    if ([self isEmpty:urlString]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = placeholder;
        });
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = placeholder;
        });
        return;
    }
    
    // 先显示占位图
    dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image = placeholder;
    });
    
    // 异步下载图片数据
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data) {
            CuskyLog(@"[ERROR] 图片下载失败: %@, url: %@", error.localizedDescription, urlString);
            return;
        }
        
        UIImage *downloadedImage = [UIImage imageWithData:data];
        if (downloadedImage) {
            // 回到主线程更新 UI
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = downloadedImage;
            });
        } else {
            CuskyLog(@"[ERROR] 图片数据转换失败，url: %@", urlString);
        }
    }];
    [task resume];
}
@end

// CuskyADSDKSynAdRenderVideoModel.m
@implementation FBirdAdSDKSynAdRenderVideoModel

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.url) {
        dict[@"url"] = self.url;
    }
    if (self.cover) {
        dict[@"cover"] = self.cover;
    }
    dict[@"duration"] = @(self.duration);
    dict[@"width"] = @(self.width);
    dict[@"height"] = @(self.height);
    return [dict copy];
}

@end


// CuskyADSDKSynAdRenderModel.m
@implementation FBirdAdSDKSynAdRenderModel

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (self.imgUrl) {
        dict[@"imgUrl"] = self.imgUrl;
    }
    if (self.iconUrl) {
        dict[@"iconUrl"] = self.iconUrl;
    }
    if (self.logoUrl) {
        dict[@"logoUrl"] = self.logoUrl;
    }
    if (self.title) {
        dict[@"title"] = self.title;
    }
    if (self.desc) {
        dict[@"desc"] = self.desc;
    }
    if (self.source) {
        dict[@"source"] = self.source;
    }
    if (self.callButtonText) {
        dict[@"callButtonText"] = self.callButtonText;
    }
    if (self.videoModel) {
        dict[@"videoModel"] = [self.videoModel toDictionary]; // Recursively convert videoModel
    }
    if (self.impUrls) {
        dict[@"impUrls"] = self.impUrls;
    }
    if (self.clickUrls) {
        dict[@"clickUrls"] = self.clickUrls;
    }
    if (self.deeplinkUrls) {
        dict[@"deeplinkUrls"] = self.deeplinkUrls;
    }

    return [dict copy];
}


@end
