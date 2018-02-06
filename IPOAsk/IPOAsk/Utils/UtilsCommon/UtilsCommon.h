//
//  UtilsCommon.h
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * phoneNum = @"15012345678";

//登录类型
typedef enum : NSUInteger {
    loginType_Person,
    loginType_Enterprise,
} loginType;

@interface UtilsCommon : NSObject


#pragma mark 颜色转图像
+ (UIImage *)createImageWithColor:(UIColor *)color;


#pragma mark document目录下的文件路径
+ (NSString *)documentFilePathWithFileName:(NSString *)fileName;
+(NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir;

#pragma mark document路径
+ (NSString *)documentPath;


#pragma mark - <识手机号> 正则匹配
+ (NSString *)validPhoneNum:(NSString *)phone;

#pragma mark - 识别邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

@end
