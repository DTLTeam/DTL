//
//  MainAskCommViewController.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainAskCommViewController : BaseViewController

@property (strong, nonatomic) NSString *questionID;
@property (strong, nonatomic) NSString *answerID;

typedef void(^RefreshAnswerInfoBlock)(AnswerDataModel *model);
@property (copy, nonatomic) RefreshAnswerInfoBlock refreshBlock;

@end
