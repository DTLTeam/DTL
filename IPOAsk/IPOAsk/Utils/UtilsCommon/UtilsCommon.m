//
//  UtilsCommon.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "UtilsCommon.h"

//Controller
#import "SignInViewController.h"

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

#pragma mark document目录下的文件路径
+ (NSString *)documentFilePathWithFileName:(NSString *)fileName
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
}
 

+(NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir
{
    return [[self getDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}

+(NSString *)getDirectoryForDocuments:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        DLog(@"create dir error: %@",error.debugDescription);
    }
    return path;
}
+(NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

#pragma mark - 计算文字高度
+(float)calculateSizeWithWidth:(float)width font:(UIFont *)font content:(NSString *)content
{
    
    CGSize maximumSize =CGSizeMake(width,9999);
    NSDictionary *textDic = @{NSFontAttributeName : font};
    CGSize contentSize = [content boundingRectWithSize:maximumSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    CGSize oneLineSize = [@"test" boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    return (contentSize.height/oneLineSize.height) * 10 + contentSize.height;
    
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

+(void)CallPhone{
    
    if (IS_IOS10LATER) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]] options:@{} completionHandler:nil];
        
    }else  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
    
}


#pragma mark - 识别邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+(BOOL)ShowLoginHud:(UIView *)view Tag:(int)tag{
    if (![UserDataManager shareInstance].userModel ) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SignInViewController *signInVC = [sb instantiateViewControllerWithIdentifier:@"SignInView"];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:signInVC animated:YES completion:nil];
        
        [AskProgressHUD AskHideAnimatedInView:view viewtag:tag AfterDelay:0];
        [AskProgressHUD AskShowOnlyTitleInView:[UIApplication sharedApplication].keyWindow Title:@"请先登录!" viewtag:tag AfterDelay:3];
        
        return YES;
    }
    
    return NO;
}

@end
