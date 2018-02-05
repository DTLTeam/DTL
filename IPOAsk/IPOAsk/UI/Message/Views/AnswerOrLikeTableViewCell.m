//
//  AnswerOrLikeTableViewCell.m
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AnswerOrLikeTableViewCell.h"

@interface AnswerOrLikeTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (strong, nonatomic) IBOutlet UILabel *ContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *DateLabel;

@end


@implementation AnswerOrLikeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateWithModel:(AnswerOrLikeModel *)model{
    
    NSString *content = @"";
    if (model.AorL_Type == ContentType_Like) {
        //点赞
        content = [NSString stringWithFormat:@"%@ %@ %@ %@",model.AorL_Nick,@"称赞了",model.AorL_questionTitle,@"下你的回复"];
    }else if (model.AorL_Type == ContentType_Comm){
        //回复
        content = [NSString stringWithFormat:@"%@ %@ %@",model.AorL_Nick,@"回复了我的问题",model.AorL_questionTitle];
    }else if (model.AorL_Type == ContentType_FollowComm){
        //关注的问题回复
        content = [NSString stringWithFormat:@"%@ %@ %@",@"我关注的问题",model.AorL_questionTitle,@"有了最新的回复"];
    }
    _DateLabel.text = [NSString stringWithFormat:@"%@：%@",@"回复时间",model.AorL_AnswerDate];
    
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:content];
    NSRange range = [content rangeOfString:model.AorL_questionTitle];
    
    [str addAttribute:NSForegroundColorAttributeName value:HEX_RGB_COLOR(0x333333) range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
    
    if (model.AorL_Type == ContentType_Like || model.AorL_Type == ContentType_Comm) {
        
        range = [content rangeOfString:model.AorL_Nick];
        [str addAttribute:NSForegroundColorAttributeName value:HEX_RGB_COLOR(0x333333) range:range];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
    }
    
    _ContentLabel.attributedText = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
