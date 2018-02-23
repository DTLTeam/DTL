//
//  InfoViewController.h
//  IPOAsk
//
//  Created by lzw on 2018/1/27.
//  Copyright © 2018年 law. All rights reserved.
//

typedef enum : NSUInteger {
    InfoCellType_Head,
    InfoCellType_Nick,
    InfoCellType_Name,
    InfoCellType_Email,
    InfoCellType_CorporateName,
    InfoCellType_introduction,
    InfoCellType_HudTag,
} InfoCellType;

#import "BaseViewController.h"

@interface InfoViewController : BaseViewController

@end
