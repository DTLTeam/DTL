//
//  AskProgressHUD.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AskProgressHUD.h"
#import "MBProgressHUD.h"

#define bgcolor HEX_RGB_COLOR(0xe3e3e3)

#define textColor [UIColor grayColor]

@implementation AskProgressHUD

#pragma mark -  只有小菊花

+ (void)AskShowInView:(UIView *)view viewtag:(int)tag{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.contentColor = textColor; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色
    
    hud.tag = tag;
    
    
    
}

#pragma mark - 只有文字
+(void)AskShowOnlyTitleInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag AfterDelay:(CGFloat)afterDelay{
    
    MBProgressHUD *defhud = [AskProgressHUD haveView:view Tag:tag];
    
    if (defhud) {
        defhud.contentColor = textColor; //文字颜色
        defhud.bezelView.backgroundColor = bgcolor;//加载框背景色
        defhud.mode = MBProgressHUDModeText;
        defhud.label.text = title;
        
        [defhud showAnimated:YES];
        [defhud hideAnimated:YES afterDelay:afterDelay];
        return;
    }
     
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.contentColor = textColor; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.tag = tag;
    
    
    [hud hideAnimated:YES afterDelay:afterDelay];
}


#pragma mark - 小菊花+文字
+ (void)AskShowTitleInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag{
    
    MBProgressHUD *defhud = [AskProgressHUD haveView:view Tag:tag];
    if (defhud) {
        defhud.contentColor = [UIColor blackColor]; //文字颜色
        defhud.bezelView.backgroundColor = bgcolor;//加载框背景色
        defhud.label.text = title;
        
        [defhud showAnimated:YES];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.contentColor = [UIColor blackColor]; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色
    hud.label.text = title;
    hud.tag = tag;
    
    //修改 MBProgressHUD 菊花颜色
    [hud.bezelView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIActivityIndicatorView class]]) {
            ((UIActivityIndicatorView *)obj).color = [UIColor redColor];
            *stop = YES;
        }
    }];
}


#pragma mark - 小菊花+文字+detailsLabel
+(void)AskShowDetailsAndTitleInView:(UIView *)view Title:(NSString *)title Detail:(NSString *)detail viewtag:(int)tag {
  
    MBProgressHUD *defhud = [AskProgressHUD haveView:view Tag:tag];
    if (defhud) {
        defhud.contentColor = textColor; //文字颜色
        defhud.bezelView.backgroundColor = bgcolor;//加载框背景色
        defhud.label.text = title;
        defhud.detailsLabel.text = detail;
        
        [defhud showAnimated:YES];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.contentColor = textColor; //文字颜色
    hud.bezelView.backgroundColor = bgcolor;//加载框背景色 
    hud.label.text = title;
    hud.detailsLabel.text = detail;
    
    hud.tag = tag;
    
}

+ (void)AskShowGifImageReloadInView:(UIView *)view Title:(NSString *)title viewtag:(int)tag
{
 
    MBProgressHUD *defhud = [AskProgressHUD haveView:view Tag:tag];
    if (defhud) {
        defhud.contentColor = textColor; //文字颜色
        defhud.bezelView.backgroundColor = bgcolor;//加载框背景色
        defhud.label.text = title;
        
        [defhud showAnimated:YES];
        return;
    }
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    UIImageView *animationImgView = [[UIImageView alloc] init];
    animationImgView.contentMode = UIViewContentModeScaleAspectFit;
    NSMutableArray *imgItems = [NSMutableArray array];
    for (NSInteger i = 0; i <= 12; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"下拉刷新_%lu.png", i]];
        [imgItems addObject:img];
    }
    animationImgView.animationImages = imgItems;
    animationImgView.animationDuration = 0.1 * imgItems.count;
    
    [animationImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [animationImgView startAnimating];
    hud.customView = animationImgView;
    hud.label.text = title;
    hud.removeFromSuperViewOnHide = YES;
    [defhud showAnimated:YES];
}


#pragma mark - 隐藏
+(void)AskHideAnimatedInView:(UIView *)view viewtag:(int)tag AfterDelay:(CGFloat)afterDelay{
    
    MBProgressHUD *hud = [view viewWithTag:tag];
    if (hud) {
        
        [hud hideAnimated:YES afterDelay:afterDelay];
        
    }else{
        
        //tag值错误手动搜索MBProgressHUD
        for(UIView * v in view.subviews){
            if ([v isKindOfClass:[MBProgressHUD class]]) {
                
                [(MBProgressHUD *)v hideAnimated:YES afterDelay:afterDelay];
                return;
            }
        }
    }
    
}

+(void)ShowTipsAlterViewWithTitle:(NSString *)title Message:(NSString *)message DefaultAction:(NSString *)Default CancelAction:(NSString *)cancel Defaulthandler:(void (^)(UIAlertAction *))defaulthandler cancelhandler:(void (^)(UIAlertAction *))handler ControllerView:(void (^)(UIAlertController *))Controller{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (Default) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:Default style:UIAlertActionStyleDefault handler:defaulthandler];
        [alertVc addAction:alertAction];
    }
    
    if (cancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:handler];
        [alertVc addAction:cancelAction];
    }
    
    Controller(alertVc);
    
}

+ (MBProgressHUD *)haveView:(UIView *)view Tag:(NSInteger)tag{
    
    for(UIView *View in view.subviews){
        if (View.tag == tag && [View isKindOfClass:[MBProgressHUD class]]) {
            
            return (MBProgressHUD*)View;
        }
    }
    
    return nil;
}

@end

