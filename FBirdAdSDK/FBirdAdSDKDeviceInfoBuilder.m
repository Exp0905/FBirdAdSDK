//
//  CuskyAdSDKDeviceInfoBuilder.m
//

#import "FBirdAdSDKDeviceInfoBuilder.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CommonCrypto/CommonDigest.h>
#import <WebKit/WebKit.h>
//#import "CuskyAdSDKGeoHelper.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIDevice.h>
#import "FBirdAdSDKPreferencesManager.h"

@implementation FBirdAdSDKDeviceInfoBuilder

#pragma mark - 判断是否模拟器
+ (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

#pragma mark - 公共方法

+ (void)buildDeviceInfoWithGeo:(void (^)(NSDictionary *info))completion {
    if (!completion) return;
    dispatch_group_t group = dispatch_group_create();
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];

    [deviceInfo addEntriesFromDictionary:[self basicDeviceInfo]];
    [deviceInfo addEntriesFromDictionary:[self screenAndHardwareInfo]];
    [deviceInfo addEntriesFromDictionary:[self timeAndLocationInfo]];
    [deviceInfo addEntriesFromDictionary:[self unavailableFields]];

    __block NSString *carrierKey = @"unknown";
    __block NSString *uaString = @"";
    __block NSDictionary *geoInfo = @{};

    dispatch_group_enter(group);
    [self fetchCarrierNameWithCompletion:^(NSString *key) {
        carrierKey = key ?: @"unknown";
        dispatch_group_leave(group);
    }];

//    dispatch_group_enter(group);
//    [self fetchUserAgentWithCompletion:^(NSString *ua) {
//        uaString = ua ?: @"";
//        dispatch_group_leave(group);
//    }];

#if TARGET_OS_SIMULATOR
    // 模拟器，直接跳过定位逻辑，赋空数据
    geoInfo = @{};
#else
//    dispatch_group_enter(group);
//    [CuskyAdSDKGeoHelper fetchGeoInfoWithCompletion:^(NSDictionary *geoDict) {
//        if (geoDict) geoInfo = geoDict;
//        dispatch_group_leave(group);
//    }];
#endif

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSMutableDictionary *netInfo = [NSMutableDictionary dictionary];
        netInfo[@"connectiontype"] = @([self networkConnectionType]);
        netInfo[@"ip"] = @""; // 暂不支持
        netInfo[@"ua"] = uaString;
        [deviceInfo addEntriesFromDictionary:netInfo];
        deviceInfo[@"carrier"] = carrierKey;
//        deviceInfo[@"geo"] = geoInfo;

        completion([deviceInfo copy]);
    });
}

+ (NSDictionary *)buildDeviceInfoWithoutGeo {
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo addEntriesFromDictionary:[self basicDeviceInfo]];
    [deviceInfo addEntriesFromDictionary:[self networkInfo]];
    [deviceInfo addEntriesFromDictionary:[self screenAndHardwareInfo]];
    [deviceInfo addEntriesFromDictionary:[self timeAndLocationInfo]];
    [deviceInfo addEntriesFromDictionary:[self unavailableFields]];
//    deviceInfo[@"geo"] = @{};
    return [deviceInfo copy];
}

#pragma mark - 子字段模块

+ (NSDictionary *)basicDeviceInfo {
    UIDevice *device = [UIDevice currentDevice];
    NSString *ifa = @"";
    NSString *idfv = @"";
    if([[FBirdAdSDKPreferencesManager shared] isIDFAState]) {
        if (![self isSimulator]) {
            ifa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] ?: @"";
        }
    }
    if([[FBirdAdSDKPreferencesManager shared] isIDFVState]) {
        idfv = device.identifierForVendor.UUIDString ?: @"";
    }

    return @{
        @"os": @"ios",
        @"osv": device.systemVersion ?: @"",
        @"ifa": ifa,
        @"ifamd5": [self md5Hash:ifa],
        @"idfv": idfv,
//        @"openudid": ifa,
        @"make": @"Apple",
        @"model": [self deviceModel],
        @"brand": @"Apple",
        @"language": [self systemLanguage],
        @"country": [self systemCountry],
        @"hardware_model": [self hardwareModel],
        @"device_name_md5": [self md5Hash:device.name]
    };
}

