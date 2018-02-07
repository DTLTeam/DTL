//
//  QuestionTableViewCell.m
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "QuestionTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

typedef enum : NSUInteger {
    kButtonNormal,      //未选中
    kButtonSelected     //已选中
} ButtonStatus; //按钮状态

@interface QuestionTableViewCell ()

@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIButton *lookNumBtn;
@property (strong, nonatomic) UIButton *replyNumBtn;
@property (strong, nonatomic) UIButton *attentionNumBtn;
@property (strong, nonatomic) UIButton *attentionBtn;

@property (nonatomic,assign)  BOOL Main;


@end

@implementation QuestionTableViewCell

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Main:(BOOL)main{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _Main = main;
        
        [self setupInterface];
        
        //根据页面来判断需要显示多少的内容
        if (_Main) {
            _titleLabel.numberOfLines = 1;
            _contentLabel.numberOfLines = 2;
        }else{
            _contentLabel.numberOfLines = 5;
        }
        
    }
    return self;
}


#pragma mark - 界面

- (void)setupInterface{
    
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
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
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
    
    //回复数量
    _replyNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _replyNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_replyNumBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
    [_replyNumBtn setImage:[UIImage imageNamed:@"回答.png"] forState:UIControlStateNormal];
    _replyNumBtn.userInteractionEnabled = NO;
    insets = _replyNumBtn.imageEdgeInsets;
    insets.left = insets.left - 5;
    _replyNumBtn.imageEdgeInsets = insets;
    insets = _replyNumBtn.titleEdgeInsets;
    insets.left = insets.left + 5;
    _replyNumBtn.titleEdgeInsets = insets;
    [self addSubview:_replyNumBtn];
    
    //关注数量
    _attentionNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_attentionNumBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
    [_attentionNumBtn setImage:[UIImage imageNamed:@"关注.png"] forState:UIControlStateNormal];
    _attentionNumBtn.userInteractionEnabled = NO;
    insets = _attentionNumBtn.imageEdgeInsets;
    insets.left = insets.left - 5;
    _attentionNumBtn.imageEdgeInsets = insets;
    insets = _attentionNumBtn.titleEdgeInsets;
    insets.left = insets.left + 5;
    _attentionNumBtn.titleEdgeInsets = insets;
    [self addSubview:_attentionNumBtn];
    
    //关注按钮
    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_attentionBtn setTitleColor:HEX_RGBA_COLOR(0x0B98F2, 1) forState:UIControlStateNormal];
    [_attentionBtn setTitleColor:HEX_RGBA_COLOR(0x0B98F2, 1) forState:UIControlStateHighlighted];
    [_attentionBtn setImage:[UIImage imageNamed:@"+关注.png"] forState:UIControlStateNormal];
    [_attentionBtn setImage:[UIImage imageNamed:@"+关注.png"] forState:UIControlStateHighlighted];
    [_attentionBtn setTitle:@"关注问题" forState:UIControlStateNormal];
    [_attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    _attentionBtn.tag = kButtonNormal;
    insets = _attentionBtn.imageEdgeInsets;
    insets.left = insets.left - 5;
    _attentionBtn.imageEdgeInsets = insets;
    insets = _attentionBtn.titleEdgeInsets;
    insets.left = insets.left + 5;
    _attentionBtn.titleEdgeInsets = insets;
    [self addSubview:_attentionBtn];
    
    
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
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_titleLabel.mas_safeAreaLayoutGuideBottom).offset(5);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
        } else {
            make.top.equalTo(_titleLabel.mas_bottom).offset(5);
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
    
    [_replyNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lookNumBtn.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(_lookNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
        } else {
            make.left.equalTo(_lookNumBtn.mas_right).offset(10);
        }
    }];
    
    [_attentionNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lookNumBtn.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(_replyNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.lessThanOrEqualTo(_attentionBtn.mas_safeAreaLayoutGuideLeft).offset(-10);
        } else {
            make.left.equalTo(_replyNumBtn.mas_right).offset(10);
            make.right.lessThanOrEqualTo(_attentionBtn.mas_left).offset(-10);
        }
    }];
    
    [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lookNumBtn.mas_centerY);
        if (@available(iOS 11.0, *)) {
            make.left.greaterThanOrEqualTo(_attentionNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
        } else {
            make.left.greaterThanOrEqualTo(_attentionNumBtn.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }
    }];
    
}


#pragma mark - 事件响应

#pragma mark 关注
- (void)attentionAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(attentionWithCell:)]) {
        [_delegate attentionWithCell:self];
    }
    
}


#pragma mark - 功能

- (void)refreshWithModel:(QuestionModel *)model {
    
    if (model.isAnonymous) { //匿名
        _headImgView.image = [UIImage imageNamed:@"默认头像.png"];
        _userNameLabel.text = @"匿名";
    } else {
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrlStr] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
        _userNameLabel.text = model.userName;
    }
    _dateLabel.text = model.dateStr;
    
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    
    NSString *numStr = model.lookNum <= 0 ? @"" : [NSString stringWithFormat:@"%lu", model.lookNum];
    [_lookNumBtn setTitle:numStr forState:UIControlStateNormal];
    numStr = model.replyNum <= 0 ? @"" : [NSString stringWithFormat:@"%lu", model.replyNum];
    [_replyNumBtn setTitle:numStr forState:UIControlStateNormal];
    numStr = model.attentionNum <= 0 ? @"" : [NSString stringWithFormat:@"%lu", model.attentionNum];
    [_attentionNumBtn setTitle:numStr forState:UIControlStateNormal];
    
    if (model.isAttention) {
        [_attentionBtn setImage:[UIImage imageNamed:@"已关注.png"] forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed:@"已关注.png"] forState:UIControlStateHighlighted];
        [_attentionBtn setTitle:@"已关注问题" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:HEX_RGBA_COLOR(0x969CA1, 1) forState:UIControlStateHighlighted];
        _attentionBtn.tag = kButtonSelected;
    } else {
        [_attentionBtn setImage:[UIImage imageNamed:@"+关注.png"] forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"关注问题" forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"关注问题" forState:UIControlStateHighlighted];
        [_attentionBtn setTitleColor:HEX_RGBA_COLOR(0x0B98F2, 1) forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:HEX_RGBA_COLOR(0x0B98F2, 1) forState:UIControlStateHighlighted];
        _attentionBtn.tag = kButtonNormal;
    }
    
}

@end
