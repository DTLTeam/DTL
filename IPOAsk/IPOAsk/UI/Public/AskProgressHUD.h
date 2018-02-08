//
//  AskProgressHUD.h
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AskProgressHUD : NSObject


/**
 
 只有小菊花
 
 @param view 显示view
 @param tag 标示
 
 */
+ (void)AskShowInView:(UIView *)view viewtag:(int)tag;


/**
 只有文字
 
 @param view 显示view
 @param title 文字
 @param tag 标示
 */
+ (void)AskShowOnlyTitleInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag AfterDelay:(CGFloat)afterDelay;


/**
 小菊花+文字
 
 @param view 显示view
 @param title 文字
 @param tag 标示
 */
+ (void)AskShowTitleInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag;



/**
 小菊花+标题+描述
 
 @param view 显示view
 @param title 文字
 @param detail 描述
 @param tag 标示
 */
+ (void)AskShowDetailsAndTitleInView:(UIView *)view Title:(NSString *)title Detail:(NSString *)detail viewtag:(int)tag;


/**
 GIF加载图片+文字提示
 
 @param view 显示view
 @param title 文字 
 @param tag 标示
 */
+ (void)AskShowGifImageReloadInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag;



/**
 隐藏
 
 @param view 所在的view
 @param tag 需要隐藏的view标示
 */
+ (void)AskHideAnimatedInView:(UIView *)view viewtag:(int)tag AfterDelay:(CGFloat)afterDelay;


+ (void)ShowTipsAlterViewWithTitle:(NSString *)title Message:(NSString *)message DefaultAction:(NSString *)Default CancelAction:(NSString *)cancel
                    Defaulthandler:(void (^)(UIAlertAction *action))defaulthandler
                     cancelhandler:(void (^)(UIAlertAction *action))handler
                    ControllerView:(void (^)(UIAlertController *vc))Controller;

 


@end


