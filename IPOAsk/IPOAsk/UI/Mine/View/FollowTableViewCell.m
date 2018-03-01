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
@property (nonatomic,strong) UILabel *viewLabel;
@property (nonatomic,strong) UILabel *followLabel;
@property (nonatomic,strong) UILabel *answerLabel;
@property (nonatomic,strong) UILabel *dateLabel;

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
        _txtLabel.text = @"";
        [self addSubview:_txtLabel];
        
        for (int i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*50, 50, 15, 15)];
            imgView.image = [UIImage imageNamed:i==0?@"查看":i==1?@"回答":@"关注"];
            [self addSubview:imgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32+i*50, 50, 20, 15)];
            label.text = @"0";
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13];
            [self addSubview:label];
            if (i == 0) {
                _viewLabel = label;
//            }else if (i == 2)
            }else if (i == 1)
            {
                _answerLabel = label;
            }else
            {
                _followLabel = label;
            }
        }
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 47, 80, 20)];
        _dateLabel.text = @"";
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_dateLabel];
        
    }
    
    return self;
}


- (void)updateAskCell:(AskDataModel *)model
{
    _txtLabel.text = model.title;
    _viewLabel.text = [NSString stringWithFormat:@"%d",model.View];
    _answerLabel.text = [NSString stringWithFormat:@"%d",model.Answer];
    _followLabel.text = [NSString stringWithFormat:@"%d",model.Follow];
    _dateLabel.text = model.addTime;
}

- (void)updateAnswerCell:(AnswerDataModel *)model
{
    _txtLabel.text = model.title;
    _viewLabel.text = [NSString stringWithFormat:@"%d",model.LookNum];
    _answerLabel.text = [NSString stringWithFormat:@"%d",model.Answer];
    _followLabel.text = [NSString stringWithFormat:@"%d",model.Follow];
    _dateLabel.text = model.addTime;
}

- (void)updateFollowCell:(FollowDataModel *)model
{
    _txtLabel.text = model.title;
    _viewLabel.text = [NSString stringWithFormat:@"%d",model.view];
    _answerLabel.text = [NSString stringWithFormat:@"%d",model.answer];
    _followLabel.text = [NSString stringWithFormat:@"%d",model.follow];
    _dateLabel.text = model.addTime;
}

@end
