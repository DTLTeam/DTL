//
//  MainAskDetailHeadViewCellTableViewCell.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/2.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainAskDetailHeadViewCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;

#pragma mark - 更新数据
-(void)UpdateContent:(AskDataModel *)model WithFollowClick:(void (^)(UIButton *))FollowClick WithAnswerClick:(void (^)(UIButton *))AnswerClick WithAllClick:(void (^)(BOOL))AllClick;
 
@end
