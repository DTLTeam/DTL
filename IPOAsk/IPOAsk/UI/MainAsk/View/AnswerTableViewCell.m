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

@property (strong, nonatomic) UILabel *titleLabel;
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
    _userNameLabel.textColor = HEX_RGBA_COLOR(0xA6ABAF, 1);
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_userNameLabel];
    
    //日期
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = HEX_RGBA_COLOR(0xA6ABAF, 1);
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_dateLabel];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = HEX_RGBA_COLOR(0x000000, 1);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    //内容
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = HEX_RGBA_COLOR(0x7F7F7F, 1);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    //查看数量
    _lookNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_lookNumBtn setTitleColor:HEX_RGBA_COLOR(0xA6ABAF, 1) forState:UIControlStateNormal];
    [_lookNumBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self addSubview:_lookNumBtn];
    
    //回复数量
    _likeNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_likeNumBtn setTitleColor:HEX_RGBA_COLOR(0xA6ABAF, 1) forState:UIControlStateNormal];
    [_likeNumBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self addSubview:_likeNumBtn];
    
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
        } else {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
        }
        make.width.offset(30);
        make.height.offset(30);
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
        make.width.offset(100);
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
            make.top.equalTo(_contentLabel.mas_safeAreaLayoutGuideBottom).offset(5);
            make.left.equalTo(_contentLabel.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
            make.left.equalTo(_contentLabel.mas_left);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }
        make.width.offset(50);
        make.height.offset(30);
    }];
    
    [_likeNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_lookNumBtn.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(_lookNumBtn.mas_safeAreaLayoutGuideRight).offset(10);
        } else {
            make.top.equalTo(_lookNumBtn.mas_top);
            make.left.equalTo(_lookNumBtn.mas_right).offset(10);
        }
        make.width.equalTo(_lookNumBtn.mas_width);
        make.height.equalTo(_lookNumBtn.mas_height);
    }];
    
}


#pragma mark - 事件功能


#pragma mark - 功能

- (void)refreshWithModel:(AnswerModel *)model {
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrlStr] placeholderImage:[UIImage imageNamed:@""]];
    _userNameLabel.text = model.userName;
    _dateLabel.text = model.dateStr;
    
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    
    [_lookNumBtn setTitle:[NSString stringWithFormat:@"%lu", model.lookNum] forState:UIControlStateNormal];
    [_likeNumBtn setTitle:[NSString stringWithFormat:@"%lu", model.likeNum] forState:UIControlStateNormal];
    
}

@end
