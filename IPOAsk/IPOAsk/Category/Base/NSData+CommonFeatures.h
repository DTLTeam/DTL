//
//  NSData+CommonFeatures.h
//

#import <Foundation/Foundation.h>

@interface NSData (CommonFeatures)

//AES128加密函数
- (NSData *)AES128EncryptWithKey:(NSString *)key;
//AES128解密函数
- (NSData *)AES128DecryptWithKey:(NSString *)key;

//MD5加密
- (NSString *)md5Data;

@end
