//
//  MainAskDetailViewController.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/2.
//  Copyright © 2018年 law. All rights reserved.
//

typedef enum : NSUInteger {
    PushType_Main,
    PushType_MyAsk,
    PushType_MyAnswer,
} PushType;

#import "BaseViewController.h"

@interface MainAskDetailViewController : BaseViewController

@property (nonatomic, strong) AskDataModel *model;

typedef void(^RefreshQuestionInfoBlock)(AskDataModel *model);
@property (copy, nonatomic) RefreshQuestionInfoBlock refreshBlock;

@end
