//
//  loginEnterpriseRegisterView.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import "loginEnterpriseRegisterView.h"
#import "EnterpriseRegisterView.h"

@interface loginEnterpriseRegisterView()
@property (weak, nonatomic) IBOutlet EnterpriseRegisterView *view;

@end

@implementation loginEnterpriseRegisterView

-(void)awakeFromNib{
    [super awakeFromNib];
    UIView *view  = [[NSBundle mainBundle] loadNibNamed:@"EnterpriseRegisterView" owner:self options:nil][0];
   
    [_view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(_view);
    }];
    
}

- (IBAction)LoginClick:(UIButton *)sender {
    if (_loginClickBlock) {
        _loginClickBlock(sender);
    }
}

@end
