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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //头像
    CGFloat headImgWidth = 22;
    _headImgView = [[UIImageView alloc] init];
    _headImgView.contentMode = UIViewContentModeScaleAspectFit;
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = headImgWidth / 2;
    _headImgView.image = [UIImage imageNamed:@"默认头像.png"];
    [self addSubview:_headImgView];
    
    //用户名
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.font = [UIFont systemFontOfSize:15];
    _userNameLabel.textColor = HEX_RGBA_COLOR(0x969CA1, 1);
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_userNameLabel];
    
    //日期
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:13];
    _dateLabel.textColor = HEX_RGBA_COLOR(0x969CA1, 1);
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_dateLabel];
    
    //内容
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    //查看数量
    _lookNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_lookNumBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
    [_lookNumBtn setImage:[UIImage imageNamed:@"查看.png"] forState:UIControlStateNormal];
    _lookNumBtn.userInteractionEnabled = NO;
    UIEdgeInsets insets = _lookNumBtn.imageEdgeInsets;
    insets.left = insets.left - 5;
    _lookNumBtn.imageEdgeInsets = insets;
    insets = _lookNumBtn.titleEdgeInsets;
    insets.left = insets.left + 5;
    _lookNumBtn.titleEdgeInsets = insets;
    [self addSubview:_lookNumBtn];
    
    //点赞数量
    _likeNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_likeNumBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
    [_likeNumBtn setImage:[UIImage imageNamed:@"点赞-回复.png"] forState:UIControlStateNormal];
    [_likeNumBtn setImage:[UIImage imageNamed:@"点赞-回复.png"] forState:UIControlStateHighlighted];
    [_likeNumBtn addTarget:self action:@selector(likeWithCell:) forControlEvents:UIControlEventTouchUpInside];
    insets = _likeNumBtn.imageEdgeInsets;
    insets.left = insets.left - 5;
    _likeNumBtn.imageEdgeInsets = insets;
    insets = _likeNumBtn.titleEdgeInsets;
    insets.left = insets.left + 5;
    _likeNumBtn.titleEdgeInsets = insets;
    [self addSubview:_likeNumBtn];
    
    //添加该临时按钮对点赞按钮的约束，不添加该临时按钮会导致点赞按钮无法在修改偏移量的情况下显示完整内容
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.hidden = YES;
    [self addSubview:tempBtn];
    
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
        } else {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
        }
        make.width.offset(headImgWidth);
        make.height.offset(headImgWidth);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(_headImgView.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.equalTo(_dateLabel.mas_safeAreaLayoutGuideLeft).offset(-50);
        } else {
            make.top.equalTo(_headImgView.mas_top).offset(10);
            make.left.equalTo(_headImgView.mas_right).offset(10);
            make.right.equalTo(_dateLabel.mas_left).offset(-50);
        }
        make.height.equalTo(_headImgView.mas_height);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideTop);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
        } else {
            make.top.equalTo(_headImgView.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }
        make.height.equalTo(_headImgView.mas_height);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideBottom).offset(10);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
        } else {
            make.top.equalTo(_headImgView.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }
    }];
    
    [_lookNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_contentLabel.mas_safeAreaLayoutGuideBottom).offset(10);
            make.left.equalTo(_contentLabel.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.top.equalTo(_contentLabel.mas_bottom).offset(10);
            make.left.equalTo(_contentLabel.mas_left);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }
    }];
    
    [_likeNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lookNumBtn.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(_lookNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.lessThanOrEqualTo(tempBtn.mas_safeAreaLayoutGuideLeft).offset(-10);
        } else {
            make.left.equalTo(_lookNumBtn.mas_right).offset(10);
            make.right.lessThanOrEqualTo(tempBtn.mas_left).offset(-10);
        }
    }];
    
    [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lookNumBtn.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.greaterThanOrEqualTo(_likeNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
        } else {
            make.left.greaterThanOrEqualTo(_likeNumBtn.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }
    }];
    
}


#pragma mark - 事件功能
- (void)LikeBtnClick:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(likeWithCell:)]) {
        [self.delegate likeWithCell:self];
    }
}

#pragma mark - 功能

- (void)refreshWithModel:(AnswerModel *)model {
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrlStr] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    _userNameLabel.text = model.userName;
    _dateLabel.text = model.dateStr;
    
    _contentLabel.text = model.content;
    
    [_lookNumBtn setTitle:[NSString stringWithFormat:@"%lu", model.lookNum] forState:UIControlStateNormal];
    
    UIImage *likeImg = model.isLike ? [UIImage imageNamed:@"点赞-回复-按下"] : [UIImage imageNamed:@"点赞-回复"];
    UIColor *likeTextColor = model.isLike ? HEX_RGBA_COLOR(0x0B98F2, 1) : HEX_RGBA_COLOR(0x969CA1, 1);
    [_likeNumBtn setImage:likeImg forState:UIControlStateNormal];
    [_likeNumBtn setImage:likeImg forState:UIControlStateHighlighted];
    [_likeNumBtn setTitleColor:likeTextColor forState:UIControlStateNormal];
    [_likeNumBtn setTitle:[NSString stringWithFormat:@"%lu", model.likeNum] forState:UIControlStateNormal];
    
}

@end
