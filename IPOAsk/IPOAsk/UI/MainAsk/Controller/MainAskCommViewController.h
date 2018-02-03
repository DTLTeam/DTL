//
//  MainAskCommViewController.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface MainAskCommViewController : UIViewController
 

#pragma mark - 更新数据
-(void)UpdateContentWithModel:(QuestionModel *)model;

@end
