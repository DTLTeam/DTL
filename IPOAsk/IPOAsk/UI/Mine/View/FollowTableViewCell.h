//
//  FollowTableViewCell.h
//  IPOAsk
//
//  Created by lzw on 2018/1/29.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDataManager.h"

@interface FollowTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateAskCell:(AskDataModel *)model;
- (void)updateAnswerCell:(AnswerDataModel *)model;
- (void)updateFollowCell:(FollowDataModel *)model;

@end
