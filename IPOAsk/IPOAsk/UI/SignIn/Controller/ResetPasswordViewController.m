//
//  ResetPasswordViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UIBarButtonItem+myBarButtonItem.h"

@interface ResetPasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *password1;
@property (strong, nonatomic) IBOutlet UITextField *password2;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"重置密码";
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:nil bgimage:nil  Title:@"返回" SelectedTitle:@" " titleFont:12 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(back)];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -14;
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftBtn];
    
    //占位 防止左边按钮偏移
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *rightBtn = [UIBarButtonItem returnTabBarItemWithBtn:rbtn image:@"" bgimage:nil  Title:@"占" SelectedTitle:@""  titleFont:1 itemtype:Itemtype_rigth SystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn];
    [rbtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
     
}

#pragma mark - 重置密码
- (IBAction)ResetPassword:(UIButton *)sender {
    
    if (![_password1.text isEqualToString:_password2.text] && _password1.text.length > 0) {
        NSLog(@"不一致");
    }else{
        //上传接口 返回
        [self back];
    }
}

#pragma mark - 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
