//
//  HeadViewTableViewCell.h
//  IPOAsk
//
//  Created by lzw on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadViewTableViewCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier action:(void(^)(NSInteger tag))block;

- (void)updateInfo:(NSString *)headUrl name:(NSString *)name phone:(NSString *)phone;
- (void)updateAskInfo:(NSInteger)askNum answer:(NSInteger)ansNum follow:(NSInteger)foNum like:(NSInteger)likeNum;


- (void)refreshViews:(loginType)type;

@end
