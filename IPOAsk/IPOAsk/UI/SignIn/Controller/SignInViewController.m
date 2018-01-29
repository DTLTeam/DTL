//
//  SignInViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SignInViewController.h"
#import "ResetPasswordViewController.h"

@interface SignInViewController ()
/**
 注册页面
 */
@property (strong, nonatomic) IBOutlet UIView *RegisterView;

/**
 企业注册页面
 */
@property (strong, nonatomic) IBOutlet UIView *EnterpriseRegisterView;

/**
 登录的用户名／企业用户名
 */
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;

/**
 企业用户注册页面的企业联系方式
 */
@property (strong, nonatomic) IBOutlet UILabel *EnterpriseNumber;

/**
 个人用户注册页面的手机号码
 */
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomH;


@property (nonatomic,strong)NSString *phoneNum;
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
    
    _phoneNum = [UtilsCommon validPhoneNum:_EnterpriseNumber.text];
    //拼接电话  
    if (_phoneNum) {
        
        //更改电话颜色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_EnterpriseNumber.text];
        NSRange range = [_EnterpriseNumber.text rangeOfString:_phoneNum];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        _EnterpriseNumber.attributedText = str;
       
    }
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 个人用户
- (IBAction)personClick:(UIButton *)sender {
 
    _isPerson = YES;
    [self.view endEditing:YES];
    
    if (_RegisterView.alpha == 1) {
        //注册页面
        _EnterpriseRegisterView.hidden = _isPerson;
    }else _nameLabel.placeholder = @"请输入个人用户名称";
    
}

#pragma mark - 企业用户
- (IBAction)EnterpriseClick:(UIButton *)sender {
    
    _isPerson = NO;
    [self.view endEditing:YES];
    
    if (_RegisterView.alpha == 1) {
        //注册页面
        _EnterpriseRegisterView.hidden = _isPerson;
        
    }else _nameLabel.placeholder = @"请输入个人用户名称";
    
    
    _nameLabel.placeholder = @"请输入企业用户名称";
}

#pragma mark - 随便看看
- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [_RegisterView removeFromSuperview];
        [_EnterpriseRegisterView removeFromSuperview];
        
        _RegisterView = nil;
        _EnterpriseRegisterView = nil;
        
    }];
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
#pragma mark - 发送验证码
- (IBAction)sendVerificationCode:(UIButton *)sender {
    
    
    if ([UtilsCommon validPhoneNum:_phoneNumber.text].length > 0) {
        //是手机号码 发送验证码
        NSLog(@"已发送");
    }
    
}


#pragma  mark - 拨打企业注册电话
- (IBAction)callPhoneTap:(UITapGestureRecognizer *)sender {
    
    if (IS_IOS10LATER) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum]] options:@{} completionHandler:nil];
        
    }else  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum]]];
    
    
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
