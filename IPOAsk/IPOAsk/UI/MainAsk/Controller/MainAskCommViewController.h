//
//  MainAskCommViewController.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

//Model
#import "AnswerModel.h"

@interface MainAskCommViewController : UIViewController

@property (strong, nonatomic) AnswerModel *answerMod;

#pragma mark - 更新数据
-(void)UpdateContentWithModel:(AnswerModel *)model;

@end
