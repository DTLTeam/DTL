//
//  AskProgressHUD.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AskProgressHUD.h"
#import "MBProgressHUD.h"

#define bgcolor [UIColor greenColor]

#define textColor [UIColor redColor]

@implementation AskProgressHUD

#pragma mark -  只有小菊花

+ (void)AskShowInView:(UIView *)view viewtag:(int)tag{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.contentColor = textColor; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色
    
    hud.tag = tag;
    
    
    
}

#pragma mark - 只有文字
+(void)AskShowOnlyTitleInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.contentColor = textColor; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = title;
    
    hud.tag = tag;
}


#pragma mark - 小菊花+文字
+ (void)AskShowTitleInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.contentColor = textColor; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色
    hud.label.text = title;
    
    hud.tag = tag;
    
}


#pragma mark - 小菊花+文字+detailsLabel
+(void)AskShowDetailsAndTitleInView:(UIView *)view Title:(NSString *)title Detail:(NSString *)detail viewtag:(int)tag {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.contentColor = textColor; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色
    
    hud.label.text = title;
    hud.detailsLabel.text = detail;
    
    hud.tag = tag; 
    
}
 


+(void)AskHideAnimatedInView:(UIView *)view viewtag:(int)tag AfterDelay:(CGFloat)afterDelay{
    MBProgressHUD *hud = [view viewWithTag:tag];
    if (hud) {
        [hud hideAnimated:YES afterDelay:afterDelay];
    }
    
}


@end
