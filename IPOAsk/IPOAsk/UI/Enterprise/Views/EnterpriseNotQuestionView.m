//
//  EnterpriseNotQuestionView.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseNotQuestionView.h"

@interface EnterpriseNotQuestionView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopH;

@end


@implementation EnterpriseNotQuestionView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    if (SCREEN_HEIGHT < 667) {
        _TopH.constant = 50;
    }
    
}


- (IBAction)AddQuestion:(UIButton *)sender {
    
    if (self.addQuestionClickBlock) {
        self.addQuestionClickBlock(sender);
    }
    
}

@end
