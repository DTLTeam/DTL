//
//  EnterpriseViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseViewController.h"
#import "MessageViewController.h"

@interface EnterpriseViewController ()

@end

@implementation EnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"企业+";
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.haveRefresh = NO;
    self.haveData = self.sourceData.count > 0 ? YES : NO;
    
    [self setUpViews];
    
    
    self.headerRefresh = ^(BOOL headerR) {
        
        NSLog(@"点击背景图刷新消息");
    };
    
}

- (void)setUpViews{
    
    __weak EnterpriseViewController *weakSelf = self;
    
#if 0
    // test****************** 已经是专家
    if (!self.haveData) {
        //没有数据
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 10, SCREEN_WIDTH / 2, 30)];
        label.text = @"还没有向专家提出问题";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [self.bgImageView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(Consultation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"马上咨询专家" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.frame = CGRectMake(SCREEN_WIDTH / 4, CGRectGetMaxY(label.frame) , SCREEN_WIDTH / 2, 30);
        [self.bgImageView addSubview:btn];
        
    }else{
        //有数据
    }
    // test****************** 已经是专家
#else
    
    // test****************** 个人用户
    [AskProgressHUD ShowTipsAlterViewWithTitle:nil Message:@"申请成为企业用户与专家团队一对一交流" DefaultAction:@"申请企业账户" CancelAction:@"以后再说" Defaulthandler:^(UIAlertAction *action) {
        
    } cancelhandler:^(UIAlertAction *action) {
        
    } ControllerView:^(UIAlertController *vc) {
        [weakSelf presentViewController:vc animated:YES completion:nil];
        
    }];
    // test****************** 个人用户
    
#endif
}


#pragma mark - 马上咨询专家
- (void)Consultation{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

