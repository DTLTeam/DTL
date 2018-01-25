//
//  UIBarButtonItem+myBarButtonItem.h
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Itemtype_left,
    Itemtype_rigth,
    Itemtype_center,
} Itemtype;

@interface UIBarButtonItem (myBarButtonItem)

+(instancetype)returnTabBarItemWithBtn:(UIButton *)btn image:(NSString *)img bgimage:(UIImage *)bgimg Title:(NSString *)title SelectedTitle:(NSString *)Selectedtitle titleFont:(CGFloat)font itemtype:(Itemtype)type  SystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;

@end
