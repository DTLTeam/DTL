//
//  MainAskDetailHeadViewCellTableViewCell.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/2.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainAskDetailHeadViewCellTableViewCell.h"


@interface MainAskDetailHeadViewCellTableViewCell() 
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *QuestionLabel;
@property (weak, nonatomic) IBOutlet UIButton *SeeNum;
@property (weak, nonatomic) IBOutlet UIButton *CommNum;
@property (weak, nonatomic) IBOutlet UIButton *FollowNum;
@property (weak, nonatomic) IBOutlet UIButton *FollowBtn;

@property (weak, nonatomic) IBOutlet UIView *ShowAll;
 


@property (nonatomic,strong)void (^(followClick))(UIButton *btn);
@property (nonatomic,strong)void (^(answerClick))(UIButton *btn);
@property (nonatomic,strong)void (^(allClick))(BOOL all);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Line2;

@end

@implementation MainAskDetailHeadViewCellTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
}


#pragma mark - 更新数据
-(void)UpdateContent:(QuestionModel *)model WithFollowClick:(void (^)(UIButton *))FollowClick WithAnswerClick:(void (^)(UIButton *))AnswerClick WithAllClick:(void (^)(BOOL))AllClick{
    
    _followClick = FollowClick;
    _answerClick = AnswerClick;
    _allClick = AllClick;
    
    _UserName.text = model.userName;
    _QuestionLabel.text = model.title;
    _ContentLabel.text = model.content;
    
    [_SeeNum setTitle:[NSString stringWithFormat:@"%ld",model.lookNum] forState:UIControlStateNormal];
    [_CommNum setTitle:[NSString stringWithFormat:@"%ld",model.replyNum] forState:UIControlStateNormal];
    [_FollowNum setTitle:[NSString stringWithFormat:@"%ld",model.attentionNum] forState:UIControlStateNormal];
    
    _FollowBtn.selected = model.isAttention;
    
    if (_ContentLabel.numberOfLines == 0) {
        _ShowAll.hidden = YES;
        _BottomH.constant -= 28;
    }
    
    if (SCREEN_HEIGHT < 667) {
        _Line1.constant = 10;
        _Line2.constant = 10;
        _FollowBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _ContentLabel.font = [UIFont systemFontOfSize:15];
        _QuestionLabel.font = [UIFont systemFontOfSize:15];
    }
}

#pragma mark - 关注
- (IBAction)FollowClick:(UIButton *)sender {
    
    if (_followClick) {
        _followClick(sender);
    }
    
}

#pragma mark - 我来回答
- (IBAction)AnswerClick:(UIButton *)sender {
    
    if (_answerClick) {
        _answerClick(sender);
    }
}

#pragma mark - 展开全文
- (IBAction)ShowAllClick:(UIButton *)sender {
    
    
    if (_allClick) {
        _allClick(YES);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
