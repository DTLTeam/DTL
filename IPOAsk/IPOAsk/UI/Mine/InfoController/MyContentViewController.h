//
//  MyContentViewController.h
//  IPOAsk
//
//  Created by updrv on 2018/3/21.
//  Copyright © 2018年 law. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    kMyContentQuestion,
    kMyContentAnswer,
    kMyContentFollow,
    kMyContentLike
} MyContentType;

@interface MyContentViewController : BaseViewController

@property (assign, nonatomic) MyContentType vcType;

@end
