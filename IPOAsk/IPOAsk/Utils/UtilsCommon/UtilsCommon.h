//
//  UtilsCommon.h
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilsCommon : NSObject


#pragma mark 颜色转图像
+ (UIImage *)createImageWithColor:(UIColor *)color;


#pragma mark - <识手机号> 正则匹配
+ (NSString *)validPhoneNum:(NSString *)phone;

@end
