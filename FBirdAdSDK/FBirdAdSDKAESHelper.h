//
//  CuskyAdAES.h
//  CuskyAdSDK
//
//  Created by admin on 2025/7/4.
//
#import <Foundation/Foundation.h>

@interface FBirdAdSDKAESHelper : NSObject

/**
 AES加密（CBC模式，PKCS7Padding填充）
 
 @param plainText 明文
 @return 加密后的Base64编码字符串
 */
+ (NSString *)encrypt:(NSString *)plainText ;

/**
 AES解密（CBC模式，PKCS7Padding填充）
 
 @param cipherText 密文（Base64编码）
 @return 解密后的明文
 */
+ (NSString *)decrypt:(NSString *)cipherText ;

@end
