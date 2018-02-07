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
    
    UIEdgeInsets insets = _SeeNum.imageEdgeInsets;
    insets.left = insets.left - 5;
    _SeeNum.imageEdgeInsets = insets;
    insets = _SeeNum.titleEdgeInsets;
    insets.left = insets.left + 5;
    _SeeNum.titleEdgeInsets = insets;
    
    insets = _CommNum.imageEdgeInsets;
    insets.left = insets.left - 5;
    _CommNum.imageEdgeInsets = insets;
    insets = _CommNum.titleEdgeInsets;
    insets.left = insets.left + 5;
    _CommNum.titleEdgeInsets = insets;
    
    insets = _FollowNum.imageEdgeInsets;
    insets.left = insets.left - 5;
    _FollowNum.imageEdgeInsets = insets;
    insets = _FollowNum.titleEdgeInsets;
    insets.left = insets.left + 5;
    _FollowNum.titleEdgeInsets = insets;
    
    insets = _FollowBtn.imageEdgeInsets;
    insets.left = insets.left - 5;
    _FollowBtn.imageEdgeInsets = insets;
    insets = _FollowBtn.titleEdgeInsets;
    insets.left = insets.left + 5;
    _FollowBtn.titleEdgeInsets = insets;
    
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
