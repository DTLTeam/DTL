//
//  EnterpriseAnswerTableViewCell.h
//  IPOAsk
//
//  Created by updrv on 2018/3/7.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterpriseAnswerTableViewCell : UITableViewCell

typedef void (^LikeBlock)(EnterpriseAnswerTableViewCell *cell);
- (void)refreshWithModel:(AnswerDataModel *)mod like:(LikeBlock)likeBlock;

@end
