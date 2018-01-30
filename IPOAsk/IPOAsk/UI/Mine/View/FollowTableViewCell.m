//
//  FollowTableViewCell.m
//  IPOAsk
//
//  Created by lzw on 2018/1/29.
//  Copyright © 2018年 law. All rights reserved.
//

#import "FollowTableViewCell.h"

@interface FollowTableViewCell ()

@property (nonatomic,strong) UILabel *txtLabel;

@property (nonatomic,strong) UIButton *followButton;

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
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 15)];
        tipLabel.text = @"问题:";
        tipLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:tipLabel];
        
        _txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH - 40, 50)];
        _txtLabel.numberOfLines = 0;
        _txtLabel.text = @"外国人眼中的汉字是怎样的";
        [self addSubview:_txtLabel];
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.frame = CGRectMake(SCREEN_WIDTH - 80, 70, 60, 30);
        [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_followButton];
    }
    
    return self;
}

@end
