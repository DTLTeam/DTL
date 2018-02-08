//
//  LikeTableViewCell.h
//  IPOAsk
//
//  Created by lzw on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDataManager.h"

@interface LikeTableViewCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


- (void)updateCell:(LikeDataModel *)model;

@end
