//
//  HeadViewTableViewCell.m
//  IPOAsk
//
//  Created by lzw on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "HeadViewTableViewCell.h"
#import <UIImageView+WebCache.h>

typedef void(^ActionBlock)(NSInteger tag);

@interface HeadViewTableViewCell ()

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *phoneLabel;

@property (nonatomic,strong) UILabel *NologinLabel;

@property (nonatomic,strong) UIButton *askButton;

@property (nonatomic,strong) UIButton *answerButton;

@property (nonatomic,strong) UIButton *followButton;

@property (nonatomic,strong) UIButton *likeButton;

@property (nonatomic,copy) ActionBlock actionBlock;

@end

@implementation HeadViewTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier action:(void (^)(NSInteger))block
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT >= 667 ? 160 : 130)];
        bgView.image = [UIImage imageNamed:@"banner背景"];
        [self addSubview:bgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"我的";
        [self addSubview:label];
        
        CGFloat width = SCREEN_HEIGHT >= 667 ? 60 : 40;
        
        _headView = [[UIImageView alloc] init];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = width / 2;
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.image = [UIImage imageNamed:@"默认头像"];
        [self addSubview:_headView];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(SCREEN_HEIGHT > 667 ? 12 : 20);
            make.top.mas_equalTo(label.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(width,width));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView.mas_top).offset(5);
            make.left.mas_equalTo(_headView.mas_right).offset(12);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:13];
        _phoneLabel.text = @"";
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.alpha = 0.7;
        [self addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
        if (![UserDataManager shareInstance].userModel) {
            _NologinLabel = [[UILabel alloc]init];
            [self addSubview:_NologinLabel];
            _NologinLabel.text = @"未登录";
            _NologinLabel.textColor = [UIColor whiteColor];
            _nameLabel.hidden = YES;
            _phoneLabel.hidden = YES;
            
            [_NologinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(_headView.mas_right).offset(12);
                make.centerY.mas_equalTo(_headView.mas_centerY);
            }];
        }
        
        _askButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _askButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _askButton.titleLabel.numberOfLines = 0;
        [_askButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的提问" lineSpace:5] forState:UIControlStateNormal];
        [_askButton addTarget:self action:@selector(askAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_askButton];
        [_askButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(0);
            make.bottom.mas_equalTo(self).offset(-12);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];
       
        _answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _answerButton.titleLabel.numberOfLines = 0;
        [_answerButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的回答" lineSpace:5] forState:UIControlStateNormal];
        [_answerButton addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_answerButton];
        [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_askButton).offset(SCREEN_WIDTH/4);
            make.bottom.mas_equalTo(_askButton.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _followButton.titleLabel.numberOfLines = 0;
        [_followButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的关注" lineSpace:5] forState:UIControlStateNormal];
        [_followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followButton];
        [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_answerButton).offset(SCREEN_WIDTH/4);
            make.bottom.mas_equalTo(_answerButton.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];

        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _likeButton.titleLabel.numberOfLines = 0;
        [_likeButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的成就" lineSpace:5] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_followButton).offset(SCREEN_WIDTH/4);
            make.bottom.mas_equalTo(_followButton.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];
    
        _actionBlock = block;
        
    }
    
    return self;
}

- (void)updateInfo:(NSString *)headUrl name:(NSString *)name phone:(NSString *)phone
{
    if (![UserDataManager shareInstance].userModel ) {
        _NologinLabel.hidden = NO;
        _nameLabel.hidden = YES;
        _phoneLabel.hidden = YES;
        return;
    }
    _NologinLabel.hidden = YES;
    _nameLabel.hidden = NO;
    _phoneLabel.hidden = NO;
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _nameLabel.text = name;
    _phoneLabel.text = [phone stringByReplacingOccurrencesOfString:[phone substringWithRange:NSMakeRange(3, 5)] withString:@"*****"];
}

- (void)updateAskInfo:(NSInteger)askNum answer:(NSInteger)ansNum follow:(NSInteger)foNum like:(NSInteger)likeNum
{
    [_askButton setAttributedTitle:[self getAttributedStringWithString:[NSString stringWithFormat:@"%d\n我的提问",(int)askNum] lineSpace:5] forState:UIControlStateNormal];
    [_answerButton setAttributedTitle:[self getAttributedStringWithString:[NSString stringWithFormat:@"%d\n我的回答",(int)ansNum] lineSpace:5] forState:UIControlStateNormal];
    [_followButton setAttributedTitle:[self getAttributedStringWithString:[NSString stringWithFormat:@"%d\n我的关注",(int)foNum] lineSpace:5] forState:UIControlStateNormal];
    [_likeButton setAttributedTitle:[self getAttributedStringWithString:[NSString stringWithFormat:@"%d\n我的成就",(int)likeNum] lineSpace:5] forState:UIControlStateNormal];
    
}

-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

#pragma mark - action
- (void)likeAction:(UIButton *)sender
{
    DLog(@"likeAction");
    if (_actionBlock) {
        _actionBlock(3);
    }
}

- (void)followAction:(UIButton *)sender
{
    DLog(@"followAction");
    if (_actionBlock) {
        _actionBlock(2);
    }
}

- (void)answerAction:(UIButton *)sender
{
    DLog(@"answerAction");
    if (_actionBlock) {
        _actionBlock(1);
    }
}

- (void)askAction:(UIButton *)sender
{
    DLog(@"askAction");
    if (_actionBlock) {
        _actionBlock(0);
    }
}


@end
