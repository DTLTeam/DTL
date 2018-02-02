//
//  QuestionTableViewCell.h
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

//Model
#import "QuestionModel.h"

@class QuestionTableViewCell;

@protocol QuestionTableViewCellDelegate <NSObject>

@optional
- (void)attentionWithCell:(QuestionTableViewCell *)cell;

@end

@interface QuestionTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Main:(BOOL)main;


@property (weak, nonatomic) id<QuestionTableViewCellDelegate> delegate;

/**
 刷新视图数据

 @param model 数据模型
 */
- (void)refreshWithModel:(QuestionModel *)model;

@end
