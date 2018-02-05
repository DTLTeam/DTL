//
//  AnswerTableViewCell.m
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AnswerTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface AnswerTableViewCell ()

@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIButton *lookNumBtn;
@property (strong, nonatomic) UIButton *likeNumBtn;

@end

@implementation AnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupInterface];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupInterface];
        
    }
    return self;
}


#pragma mark - 界面

- (void)setupInterface {
    
    //头像
    _headImgView = [[UIImageView alloc] init];
    [self addSubview:_headImgView];
    
    //用户名
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.textColor = HEX_RGBA_COLOR(0x969ca1, 1);
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    _userNameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_userNameLabel];
    
    //日期
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = HEX_RGBA_COLOR(0x969ca1, 1);
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_dateLabel];
    
    
    //内容
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 3;
    [self addSubview:_contentLabel];
    
    //查看数量
    _lookNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_lookNumBtn setTitleColor:HEX_RGBA_COLOR(0x969ca1, 1) forState:UIControlStateNormal];
    [_lookNumBtn setImage:[UIImage imageNamed:@"查看"] forState:UIControlStateNormal];
    [self addSubview:_lookNumBtn];
    
    //回复数量
    _likeNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_likeNumBtn setTitleColor:HEX_RGBA_COLOR(0x969ca1, 1) forState:UIControlStateNormal];
    [_likeNumBtn setImage:[UIImage imageNamed:@"点赞-回复"] forState:UIControlStateNormal];
    [_likeNumBtn addTarget:self action:@selector(LikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeNumBtn];
    
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(12);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(12);
        } else {
            make.top.equalTo(self.mas_top).offset(12);
            make.left.equalTo(self.mas_left).offset(12);
        }
        make.width.offset(22);
        make.height.offset(22);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(_headImgView.mas_safeAreaLayoutGuideRight).offset(7);
            make.right.equalTo(_dateLabel.mas_safeAreaLayoutGuideLeft).offset(-50);
        } else {
            make.left.equalTo(_headImgView.mas_right).offset(7);
            make.right.equalTo(_dateLabel.mas_left).offset(-50);
        }
        make.centerY.mas_equalTo(_headImgView.mas_centerY);
        make.height.equalTo(_headImgView.mas_height);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideTop);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-12);
        } else {
            make.top.equalTo(_headImgView.mas_top);
            make.right.equalTo(self.mas_right).offset(-12);
        }
        make.width.offset(100);
        make.height.equalTo(_headImgView.mas_height);
    }];
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideBottom).offset(10);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
        } else {
            make.top.equalTo(_headImgView.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }
    }];
    
    [_lookNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_contentLabel.mas_safeAreaLayoutGuideBottom).offset(14);
            make.left.equalTo(_contentLabel.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-15);
        } else {
            make.top.equalTo(_contentLabel.mas_bottom).offset(14);
            make.left.equalTo(_contentLabel.mas_left);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }
        make.height.offset(17);
    }];
    
    [_likeNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_lookNumBtn.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(_lookNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
        } else {
            make.top.equalTo(_lookNumBtn.mas_top);
            make.left.equalTo(_lookNumBtn.mas_right).offset(27);
        }
        make.height.equalTo(_lookNumBtn.mas_height);
    }];
    
}


#pragma mark - 事件功能
- (void)LikeBtnClick:(UIButton *)sender{
    if (self.delegate) {
        [self.delegate likeWithCell:self];
    }
}

#pragma mark - 功能

- (void)refreshWithModel:(AnswerModel *)model {
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrlStr] placeholderImage:[UIImage imageNamed:@""]];
    _userNameLabel.text = model.userName;
    _dateLabel.text = model.dateStr;
    _contentLabel.text = model.content;
    [_likeNumBtn setImage:model.isLike ? [UIImage imageNamed:@"点赞-回复-按下"] : [UIImage imageNamed:@"点赞-回复"] forState:UIControlStateNormal];
    
    [_lookNumBtn setTitle:[NSString stringWithFormat:@"%lu", model.lookNum] forState:UIControlStateNormal];
    [_likeNumBtn setTitle:[NSString stringWithFormat:@"%lu", model.likeNum] forState:UIControlStateNormal];
    
}

@end
