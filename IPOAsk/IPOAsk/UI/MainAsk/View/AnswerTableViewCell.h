//
//  AnswerTableViewCell.h
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnswerTableViewCell;

@protocol AnswerTableViewCellDelegate <NSObject>

@optional
- (void)likeWithCell:(AnswerTableViewCell *)cell;

@end

@interface AnswerTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AnswerTableViewCellDelegate> delegate;

/**
 刷新视图数据
 
 @param model 数据模型
 */
- (void)refreshWithModel:(AnswerDataModel *)model;

@end