+ (NSDictionary *)networkInfo {
    return @{
        @"connectiontype": @([self networkConnectionType]),
        @"ip": @"",
        @"ua": [self userAgentString]
    };
}

+ (NSDictionary *)screenAndHardwareInfo {
    UIScreen *screen = [UIScreen mainScreen];
    NSInteger ppi = [self devicePPI];
    CGFloat density = ppi / 160.0;
    return @{
        @"screenheight": @((NSInteger)screen.nativeBounds.size.height),
        @"screenwidth": @((NSInteger)screen.nativeBounds.size.width),
        @"orientation": @([self currentOrientation]),
        @"dpi": @(ppi),
        @"density": @(density),
        @"ppi": @(ppi),
        @"cpu_num": @([self cpuCount]),
//        @"disk_total": @([self diskSize]),
        @"mem_total": @([self memorySize])
    };
}

+ (NSDictionary *)timeAndLocationInfo {
    return @{
        @"local_tz_time": [[NSTimeZone localTimeZone] name],
//        @"start_time_msec": [self deviceBootTime],
//        @"update_time_nsec": [self currentSystemTime],
//        @"birth_time": [self deviceBootTime]
    };
}

+ (NSDictionary *)unavailableFields {
    return @{
        @"caid": @"",
        @"mac": @"",
        @"ipv6": @"",
        @"skadnetwork_versions": [self skAdNetworkVersions],
        @"miuiversion": @"",
        @"devicetype": @1,
        @"auth_status": @3,
        @"flashver": @"",
        @"macidmd5": @"",
        @"wifi_mac": @"",
        @"imsi": @"",
        @"ssid": @"",
//        @"boot_mark": [self bootMark] ?: @"",
//        @"update_mark": [self updateMark] ?: @"",
        @"paid": @""
    };
}

#pragma mark - 异步字段

+ (void)fetchCarrierNameWithCompletion:(void (^)(NSString *carrierKey))completion {
    if ([self isSimulator]) {
        completion(@"simulator");
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CTTelephonyNetworkInfo *netInfo = [CTTelephonyNetworkInfo new];
        CTCarrier *carrier = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000
        carrier = netInfo.serviceSubscriberCellularProviders.allValues.firstObject;
#else
        carrier = netInfo.subscriberCellularProvider;
#endif
        NSString *name = carrier.carrierName ?: @"";
        NSDictionary *map = @{
            @"mobile": @[@"中国移动", @"China Mobile", @"CMCC"],
            @"unicom": @[@"中国联通", @"China Unicom", @"CUCC"],
            @"telecom": @[@"中国电信", @"China Telecom", @"CTCC"]
        };
        __block NSString *key = @"unknown";
        [map enumerateKeysAndObjectsUsingBlock:^(NSString *k, NSArray *vals, BOOL *stop) {
            for (NSString *v in vals) {
                if ([name localizedCaseInsensitiveContainsString:v]) {
                    key = k;
                    *stop = YES;
                    break;
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(key);
        });
    });
}

+ (void)fetchUserAgentWithCompletion:(void (^)(NSString *userAgent))completion {
    static WKWebView *webView;
    static dispatch_once_t onceToken;
    
    // 确保 dispatch_once 和 WKWebView 初始化都在主线程执行
    dispatch_block_t block = ^{
        dispatch_once(&onceToken, ^{
            webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        });
        
        [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *ua = [result isKindOfClass:NSString.class] ? result : @"Mozilla/5.0";
            if (completion) {
                completion(ua);
            }
        }];
    };
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


#pragma mark - 工具方法 (使用官方API替代)

+ (NSString *)userAgentString {
    static NSString *cachedUA;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cachedUA = @"Mozilla/5.0";
    });
    return cachedUA;
}

