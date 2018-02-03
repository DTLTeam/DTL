//
//  EnterpriseTableViewCell.m
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseTableViewCell.h"


@interface EnterpriseTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *Head;
@property (strong, nonatomic) IBOutlet UILabel *QuestionLabel;
@property (strong, nonatomic) IBOutlet UILabel *Nick;
@property (strong, nonatomic) IBOutlet UILabel *AnswerDate;
@property (strong, nonatomic) IBOutlet UIButton *LikeBtn;
@property (strong, nonatomic) IBOutlet UILabel *AnswerLabel;


@property (nonatomic,strong)void (^(likeClick))(BOOL like);

@end



@implementation EnterpriseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateWithModel:(EnterpriseModel *)model WithLikeClick:(void (^)(BOOL))LikeClick{
    
    _likeClick = LikeClick;
    
    
    _QuestionLabel.text = model.Exper_questionTitle;
    
    _Nick.text = model.Exper_expertNick;
    
    _AnswerDate.text = model.Exper_recoveryDate;
     
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"专家答案: %@",model.Exper_AnswerContent]];
    [aString addAttribute:NSForegroundColorAttributeName value:HEX_RGB_COLOR(0x0b98f2) range:NSMakeRange(0,5)];
    _AnswerLabel.attributedText= aString;
    
    
    aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"我的问题: %@",model.Exper_questionTitle]];
    [aString addAttribute:NSForegroundColorAttributeName value:HEX_RGB_COLOR(0x333333) range:NSMakeRange(0,5)];
    [aString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0,5)];
    _QuestionLabel.attributedText= aString;
    
    if (SCREEN_HEIGHT < 667) {
        _QuestionLabel.font = [UIFont systemFontOfSize:15];
        _AnswerLabel.font = [UIFont systemFontOfSize:13];
    }
}

#pragma mark - 点赞／取消点赞 行为
- (IBAction)LikeBtnClick:(UIButton *)sender {
   
    _likeClick(sender.selected);
    
}

#pragma mark - 点赞／取消点赞 成功失败
-(void)likeClickSuccess{
    _LikeBtn.selected = !_LikeBtn.selected;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
