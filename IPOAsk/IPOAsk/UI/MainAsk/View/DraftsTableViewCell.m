//
//  DraftsTableViewCell.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import "DraftsTableViewCell.h"

@interface DraftsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;



@end

@implementation DraftsTableViewCell


-(void)UpLoadCell:(DraftsModel *)model{
    _titleLabel.text = model.title;
    
    _ContentLabel.text = model.content;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
