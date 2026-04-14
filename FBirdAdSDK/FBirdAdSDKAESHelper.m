//
//  CuskyAdAESHelper.m
//  CuskyAdSDK
//
//  Created by admin on 2025/7/4.
//

#import "FBirdAdSDKAESHelper.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation FBirdAdSDKAESHelper

 NSString *key = @"7a3e9f1c4b8d0e5f2a6c7b9d8e3f1a2c"; // 16字节密钥 (AES-256)
 NSString *iv = @"oZ4mK0mU6lG2fG4q";// 16字节初始向量

+ (NSString *)encrypt:(NSString *)plainText  {
    if (!plainText || !key || !iv) {
        return nil;
    }
    
    // 转换密钥和初始向量为NSData
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    // 检查密钥和初始向量长度
    if (keyData.length != kCCKeySizeAES128 &&
        keyData.length != kCCKeySizeAES192 &&
        keyData.length != kCCKeySizeAES256) {
        NSLog(@"Error: Key length must be 16, 24, or 32 bytes for AES-128/192/256");
        return nil;
    }
    
    if (ivData.length != kCCBlockSizeAES128) {
        NSLog(@"Error: IV length must be 16 bytes");
        return nil;
    }
    
    // 转换明文为NSData
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    // 计算加密后数据的最大长度
    size_t bufferSize = plainData.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) {
        return nil;
    }
    
    // 执行加密
    size_t encryptedSize = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding ,
                                     keyData.bytes,
                                     keyData.length,
                                     ivData.bytes,
                                     plainData.bytes,
                                     plainData.length,
                                     buffer,
                                     bufferSize,
                                     &encryptedSize);
    
    NSData *encryptedData = nil;
    if (status == kCCSuccess) {
        encryptedData = [NSData dataWithBytesNoCopy:buffer length:encryptedSize freeWhenDone:YES];
    } else {
        free(buffer);
        NSLog(@"Error during encryption: %d", status);
    }
    
    // 返回Base64编码的加密结果
    return encryptedData ? [encryptedData base64EncodedStringWithOptions:0] : nil;
}

+ (NSString *)decrypt:(NSString *)cipherText {
    if (!cipherText || !key || !iv) {
        return nil;
    }
    
    // 转换密钥和初始向量为NSData
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    // 检查密钥和初始向量长度
    if (keyData.length != kCCKeySizeAES128 &&
        keyData.length != kCCKeySizeAES192 &&
        keyData.length != kCCKeySizeAES256) {
        NSLog(@"Error: Key length must be 16, 24, or 32 bytes for AES-128/192/256");
        return nil;
    }
    
    if (ivData.length != kCCBlockSizeAES128) {
        NSLog(@"Error: IV length must be 16 bytes");
        return nil;
    }
    
    // 转换Base64编码的密文为NSData
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
    
    // 计算解密后数据的最大长度
    size_t bufferSize = cipherData.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) {
        return nil;
    }
    
    // 执行解密
    size_t decryptedSize = 0;
    CCCryptorStatus status = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding,
                                     keyData.bytes,
                                     keyData.length,
                                     ivData.bytes,
                                     cipherData.bytes,
                                     cipherData.length,
                                     buffer,
                                     bufferSize,
                                     &decryptedSize);
    
    NSString *decryptedString = nil;
    if (status == kCCSuccess) {
        NSData *decryptedData = [NSData dataWithBytesNoCopy:buffer length:decryptedSize freeWhenDone:YES];
        decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    } else {
        free(buffer);
        NSLog(@"Error during decryption: %d", status);
    }
    
    return decryptedString;
}

@end
