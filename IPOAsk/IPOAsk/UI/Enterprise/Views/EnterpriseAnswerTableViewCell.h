//
//  EnterpriseAnswerTableViewCell.h
//  IPOAsk
//
//  Created by updrv on 2018/3/7.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

//Model
#import "AnswerModel.h"

@interface EnterpriseAnswerTableViewCell : UITableViewCell

- (void)refreshWithModel:(AnswerModel *)mod;

@end
