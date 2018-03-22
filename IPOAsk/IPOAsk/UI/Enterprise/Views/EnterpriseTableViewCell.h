//
//  EnterpriseTableViewCell.h
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterpriseTableViewCell : UITableViewCell

typedef void (^likeClick)(NSInteger index);
- (void)updateWithModel:(AskDataModel *)model likeClick:(likeClick)likeClickBlock;

@end
