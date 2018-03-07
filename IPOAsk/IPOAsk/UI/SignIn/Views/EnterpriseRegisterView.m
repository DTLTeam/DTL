//
//  EnterpriseRegisterView.m
//  IPOAsk
//
//  Created by adminMac on 2018/1/31.
//  Copyright © 2018年 law. All rights reserved.
//


#import "EnterpriseRegisterView.h"

@interface EnterpriseRegisterView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IconH;

@end

@implementation EnterpriseRegisterView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    if (SCREEN_HEIGHT < 667) {
        _IconH.constant = 22;
    }
}
- (IBAction)CallPhone:(UIButton *)sender {
    
  
    [UtilsCommon CallPhone];
}

@end
