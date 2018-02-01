//
//  EnterpriseRegisterView.m
//  IPOAsk
//
//  Created by adminMac on 2018/1/31.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseRegisterView.h"

@implementation EnterpriseRegisterView

- (IBAction)LoginClick:(UIButton *)sender {
    if (_loginClickBlock) {
        _loginClickBlock(sender);
    }
}

@end
