//
//  UtilsCommon.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "UtilsCommon.h"

@implementation UtilsCommon


+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark - <识手机号>
+(NSString *)validPhoneNum:(NSString *)phone{
    //获取字符串中的电话号码
    
    NSString *regulaStr = @"\\d{3,4}[- ]?\\d{7,8}";
    
    NSRange stringRange = NSMakeRange(0, phone.length);
    //正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    
    
    __block NSString * weakst = @"";
    
    
    if (!error && regexps != nil) {
        
        [regexps enumerateMatchesInString:phone options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            NSRange phoneRange = result.range;
           
            weakst = [phone substringWithRange:phoneRange];
            
            if (![UtilsCommon validateMobile:weakst]) {
                weakst = @"";
            } 
            
        }];
        
        return weakst;
        
    }else{
        
        return weakst;
    }
    
    
    return weakst;
    
}


+ (BOOL)validateMobile:(NSString *)mobile
{
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
