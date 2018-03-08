//
//  BaseNavigationController.h
//  IPOAsk
//
//  Created by updrv on 2018/3/8.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseNavigationControllerDelegate <NSObject>

@optional
- (void)searchTextChange:(NSString *)text;
- (void)beginSearch;

@end

@interface BaseNavigationController : UINavigationController <UITextFieldDelegate>

@property (strong, nonatomic, readonly) UITextField *searchTextField;

@property (weak, nonatomic) id<BaseNavigationControllerDelegate> searchDelegate;

/**
 显示搜索导航栏
 */
- (void)showSearchNavBar:(BOOL)animated;

/**
 隐藏搜索导航栏
 */
- (void)hideSearchNavBar:(BOOL)animated;

@end
