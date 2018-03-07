//
//  EnterpriseTableViewCell.h
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

//Model
#import "EnterpriseModel.h"

@interface EnterpriseTableViewCell : UITableViewCell

typedef void (^likeClick)(BOOL like, NSInteger index);
- (void)updateWithModel:(EnterpriseModel *)model likeClick:(likeClick)likeClickBlock;

- (void)likeClickSuccess;

@end
