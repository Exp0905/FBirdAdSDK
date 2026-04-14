//
//  CuskyAdResourceManager.m
//  CuskyAdSDK
//
//  Created by zte1234 on 2025/6/16.
//

#import "FBirdAdSDKResourceManager.h"

@implementation FBirdAdSDKResourceManager
+ (UIImage *)imageNamed:(NSString *)imageName {
    NSLog(@"[FBirdAdSDKResourceManager] 开始加载图片：%@", imageName);
    
    // 方法1: 尝试从当前类所在的bundle中加载图片（Assets.car）
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSLog(@"[FBirdAdSDKResourceManager] current bundle path: %@", currentBundle.bundlePath);
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:currentBundle compatibleWithTraitCollection:nil];
    if (image) {
        NSLog(@"[FBirdAdSDKResourceManager] 成功从当前bundle的 Assets.car 加载图片：%@", imageName);
        return image;
    }
    
    // 方法2: 尝试从主bundle中加载图片
    NSLog(@"[FBirdAdSDKResourceManager] 尝试从主bundle加载图片");
    image = [UIImage imageNamed:imageName];
    if (image) {
        NSLog(@"[FBirdAdSDKResourceManager] 成功从主bundle加载图片：%@", imageName);
        return image;
    }
    
    // 方法3: 尝试从主bundle中的FBirdAdSDKBundle.bundle加载
    NSLog(@"[FBirdAdSDKResourceManager] 尝试从主bundle中的FBirdAdSDKBundle.bundle加载图片");
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"FBirdAdSDKBundle" ofType:@"bundle"];
    if (bundlePath) {
        NSLog(@"[FBirdAdSDKResourceManager] FBirdAdSDKBundle.bundle 路径: %@", bundlePath);
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        if (resourceBundle) {
            image = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];
            if (image) {
                NSLog(@"[FBirdAdSDKResourceManager] 成功从FBirdAdSDKBundle.bundle加载图片：%@", imageName);
                return image;
            }
        }
    }
    
    // 方法4: 尝试直接从文件系统加载图片（作为最后尝试）
    NSLog(@"[FBirdAdSDKResourceManager] 尝试从文件系统加载图片");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSArray *imageExtensions = @[@".png", @".jpg", @".jpeg"];
    for (NSString *extension in imageExtensions) {
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", imageName, extension]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                NSLog(@"[FBirdAdSDKResourceManager] 成功从文件系统加载图片：%@", imageName);
                return image;
            }
        }
    }
    
    NSLog(@"[FBirdAdSDKResourceManager] 图片未找到：%@", imageName);
    return nil;
}




@end
