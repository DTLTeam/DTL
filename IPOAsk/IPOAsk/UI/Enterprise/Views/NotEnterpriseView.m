//
//  NotEnterpriseView.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import "NotEnterpriseView.h"
#import "EnterpriseRegisterView.h"

@interface NotEnterpriseView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentH;

@property (weak, nonatomic) IBOutlet EnterpriseRegisterView *view;

@end

@implementation NotEnterpriseView

-(void)awakeFromNib{
    [super awakeFromNib];
   
    UIView *view  = [[NSBundle mainBundle] loadNibNamed:@"EnterpriseRegisterView" owner:self options:nil][0];
    [_view addSubview:view];;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(_view);
    }];
    
    if (SCREEN_HEIGHT < 667) {
        _TopH.constant = 10;
        _ContentH.constant = 15;
    }
}

@end
