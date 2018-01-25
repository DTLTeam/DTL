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
    
    _AnswerDate.text = model.Exper_recoveryTime;
     
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"专家答案: %@",model.Exper_answerAnswer]];
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(0,5)];
    _AnswerLabel.attributedText= aString;
    
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
