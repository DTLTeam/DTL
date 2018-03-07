//
//  FollowTableViewCell.m
//  IPOAsk
//
//  Created by lzw on 2018/1/29.
//  Copyright © 2018年 law. All rights reserved.
//

#import "FollowTableViewCell.h"


@interface FollowTableViewCell ()

@property (nonatomic,strong) UILabel    *txtLabel;
@property (nonatomic,strong) UIButton   *lookNumBtn;
@property (nonatomic,strong) UIButton   *followNumBtn;
@property (nonatomic,strong) UIButton   *answerNumBtn;
@property (nonatomic,strong) UILabel    *dateLabel;

@end

@implementation FollowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //内容
        _txtLabel = [[UILabel alloc] init];
        _txtLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_txtLabel];
        
        //查看数量
        _lookNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_lookNumBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
        [_lookNumBtn setImage:[UIImage imageNamed:@"查看.png"] forState:UIControlStateNormal];
        _lookNumBtn.userInteractionEnabled = NO;
        [self addSubview:_lookNumBtn];
        
        //回复数量
        _answerNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_answerNumBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
        [_answerNumBtn setImage:[UIImage imageNamed:@"回答.png"] forState:UIControlStateNormal];
        _answerNumBtn.userInteractionEnabled = NO;
        [self addSubview:_answerNumBtn];
        
        //关注数量
        _followNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_followNumBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
        [_followNumBtn setImage:[UIImage imageNamed:@"关注.png"] forState:UIControlStateNormal];
        _followNumBtn.userInteractionEnabled = NO;
        [self addSubview:_followNumBtn];
        
        //日期
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = HEX_RGBA_COLOR(0x969CA1, 1);
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_dateLabel];
        
        
        [_txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(15);
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
                make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
            } else {
                make.top.equalTo(self.mas_top).offset(15);
                make.left.equalTo(self.mas_left).offset(10);
                make.right.equalTo(self.mas_right).offset(-10);
            }
        }];
        
        [_lookNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(_txtLabel.mas_safeAreaLayoutGuideBottom).offset(10);
                make.left.equalTo(_txtLabel.mas_safeAreaLayoutGuideLeft);
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            } else {
                make.top.equalTo(_txtLabel.mas_bottom).offset(10);
                make.left.equalTo(_txtLabel.mas_left);
                make.bottom.equalTo(self.mas_bottom).offset(-10);
            }
        }];
        
        [_answerNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lookNumBtn.mas_centerY);
            if (@available(iOS 11.0, *)) {
                make.left.equalTo(_lookNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
            } else {
                make.left.equalTo(_lookNumBtn.mas_right).offset(10);
            }
        }];
        
        [_followNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_lookNumBtn.mas_centerY);
            if (@available(iOS 11.0, *)) {
                make.left.equalTo(_answerNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
                make.right.lessThanOrEqualTo(_dateLabel.mas_safeAreaLayoutGuideLeft).offset(-10);
            } else {
                make.left.equalTo(_answerNumBtn.mas_right).offset(10);
                make.right.lessThanOrEqualTo(_dateLabel.mas_left).offset(-10);
            }
        }];
        
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(_txtLabel.mas_safeAreaLayoutGuideBottom).offset(15);
                make.left.greaterThanOrEqualTo(_followNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
                make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-15);
            } else {
                make.top.equalTo(_txtLabel.mas_bottom).offset(15);
                make.left.greaterThanOrEqualTo(_followNumBtn.mas_right).offset(10);
                make.right.equalTo(self.mas_right).offset(-10);
                make.bottom.equalTo(self.mas_bottom).offset(-15);
            }
        }];
        
    }
    
    return self;
}


- (void)updateAskCell:(AskDataModel *)model
{
    _txtLabel.text = model.title;
    [_lookNumBtn setTitle:[NSString stringWithFormat:@" %d",model.View] forState:UIControlStateNormal];
    [_answerNumBtn setTitle:[NSString stringWithFormat:@" %d",model.Answer] forState:UIControlStateNormal];
    [_followNumBtn setTitle:[NSString stringWithFormat:@" %d",model.Follow] forState:UIControlStateNormal];
    _dateLabel.text = model.addTime;
}

- (void)updateAnswerCell:(AnswerDataModel *)model
{
    _txtLabel.text = model.title;
    [_lookNumBtn setTitle:[NSString stringWithFormat:@" %d",model.LookNum] forState:UIControlStateNormal];
    [_answerNumBtn setTitle:[NSString stringWithFormat:@" %d",model.Answer] forState:UIControlStateNormal];
    [_followNumBtn setTitle:[NSString stringWithFormat:@" %d",model.Follow] forState:UIControlStateNormal];
    _dateLabel.text = model.addTime;
}

- (void)updateFollowCell:(FollowDataModel *)model
{
    _txtLabel.text = model.title;
    [_lookNumBtn setTitle:[NSString stringWithFormat:@" %d",model.view] forState:UIControlStateNormal];
    [_answerNumBtn setTitle:[NSString stringWithFormat:@" %d",model.answer] forState:UIControlStateNormal];
    [_followNumBtn setTitle:[NSString stringWithFormat:@" %d",model.follow] forState:UIControlStateNormal];
    _dateLabel.text = model.addTime;
}

@end
