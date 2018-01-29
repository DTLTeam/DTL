//
//  DraftViewTableViewCell.m
//  IPOAsk
//
//  Created by lzw on 2018/1/27.
//  Copyright © 2018年 law. All rights reserved.
//

#import "DraftViewTableViewCell.h"

@interface DraftViewTableViewCell ()

@property (nonatomic,strong) UILabel *txtLabel;

@property (nonatomic,strong) UIButton *editButton;

@end

@implementation DraftViewTableViewCell

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
    
        _txtLabel = [[UILabel alloc] init];
        _txtLabel.numberOfLines = 2;
        _txtLabel.textAlignment = NSTextAlignmentLeft;
        _txtLabel.font = [UIFont systemFontOfSize:16];
        _txtLabel.textColor = [UIColor blackColor];
        _txtLabel.text = @"作为一家准备在新三板上市的公司会计，上市的时候我要准备什么资料？上市后";
        [self addSubview:_txtLabel];
        [_txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(10);
            make.top.mas_equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 40));
        }];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.layer.masksToBounds = YES;
        _editButton.layer.borderWidth = 1;
        _editButton.layer.borderColor = [UIColor blackColor].CGColor;
        _editButton.layer.cornerRadius = 3;
        _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editButton setTitle:@"继续编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_editButton];
        [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-10);
            make.bottom.mas_equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
    }
    
    return self;
}


@end
