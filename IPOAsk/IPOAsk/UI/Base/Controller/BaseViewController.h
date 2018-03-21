//
//  BaseViewController.h
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,strong) UIImageView *bgImageView;

- (void)back;

- (void)setUpBgViewWithTitle:(NSString *)title Image:(NSString *)Img Action:(SEL)action;
- (void)setUpNavBgColor:(UIColor *)color RightBtn:(void(^)(UIButton *btn))rightbtn;

- (void)showNavBar;
- (void)hiddenNavBar;

- (void)showSearchNavBar;
- (void)hiddenSearchNavBar;

- (void)RightClick;

@end
