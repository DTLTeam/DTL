//
//  TipsViews.h
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    controlTag_img = 100,
    controlTag_content,
    controlTag_leftbtn,
    controlTag_rightbtn,
} controlTag;

@interface TipsViews : UIView{
    
    
    UIView      *_bgView;//背景
    
    UIView      *_View;//容器
    
}

-(instancetype)initWithFrame:(CGRect)frame HaveCancel:(BOOL)have;

- (void)showWithContent:(NSString *)content
               tipsImage:(NSString *)img
              LeftTitle:(NSString *)leftTitle
              RightTitle:(NSString *)rightTitle
                  block:(void(^)(UIButton * btn))lblock
             rightblock:(void(^)(UIButton * btn))rblock;

- (void)dissmiss;

@end
