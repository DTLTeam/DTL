//
//  EnterpriseAnswerTableViewCell.m
//  IPOAsk
//
//  Created by updrv on 2018/3/7.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseAnswerTableViewCell.h"

@interface EnterpriseAnswerTableViewCell ()

@property (strong, nonatomic) UIImageView   *headImgView;
@property (strong, nonatomic) UILabel       *nickLabel;
@property (strong, nonatomic) UILabel       *dateLabel;
@property (strong, nonatomic) UIButton      *likeBtn;
@property (strong, nonatomic) UILabel       *answerCotentLabel;

@property (copy, nonatomic) LikeBlock likeBlock;

@end

@implementation EnterpriseAnswerTableViewCell

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

- (void)dealloc {
    _likeBlock = nil;
}


#pragma mark - 界面

- (void)setupInterface {
    
    self.backgroundColor = HEX_RGBA_COLOR(0xF7F7F7, 1);
    
    _headImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"默认头像.png"]];
    _headImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_headImgView];
    
    _nickLabel = [[UILabel alloc] init];
    _nickLabel.textAlignment = NSTextAlignmentLeft;
    _nickLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
    _nickLabel.font = [UIFont systemFontOfSize:15];
    _nickLabel.numberOfLines = 1;
    [self addSubview:_nickLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.textColor = HEX_RGBA_COLOR(0x999999, 1);
    _dateLabel.font = [UIFont systemFontOfSize:13];
    _dateLabel.numberOfLines = 1;
    [self addSubview:_dateLabel];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *likeImg = [UIImage imageNamed:@"点赞-回复"];
    [_likeBtn setImage:likeImg forState:UIControlStateNormal];
    [_likeBtn setImage:likeImg forState:UIControlStateHighlighted];
    [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEX_RGBA_COLOR(0xE9E9E9, 1);
    [self addSubview:lineView];
    
    _answerCotentLabel = [[UILabel alloc] init];
    _answerCotentLabel.textAlignment = NSTextAlignmentLeft;
    _answerCotentLabel.textColor = HEX_RGBA_COLOR(0x484848, 1);
    _answerCotentLabel.font = [UIFont systemFontOfSize:16];
    _answerCotentLabel.numberOfLines = 0;
    [self addSubview:_answerCotentLabel];
    
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
        } else {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
        }
        make.width.offset(35);
        make.height.equalTo(_headImgView.mas_width);
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(_headImgView.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.lessThanOrEqualTo(_likeBtn.mas_safeAreaLayoutGuideLeft).offset(-10);
        } else {
            make.top.equalTo(_headImgView.mas_top);
            make.left.equalTo(_headImgView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(_likeBtn.mas_left).offset(-10);
        }
        make.height.offset(16);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(_headImgView.mas_safeAreaLayoutGuideRight).offset(10);
            make.right.lessThanOrEqualTo(_likeBtn.mas_safeAreaLayoutGuideLeft).offset(-10);
            make.bottom.equalTo(_headImgView.mas_safeAreaLayoutGuideBottom);
        } else {
            make.left.equalTo(_headImgView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(_likeBtn.mas_left).offset(-10);
            make.bottom.equalTo(_headImgView.mas_bottom);
        }
        make.height.offset(16);
    }];
    
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideTop);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(_headImgView.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(_headImgView.mas_top);
            make.bottom.equalTo(_headImgView.mas_bottom);
            make.right.equalTo(self.mas_right);
        }
        make.width.offset(40);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_headImgView.mas_safeAreaLayoutGuideTop).offset(10);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.equalTo(_headImgView.mas_top).offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }
        make.height.offset(1);
    }];
    
    [_answerCotentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(lineView.mas_safeAreaLayoutGuideTop).offset(15);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-15);
        } else {
            make.top.equalTo(lineView.mas_top).offset(15);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }
    }];
    
}


#pragma mark - 事件响应

- (void)likeAction:(id)sender {
    
    if (_likeBlock) {
        _likeBlock(self);
    }
    
}


#pragma mark - 功能

- (void)refreshWithModel:(AnswerDataModel *)mod like:(LikeBlock)likeBlock {
    
    _likeBlock = likeBlock;
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:mod.headImageUrlStr] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    _nickLabel.text = mod.nickName;
    _dateLabel.text = [NSString stringWithFormat:@"回复时间:  %@", mod.dateStr];
    
    UIImage *likeImg = mod.isLike ? [UIImage imageNamed:@"点赞-回复-按下"] : [UIImage imageNamed:@"点赞-回复"];
    [_likeBtn setImage:likeImg forState:UIControlStateNormal];
    [_likeBtn setImage:likeImg forState:UIControlStateHighlighted];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"专家答案:  %@", mod.answerContent]];
    NSRange range = NSMakeRange(0, [content.string length]);
    [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    [content addAttribute:NSForegroundColorAttributeName value:HEX_RGBA_COLOR(0x484848, 1) range:range];
    range = NSMakeRange(0, 5);
    [content addAttribute:NSForegroundColorAttributeName value:HEX_RGBA_COLOR(0x0B98F2, 1) range:range];
    _answerCotentLabel.attributedText = content;
    
}

@end
