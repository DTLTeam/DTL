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
        
        
        _txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 40, 20)];
        _txtLabel.text = @"外国人眼中的汉字是怎样的";
        [self addSubview:_txtLabel];
        
        for (int i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*50, 50, 15, 15)];
            imgView.backgroundColor = [UIColor redColor];
            imgView.tag = 10+i;
            [self addSubview:imgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30+i*50, 50, 20, 15)];
            label.text = @"15";
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13];
            label.tag = 20*i;
            [self addSubview:label];
        }
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 47, 80, 20)];
        dateLabel.text = @"2018-01-01";
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:dateLabel];
        
    }
    
    return self;
}

@end
