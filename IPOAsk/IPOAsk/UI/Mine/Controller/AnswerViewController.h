//
//  AnswerViewController.h
//  IPOAsk
//
//  Created by lzw on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//
typedef enum : NSUInteger {
    AnswerCellType_Name = 100,
    AnswerCellType_CorporateName,
    AnswerCellType_postName,
    AnswerCellType_introduction,
} AnswerCellType;

#import "BaseViewController.h"

@interface AnswerViewController : BaseViewController

@end
