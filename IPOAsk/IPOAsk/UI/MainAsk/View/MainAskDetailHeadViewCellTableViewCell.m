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
@property (weak, nonatomic) IBOutlet UIButton *AnswerBtn;
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
    
    [_CommNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_SeeNum.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(_SeeNum.mas_safeAreaLayoutGuideRight).offset(10);
        } else {
            make.left.equalTo(_SeeNum.mas_right).offset(10);
        }
    }];
    
    [_FollowNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_SeeNum.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(_CommNum.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.lessThanOrEqualTo(_FollowBtn.mas_safeAreaLayoutGuideLeft).offset(-10);
        } else {
            make.left.equalTo(_CommNum.mas_right).offset(10);
            make.right.lessThanOrEqualTo(_FollowBtn.mas_left).offset(-10);
        }
    }];
    
    
    [_FollowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_SeeNum.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.greaterThanOrEqualTo(_FollowNum.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-12);
        } else {
            make.left.greaterThanOrEqualTo(_FollowNum.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-12);
        }
    }];
}


#pragma mark - 更新数据
-(void)UpdateContent:(AskDataModel *)model WithFollowClick:(void (^)(UIButton *))FollowClick WithAnswerClick:(void (^)(UIButton *))AnswerClick WithAllClick:(void (^)(BOOL))AllClick{
    
    _followClick = FollowClick;
    _answerClick = AnswerClick;
    _allClick = AllClick;
    
    _QuestionLabel.text = model.questionTitle;
    _ContentLabel.text = model.questionContent;
    
    if ([model isKindOfClass:[AskDataModel class]]){
        
        AskDataModel *askMod = (AskDataModel *)model;
        
        [_UserImage sd_setImageWithURL:[NSURL URLWithString:askMod.headImageUrlStr] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        _UserName.text = [UserDataManager shareInstance].userModel.nickName;
        
        [_SeeNum setTitle:[NSString stringWithFormat:@" %lu", askMod.lookNum] forState:UIControlStateNormal];
        [_CommNum setTitle:[NSString stringWithFormat:@" %lu", askMod.answerNum] forState:UIControlStateNormal];
        [_FollowNum setTitle:[NSString stringWithFormat:@" %lu", askMod.followNum] forState:UIControlStateNormal];
        
        _FollowBtn.selected = askMod.isAttention; //后续需要提问时后台处理自己关注自己问题
        
    }
    
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
    
    if (model.isFromMyself) { //自己的提问
        _FollowBtn.hidden = YES;
    } else { //非自己的问题
        _FollowBtn.hidden = NO;
    }
    if ([UserDataManager shareInstance].userModel.userType == loginType_Enterprise) { //企业用户
        _AnswerBtn.hidden = YES;
    } else { //个人用户
        _AnswerBtn.hidden = NO;
    }
    
//    CGFloat labelHeight = [_ContentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 12 - 12 , MAXFLOAT)].height;
//    NSNumber *count = @((labelHeight) /_ContentLabel.font.lineHeight);
    NSInteger count =  [self needLinesWithWidth:SCREEN_WIDTH - 12 - 12 string:_ContentLabel.text Label:_ContentLabel];
    if (count <= 5 && !_ShowAll.hidden) {
        _ShowAll.hidden = YES;
        _BottomH.constant -= 28;
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

/**
 显示当前文字需要几行
 @param width 宽度
 @return 行数
 */
- (NSInteger)needLinesWithWidth:(CGFloat)width string:(NSString *)text Label:(UILabel *)label{
    
    NSInteger sum = 0;
    
    NSArray * splitText = [text componentsSeparatedByString:@"\n"];
    for (NSString * sText in splitText) {
        label.text = sText;
        
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        NSInteger lines = ceilf( textSize.width / width);
        
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;
}
@end
