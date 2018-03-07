//
//  SignInViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SignInViewController.h"
#import "SendPhoneCodeViewController.h"

#import "loginView.h"
#import "RegisterView.h"

#import "UserDataManager.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UIView *TopViews;
@property (weak, nonatomic) IBOutlet UIImageView *UserHead;

@property (nonatomic,assign)CGFloat  defaultTopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopHeight;
@property (nonatomic,assign)CGRect keyboardFrame;

@property (weak, nonatomic) IBOutlet UIView *ChooseLine;
@property (weak, nonatomic) IBOutlet UIView *PersonView;
@property (weak, nonatomic) IBOutlet UIView *EnterpriseView; 


@property (nonatomic,strong)UIView          *MainView;
@property (nonatomic,strong)loginView       *LoginView;
@property (nonatomic,strong)RegisterView    *RegisterView;


@property (nonatomic,assign)loginType MainLoginType;


@end


@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _MainLoginType = loginType_Person;  //弹出默认个人登录
    
    _UserHead.layer.cornerRadius = CGRectGetHeight(_UserHead.frame) / 2;
    _UserHead.layer.masksToBounds = YES;
    
    [self setUpLoginView];
    
    if (SCREEN_HEIGHT < 667 ) {
        _TopH.constant -= 20;
    }else if (IS_IPHONE_X){
        _TopH.constant -= 24;
        _TopHeight.constant += 24;
    }
    self.navigationController.navigationBar.hidden = YES;
    
    _defaultTopH = _TopH.constant;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //test 
//    [self goLogin:@"18611111111" pwd:@"aa123456"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.view endEditing:YES];
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
                if ([[UtilsCommon validPhoneNum:userName] isEqualToString:@""] && WeakSelf.MainLoginType == loginType_Person) {
                    GCD_MAIN(^{
                        [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"请输入正确的手机号" viewtag:1 AfterDelay:3];
                    });
//                    return;
                }
                if (![UtilsCommon isValidateEmail:userName] && [[UtilsCommon validPhoneNum:userName] isEqualToString:@""] && WeakSelf.MainLoginType == loginType_Enterprise) {
                    GCD_MAIN(^{
                        [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"请输入正确的邮箱号或手机号" viewtag:1 AfterDelay:3];
                    });
//                    return;
                }
                [WeakSelf goLogin:userName pwd:Password];
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
                [WeakSelf registerAciton:phone pwd:Password phoneCode:Code];
                break;
            case RegisterbtnType_Agreement://协议
                
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
    
    
//    [self.view layoutIfNeeded];
    
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

#pragma mark - 登录
- (void)goLogin:(NSString *)phone pwd:(NSString *)pwd
{
    __weak typeof(self) weakSelf = self;
    [AskProgressHUD AskShowInView:self.view viewtag:1];
    
    [[UserDataManager shareInstance] signInWithAccount:phone password:pwd complated:^(BOOL isSignInSuccess, NSString *message) {
        
        if (isSignInSuccess) {
            
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"登录成功" viewtag:1 AfterDelay:1.5];
            [weakSelf dismiss];
            
        } else {
            
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:message viewtag:1 AfterDelay:1.5];
            
        }
        
    } networkError:^(NSError *error) {
       
        [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:1 AfterDelay:0];
        [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"登录失败" viewtag:1 AfterDelay:1.5];
        
    }];
    
}

#pragma mark - 前往注册
- (void)goRegister{
    
    if (!_RegisterView) {
        [self SetUpRegisterView];
        
    } 
    [_RegisterView changeType:_MainLoginType];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        
        _RegisterView.alpha = 1;
        
    } completion:nil];

}

#pragma mark - 注册
- (void)registerAciton:(NSString *)phone pwd:(NSString *)pwd phoneCode:(NSString *)code
{
    if (![self returnTruePassword:pwd]) {
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"密码格式不正确！" viewtag:1 AfterDelay:3];
        return;
    }
    __weak SignInViewController *WeakSelf = self;
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:@{@"cmd":@"register",@"phone":phone,@"password":[UtilsCommon md5WithString:pwd],@"verificationCode":code,@"userType":@"1"} backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN(^{
            NSString *msg = @"注册失败";
            if ([response[@"status"] intValue] == 1) {
                msg = @"注册成功,请重新登录";
                [WeakSelf noRegister];
            }else
            {
                NSString *result = response[@"msg"];
                if (result) {
                    msg = result;
                }
            }

            [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:1 AfterDelay:3];
            
        });
        
    } requestHead:nil faile:^(NSError *error) {
        GCD_MAIN(^{
            [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"注册失败" viewtag:1 AfterDelay:3];
        });
    }];
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
    SendPhoneCodeViewController *Vc = [[SendPhoneCodeViewController alloc]init];
    [self.navigationController pushViewController:Vc animated:YES];
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
        
        _TopH.constant = _defaultTopH;
        
        [self.view layoutIfNeeded];
        
        if (_MainLoginType == loginType_Enterprise) {
            
            _ChooseLine.center = CGPointMake(_EnterpriseView.center.x, _ChooseLine.center.y);
        }else{
            _ChooseLine.center = CGPointMake(_PersonView.center.x, _ChooseLine.center.y);
        }
    }];
    
}

#pragma mark -键盘显示时弹出评论工具栏
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    _keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.38 animations:^{
        
        _TopH.constant = _defaultTopH - CGRectGetHeight(_keyboardFrame) / 2;
        [self.view layoutIfNeeded];
        
        if (_MainLoginType == loginType_Enterprise) {
            
            _ChooseLine.center = CGPointMake(_EnterpriseView.center.x, _ChooseLine.center.y);
        }else{
            _ChooseLine.center = CGPointMake(_PersonView.center.x, _ChooseLine.center.y);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)returnTruePassword:(NSString *)password{
    
    
    //包含条件
    NSRegularExpression *number = [[NSRegularExpression alloc]
                                              initWithPattern:@"[0-9]"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    if ( [number numberOfMatchesInString:password
                                            options:NSMatchingReportProgress
                                              range:NSMakeRange(0, password.length)] > 0 && password.length >= 8 && password.length <= 20) {
        
        //包含字母
        NSRegularExpression *Expression = [[NSRegularExpression alloc]
                                                  initWithPattern:@"[A-Za-z]"
                                                  options:NSRegularExpressionCaseInsensitive
                                                  error:nil];;
        
        if ( [Expression numberOfMatchesInString:password
                                                options:NSMatchingReportProgress
                                                  range:NSMakeRange(0, password.length)] > 0) {
            
            return YES;
        }
        
        
        return NO;
    }return NO;
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
