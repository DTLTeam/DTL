//
//  MainNavigationController.h
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController <UITextFieldDelegate>

@property (strong, nonatomic, readonly) UITextField *searchTextField;

/**
 显示搜索导航栏
 */
- (void)showSearchNavBar:(BOOL)animated;

/**
 隐藏搜索导航栏
 */
- (void)hideSearchNavBar:(BOOL)animated;

@end
