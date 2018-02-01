//
//  EnterpriseRegisterView.m
//  IPOAsk
//
//  Created by adminMac on 2018/1/31.
//  Copyright © 2018年 law. All rights reserved.
//


static NSString * phoneNum = @"15012345678";

#import "EnterpriseRegisterView.h"


@implementation EnterpriseRegisterView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    
}
- (IBAction)CallPhone:(UIButton *)sender {
    
    if (IS_IOS10LATER) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]] options:@{} completionHandler:nil];
        
    }else  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
    
}

@end
