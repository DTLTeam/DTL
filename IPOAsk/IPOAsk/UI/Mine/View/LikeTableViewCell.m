//
//  LikeTableViewCell.m
//  IPOAsk
//
//  Created by lzw on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import "LikeTableViewCell.h"

#import <UIImageView+WebCache.h>

@interface LikeTableViewCell()

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,strong) UILabel *likeTxtlabel;

@property (nonatomic,strong) UILabel *likeDateLabel;

@end

@implementation LikeTableViewCell

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
    
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 20;
        _headView.image = [UIImage imageNamed:@"默认头像"];
        [self addSubview:_headView];
        
        _likeTxtlabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, SCREEN_WIDTH - 85, 45)];
        _likeTxtlabel.numberOfLines = 2;
        [self addSubview:_likeTxtlabel];
        
        _likeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, 200, 20)];
        _likeDateLabel.font = [UIFont systemFontOfSize:15];
        _likeDateLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _likeDateLabel.textAlignment = NSTextAlignmentLeft;
        _likeDateLabel.text = @"回复时间：2018-02-20";
        [self addSubview:_likeDateLabel];

    }
    
    return self;
}


- (void)updateCell:(LikeDataModel *)model
{
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.headIcon] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    
    NSString *txt = [NSString stringWithFormat:@"%@ 赞了 %@ 下你的回复",model.realName,model.title];
    _likeTxtlabel.attributedText = [self getAttributedStringWithString:txt];
    _likeDateLabel.text = model.likeTime;
    
}

-(NSAttributedString *)getAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    
    NSRange likeRange = [string rangeOfString:@"赞了"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:0.5] range:likeRange];
    NSRange sRange = [string rangeOfString:@"下你的回复"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:0.5] range:sRange];
    
    return attributedString;
}

@end
