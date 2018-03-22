//
//  MainAskCommViewController.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainAskCommViewController : BaseViewController

@property (strong, nonatomic) NSString *questionTitle;
@property (strong, nonatomic) AnswerDataModel *answerMod;

#pragma mark - 更新数据
-(void)UpdateContentWithModel:(AnswerDataModel *)model;

@end
