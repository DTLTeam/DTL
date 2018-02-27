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
#import "QuestionModel.h"

@interface MainAskDetailViewController : BaseViewController


@property (nonatomic, strong) id model;

@property (nonatomic,assign)  PushType Type;

@end
