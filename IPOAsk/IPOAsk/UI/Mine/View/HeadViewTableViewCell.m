//
//  HeadViewTableViewCell.m
//  IPOAsk
//
//  Created by lzw on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "HeadViewTableViewCell.h"

typedef void(^ActionBlock)(NSInteger tag);

@interface HeadViewTableViewCell ()

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *phoneLabel;

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
        
        _headView = [[UIImageView alloc] init];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 30;
        [_headView.layer setBorderWidth:1];
        _headView.backgroundColor = [UIColor redColor];
        [_headView.layer setBorderColor:[UIColor blackColor].CGColor];
        [self addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(25);
            make.top.mas_equalTo(self).offset(40);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.text = @"骑着妞妞打呼噜";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(50);
            make.left.mas_equalTo(_headView.mas_left).offset(80);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:13];
        _phoneLabel.text = @"123*******11";
        _phoneLabel.textColor = [UIColor blackColor];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_top).offset(20);
            make.left.mas_equalTo(_headView.mas_left).offset(80);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
        _askButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _askButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _askButton.titleLabel.numberOfLines = 0;
        [_askButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_askButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的提问" lineSpace:5] forState:UIControlStateNormal];
        [_askButton addTarget:self action:@selector(askAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_askButton];
        [_askButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(0);
            make.bottom.mas_equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];
       
        _answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _answerButton.titleLabel.numberOfLines = 0;
        [_answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_answerButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的回答" lineSpace:5] forState:UIControlStateNormal];
        [_answerButton addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_answerButton];
        [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_askButton).offset(SCREEN_WIDTH/4);
            make.bottom.mas_equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _followButton.titleLabel.numberOfLines = 0;
        [_followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_followButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的关注" lineSpace:5] forState:UIControlStateNormal];
        [_followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followButton];
        [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_answerButton).offset(SCREEN_WIDTH/4);
            make.bottom.mas_equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];

        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _likeButton.titleLabel.numberOfLines = 0;
        [_likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_likeButton setAttributedTitle:[self getAttributedStringWithString:@"1\n我的成就" lineSpace:5] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_followButton).offset(SCREEN_WIDTH/4);
            make.bottom.mas_equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 50));
        }];
        
        
        _actionBlock = block;
        
    }
    
    return self;
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
