//
//  SignInViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *RegisterView;

@property (strong, nonatomic) IBOutlet UIView *EnterpriseRegisterView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomH;


@property (nonatomic,assign)CGFloat isPerson;
@property (nonatomic,assign)CGFloat deftopH;
@property (nonatomic,assign)CGFloat deftopbottomH;
@property (nonatomic,assign)CGRect keyboardFrame;


@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _deftopH = _topH.constant;
    _deftopbottomH = _bottomH.constant;
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 个人用户
- (IBAction)personClick:(UIButton *)sender {
 
    _isPerson = YES;
    
    if (_RegisterView.alpha == 1) {
        //注册页面
        _EnterpriseRegisterView.hidden = _isPerson;
    }else _nameLabel.placeholder = @"请输入个人用户名称";
    
}

#pragma mark - 企业用户
- (IBAction)EnterpriseClick:(UIButton *)sender {
    _isPerson = NO;
    
    if (_RegisterView.alpha == 1) {
        //注册页面
        _EnterpriseRegisterView.hidden = _isPerson;
        
    }else _nameLabel.placeholder = @"请输入个人用户名称";
    
    
    _nameLabel.placeholder = @"请输入企业用户名称";
}

#pragma mark - 随便看看
- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册
- (IBAction)gogoRegister:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        _RegisterView.alpha = 1;
        
    } completion:nil];
  
}
#pragma mark - 已有账号登录

- (IBAction)noRegister:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
       
        _RegisterView.alpha = 0;
         
    } completion:nil];
    
    
}

#pragma mark -触摸空白地方隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 键盘状态改变通知

#pragma mark -键盘隐藏时隐藏评论工具栏
- (void)KeyboardDidHideNotification:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.38 animations:^{
        
        _topH.constant = _deftopH;
        _bottomH.constant = _deftopbottomH;
        
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark -键盘显示时弹出评论工具栏
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    _keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.38 animations:^{
        
        _topH.constant = _deftopH - CGRectGetHeight(_keyboardFrame) / 2;
        _bottomH.constant = _deftopbottomH + CGRectGetHeight(_keyboardFrame) / 2;
        
        [self.view layoutIfNeeded];
    }];
    
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
