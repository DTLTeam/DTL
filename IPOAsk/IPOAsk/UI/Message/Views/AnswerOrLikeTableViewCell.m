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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 功能

- (void)updateWithModel:(AnswerOrLikeModel *)model {
    
    [_HeadImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    
    NSString *content = @"";
    switch (model.infoType) {
        case ContentType_Like: //点赞
        {
            content = [NSString stringWithFormat:@"%@  %@  %@  %@", model.nick, @"赞了", model.questionTitle, @"下你的回复"];
        }
            break;
        case ContentType_Comm: //回复
        {
            content = [NSString stringWithFormat:@"%@  %@  %@", model.nick, @"回复了你的问题", model.questionTitle];
        }
            break;
        case ContentType_Follow: //关注
        {
            content = [NSString stringWithFormat:@"%@  %@  %@", model.nick, @"关注了你的问题", model.questionTitle];
        }
            break;
        case ContentType_FollowComm: //关注的问题回复
        {
            content = [NSString stringWithFormat:@"%@  %@  %@", @"你关注的问题", model.questionTitle, @"有了最新的回复"];
        }
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange range = NSMakeRange(0, contentStr.length);
    [contentStr addAttribute:NSFontAttributeName value:HEX_RGBA_COLOR(0x333333, 1) range:range];
    [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    
    range = [content rangeOfString:model.questionTitle];
    [contentStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB_COLOR(0x000000) range:range];
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
    
    if ((model.infoType == ContentType_Like) || (model.infoType == ContentType_Comm)
        || (model.infoType == ContentType_Follow)) {
        
        range = [content rangeOfString:model.nick];
        [contentStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB_COLOR(0x000000) range:range];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
        
    }
    
    _ContentLabel.attributedText = contentStr;
    _DateLabel.text = [NSString stringWithFormat:@"%@: %@", @"回复时间", model.messageDate];
    
}

@end
