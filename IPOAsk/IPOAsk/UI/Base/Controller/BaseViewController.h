//
//  BaseViewController.h
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDataManager.h"

@interface BaseViewController : UIViewController

- (void)back;

- (void)setUpNavBgColor:(UIColor *)color RightBtn:(void(^)(UIButton *btn))rightbtn;

- (void)showNavBar;
- (void)hiddenNavBar;

- (void)showSearchNavBar;
- (void)hiddenSearchNavBar;

- (void)RightClick;

@end
