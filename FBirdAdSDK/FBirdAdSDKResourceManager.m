//
//  CuskyAdResourceManager.m
//  CuskyAdSDK
//
//  Created by zte1234 on 2025/6/16.
//

#import "FBirdAdSDKResourceManager.h"

@implementation FBirdAdSDKResourceManager
+ (UIImage *)imageNamed:(NSString *)imageName {
//    NSLog(@"[CuskyAdResourceManager] 开始加载图片：%@", imageName);
    
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"CuskyAdSDKBundle" withExtension:@"bundle"];
//    NSLog(@"[CuskyAdResourceManager] CuskyAdSDKBundle 路径: %@", bundleURL);
    
    if (!bundleURL) {
//        NSLog(@"❌ 找不到 CuskyAdSDKBundle.bundle，请确认已添加到主 App 的 Copy Bundle Resources");
        return nil;
    }

    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    if (!resourceBundle) {
//        NSLog(@"❌ 加载 CuskyAdSDKBundle.bundle 失败");
        return nil;
    }

    UIImage *image = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];
    if (!image) {
//        NSLog(@"❌ 图片加载失败: %@", imageName);
    }
    return image;
}




@end