+ (NSString *)systemLanguage {
    return [[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] uppercaseString];
}

+ (NSString *)systemCountry {
    return [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] uppercaseString] ?: @"CN";
}

+ (NSString *)hardwareModel {
    return [self deviceModel];
}

+ (NSUInteger)cpuCount {
    return [NSProcessInfo processInfo].processorCount;
}

//+ (int64_t)diskSize {
//    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
//    return [attr[NSFileSystemSize] longLongValue];
//}

+ (int64_t)memorySize {
    return [NSProcessInfo processInfo].physicalMemory;
}

+ (NSInteger)devicePPI {
    // 使用硬编码替代系统调用
    CGSize size = [UIScreen mainScreen].nativeBounds.size;
    CGFloat scale = [UIScreen mainScreen].nativeScale;
    
    // 常见设备PPI值
    if (scale == 3.0 && CGSizeEqualToSize(size, CGSizeMake(1242, 2688))) {
        return 458; // iPhone XS Max
    } else if (scale == 3.0 && CGSizeEqualToSize(size, CGSizeMake(1125, 2436))) {
        return 458; // iPhone X/XS/11 Pro
    }
    return 326; // 默认值
}

+ (NSInteger)currentOrientation {
    return UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait ? 2 : 1;
}

+ (NSString *)deviceModel {
#if TARGET_OS_SIMULATOR
    return @"iOSSimulator";
#else
    return [self deviceModelFromUname];
#endif
}

+ (NSString *)deviceModelFromUname {
//    
//    struct utsname systemInfo;
//    uname(&systemInfo);
    NSString *model = [[UIDevice currentDevice] model];
    return model ?: @"";
}



//+ (NSString *)currentSystemTime {
//    return [NSString stringWithFormat:@"%.9f", [[NSDate date] timeIntervalSince1970]];
//}

//+ (NSString *)deviceBootTime {
//    NSTimeInterval uptime = [NSProcessInfo processInfo].systemUptime;
//    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//    return [NSString stringWithFormat:@"%.9f", now - uptime];
//}

//+ (NSString *)bootMark {
//    // 使用NSProcessInfo替代系统调用
//    return [self deviceBootTime];
//}

+ (NSString *)updateMark {
//    NSURL *docURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:docURL.path error:nil];
//    NSDate *instDate = attr[NSFileCreationDate];
//    return [NSString stringWithFormat:@"%.0f", [instDate timeIntervalSince1970]];
    return @"";
}

+ (NSArray<NSString *> *)skAdNetworkVersions {
    NSOperatingSystemVersion v = [[NSProcessInfo processInfo] operatingSystemVersion];
    if (v.majorVersion >= 17) return @[@"4.0", @"3.0", @"2.2"];
    if (v.majorVersion == 16) return @[@"3.0", @"2.2"];
    return @[@"2.2"];
}

+ (NSString *)md5Hash:(NSString *)input {
    if (!input || input.length == 0) return @"";
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buf[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, buf);
    
    NSMutableString *res = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [res appendFormat:@"%02x", buf[i]];
    }
    return [res uppercaseString];
}

+(NSString *)md5WithUUIDAndTimeStampSign{
    NSString *uuidstring =[[NSUUID UUID] UUIDString];
    long long timestamp =(long long)([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *timestampString = [NSString stringWithFormat:@"%lld", timestamp];
    NSString *combinedstring = [NSString stringWithFormat:@"%@%@", uuidstring, timestampString];
 return [self md5Hash: combinedstring];
}

+ (NSInteger)networkConnectionType {
//    SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com");
//    SCNetworkReachabilityFlags flags = 0;
//    BOOL ok = SCNetworkReachabilityGetFlags(reach, &flags);
//    CFRelease(reach);
//    if (!ok || !(flags & kSCNetworkReachabilityFlagsReachable)) return 0;
//    if (flags & kSCNetworkReachabilityFlagsIsWWAN) return 1;
    return 2;
}

@end
