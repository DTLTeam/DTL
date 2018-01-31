//
//  SignInViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SignInViewController.h"
#import "ResetPasswordViewController.h"

#import "loginView.h"
#import "RegisterView.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UIView *TopViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopH;
@property (nonatomic,assign)CGRect keyboardFrame;

@property (weak, nonatomic) IBOutlet UIView *ChooseLine;
@property (weak, nonatomic) IBOutlet UIView *PersonView;
@property (weak, nonatomic) IBOutlet UIView *EnterpriseView; 


@property (nonatomic,strong)UIView          *MainView;
@property (nonatomic,strong)loginView       *LoginView;
@property (nonatomic,strong)RegisterView    *RegisterView;


@property (nonatomic,assign)loginType MainLoginType;


@end

static NSString * phoneNum = @"15012345678";


@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpLoginView];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
}

 
#pragma mark - 登录界面
- (void)setUpLoginView{
    
    _MainView = [[UIView alloc]init];
    [self.view addSubview:_MainView];
    
    [_MainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(_TopViews.mas_bottom);
    }];
    
    __weak SignInViewController *WeakSelf = self;
    //登录界面
    _LoginView = [[loginView alloc]initWithAction:^(btnType tag, NSString *userName, NSString *Password) {
        NSLog(@"%@,%@",userName,Password);
        WeakSelf.editing = YES;
        
        switch (tag) {
            case btnType_login:
                //登录
                
                break;
              
            case btnType_forgot:
                //忘记密码
                [WeakSelf forgotPassword];
                break;
                
            case btnType_pass:
                //随便看看
                [WeakSelf dismiss];
                break;
                
            case btnType_register:
                //新用户注册
                [WeakSelf goRegister];
                break;
            default:
                break;
        }
    }];
    [_MainView addSubview:_LoginView]; 
    
    
    [_LoginView mas_makeConstraints:^(MASConstraintMaker *make) { 
        make.left.and.right.and.top.and.bottom.mas_equalTo(_MainView);
    }];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 注册界面
- (void)SetUpRegisterView{
 
    __weak SignInViewController *WeakSelf = self;
    _RegisterView = [[RegisterView alloc]initWithAction:^(RegisterbtnType type, NSString *phone, NSString *Password, NSString *Code) {
        switch (type) {
            case RegisterbtnType_Login://已有账号登录
                [WeakSelf noRegister];
                break;
                
            case RegisterbtnType_Register://注册
                NSLog(@"%@-%@-%@",phone,Password,Code);
                //成功
                [WeakSelf noRegister];
                break;
                
            default:
                break;
        }
    }];
    [_MainView addSubview:_RegisterView];
    
    [_RegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(_MainView);
    }];
    
    [_RegisterView changeType:_MainLoginType];
}

#pragma mark - 个人用户
- (IBAction)PersonClick:(UIButton *)sender {
    if (_MainLoginType == loginType_Person) {
        return;
    }
    [self.view endEditing:YES];
    
    
    [UIView animateWithDuration:0.38 animations:^{
        
        _ChooseLine.center = CGPointMake(_PersonView.center.x, _ChooseLine.center.y);
        _EnterpriseView.alpha = 0.5;
        _PersonView.alpha = 1.0;
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        _MainLoginType = loginType_Person;
        
        //登录
        [_LoginView changeType:_MainLoginType];
        //注册
        [_RegisterView changeType:_MainLoginType];
    }];
    
}

#pragma mark - 企业用户
- (IBAction)EnterpriseClick:(UIButton *)sender {
    if (_MainLoginType == loginType_Enterprise) {
        return;
    }
    [self.view endEditing:YES];
    
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.38 animations:^{
        
        _ChooseLine.center = CGPointMake(_EnterpriseView.center.x, _ChooseLine.center.y);
        _PersonView.alpha = 0.5;
        _EnterpriseView.alpha = 1.0;
        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        _MainLoginType = loginType_Enterprise;
        
        //登录
        [_LoginView changeType:_MainLoginType];
        
        if (_RegisterView) {
            //注册
            [_RegisterView changeType:_MainLoginType];
        }
    }];
    
}

#pragma mark - 随便看看
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        [_LoginView removeFromSuperview];
        _LoginView = nil; ;
        
        [_RegisterView removeFromSuperview];
        _RegisterView = nil;
    }];
    
}

#pragma mark - 注册
- (void)goRegister{
    
    if (!_RegisterView) {
        [self SetUpRegisterView];
        
    }else{
      
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
            
            _RegisterView.alpha = 1;
            
        } completion:nil];
    }
}


#pragma mark - 已有账号登录

- (void)noRegister{
    
    __weak RegisterView * WeakRegisterView = _RegisterView;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        WeakRegisterView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [WeakRegisterView clear];
    }];
}

#pragma mark - 忘记密码
-(void)forgotPassword{
    UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ResetPasswordViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"ResetPasswordView"]; 
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma  mark - 拨打企业注册电话
- (void)callPhone{
    
    if (IS_IOS10LATER) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]] options:@{} completionHandler:nil];
        
    }else  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
     
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
        
        _TopH.constant = -20;
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
        
        _TopH.constant = -20 - CGRectGetHeight(_keyboardFrame) / 2;
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
