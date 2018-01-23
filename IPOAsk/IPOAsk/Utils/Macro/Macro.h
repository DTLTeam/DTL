//
//  Macro.h
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#endif /* Macro_h */


#pragma mark - 系统版本及设备型号
#define IS_IPHONE_X     (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
#define IS_IOS82LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2 ? YES : NO)
#define IS_IOS8LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define IS_IOS9LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)
#define IS_IOS10LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0? YES : NO)
#define IS_IOS11LATER   ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)

#pragma mark - 系统值获取
#define SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)

#define STATUSBAR_HEIGHT    (IS_IPHONE_X ? 44 : 20)
#define NAVBAR_HEIGHT       (STATUSBAR_HEIGHT + 44)
#define TABBAR_HEIGHT       44.0

#pragma mark - 颜色
#define RGB_COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//UIColorFromRGB(0x345678)
#define HEX_RGB_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEX_RGBA_COLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


#pragma mark - GCD
#define GCD_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


#pragma mark - 系统单例获取
#define USER_DEFAULT        [NSUserDefaults standardUserDefaults]
#define NOTIFICATIONCENTER  [NSNotificationCenter defaultCenter]
#define User_Helper          [UserHelper shareInstance]

#pragma mark - 判断
#define DEVICE_IS_IPAD          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define OBJECT_IS_NULL(object)         ((NSNull *)object == [NSNull null])
#define OBJECT_IS_NIL(object)          ((NSNull *)object == [NSNull null] || object == nil)
#define STRING_IS_EMPTY(object) ((NSNull *)object == [NSNull null] || object == nil || object.length == 0)
#define ARRAY_IS_EMPTY(object) ((NSNull *)object == [NSNull null] || object == nil || [object count] == 0)



#define proportionH(height)     (CGFloat)height/667 * SCREEN_HEIGHT

#define proportionW(Width)      (CGFloat)Width/375 * SCREEN_WIDTH


#pragma mark - 属性引用
#define WS(obj) __weak typeof(&*self) obj = self

#ifdef DEBUG
#define DLog(...) NSLog(@"%@\n",[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)


#endif
