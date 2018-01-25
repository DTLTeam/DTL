//
//  UIBarButtonItem+myBarButtonItem.m
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "UIBarButtonItem+myBarButtonItem.h"

@implementation UIBarButtonItem (myBarButtonItem)



+(instancetype)returnTabBarItemWithBtn:(UIButton *)btn image:(NSString *)img bgimage:(UIImage *)bgimg Title:(NSString *)title SelectedTitle:(NSString *)Selectedtitle titleFont:(CGFloat)font itemtype:(Itemtype)type SystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action{
    
    CGFloat width = [self calculateSizeWithWidth:MAXFLOAT font:[UIFont systemFontOfSize:font] content:Selectedtitle];
    UIImage *image = nil;
    if (img) {
        image = [UIImage imageNamed:img];
    }
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    
    
    btn.frame = CGRectMake(0, 0, image != nil ? width * 1.5 + image.size.width : width * 4 , 44);
    if (image) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    if (bgimg) {
        [btn setImage:bgimg forState:UIControlStateSelected];
    }
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:Selectedtitle forState:UIControlStateSelected];
    [btn setTitleColor:HEX_RGB_COLOR(0x666666) forState:UIControlStateNormal];
    [btn setTitleColor:HEX_RGB_COLOR(0x666666) forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    //    btn.titleLabel.numberOfLines = 0;
    btn.tag = 4444;
    
    
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(btn.frame) + 15 < 85 &&  CGRectGetWidth(btn.frame) + 15 > 80 ? 80 : CGRectGetWidth(btn.frame) + 15, CGRectGetHeight(btn.frame))];
    [bgview addSubview:btn];
    
    
    CGRect rect = bgview.frame;
    
    CGRect btnf = btn.frame;
    btnf.size.width = rect.size.width;
    
    rect.size.width = CGRectGetWidth(btn.frame) + 15;
    
    if (type == Itemtype_left) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        btnf.origin.x += 15;
        
    }else if (type == Itemtype_rigth){
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        btnf.origin.x -= 15;
        
    }else if (type == Itemtype_center){
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    
    btn.frame = btnf;
    
    UIControl *ctl = [[UIControl alloc] initWithFrame:CGRectMake(type == Itemtype_rigth ? CGRectGetWidth(bgview.frame) * 0.2 : 0 , 0, CGRectGetWidth(bgview.frame) * 0.8, CGRectGetHeight(bgview.frame))];
    [ctl addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:ctl];
    ctl.backgroundColor = [UIColor clearColor];
    
    return [[UIBarButtonItem alloc]initWithCustomView:bgview];
}

/**
 *  计算高度
 *
 *  @param width   label width
 *  @param font    label font
 *  @param content label content
 *
 *  @return hight
 */

+(float)calculateSizeWithWidth:(float)width font:(UIFont *)font content:(NSString *)content
{
    
    CGSize maximumSize =CGSizeMake(width,9999);
    NSDictionary *textDic = @{NSFontAttributeName : font};
    CGSize contentSize = [content boundingRectWithSize:maximumSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    CGSize oneLineSize = [@"test" boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    return (contentSize.height/oneLineSize.height) * 10 + contentSize.height;
    
}

@end
