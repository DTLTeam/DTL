//
//  SendPhoneCodeViewController.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/6.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SendPhoneCodeViewController.h"
#import "ResetPasswordViewController.h"

#import "TextFieldViews.h"

@interface SendPhoneCodeViewController ()


@property (nonatomic,strong)TextFieldViews *PhoneView;

@property (nonatomic,strong)TextFieldViews *CodeView;

@property (nonatomic,strong)UIButton *CodeBtn;

@property (nonatomic,strong)UIButton *ResetBtn;

@property (nonatomic,assign)int     count;

@property (nonatomic,strong)NSTimer *countDownTimer;

@end

@implementation SendPhoneCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    [self setUpNav];
    
    [self setUpViews];
    
}

- (void)setUpNav{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"发送验证";
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"back" bgimage:nil  Title:@"" SelectedTitle:@" " titleFont:12 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(back)];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -14;
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftBtn];
    
    //占位 防止左边按钮偏移
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *rightBtn = [UIBarButtonItem returnTabBarItemWithBtn:rbtn image:@"" bgimage:nil  Title:@"占" SelectedTitle:@""  titleFont:1 itemtype:Itemtype_rigth SystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn];
    [rbtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
}

- (void)setUpViews{
    //手机号
    _PhoneView = [[TextFieldViews alloc]init];
    [_PhoneView textFieldPlaceholder:@"手机号" KeyboardType:UIKeyboardTypeNumberPad SecureTextEntry:NO Height:74];
    [self.view addSubview:_PhoneView];
    
    [_PhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(SCREEN_HEIGHT >= 667 ? @74 : @60);
    }];
    
    
    //验证码
    _CodeView = [[TextFieldViews alloc]init];
    [_CodeView textFieldPlaceholder:@"验证码" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:NO Height:74];
    [self.view addSubview:_CodeView];
    
    [_CodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_PhoneView.mas_bottom);
        make.left.mas_equalTo(_PhoneView.mas_left);
        make.right.mas_equalTo(_PhoneView.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT >= 667 ? @74 : @60);
    }];
    
    //获取验证码
    _CodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_CodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_CodeBtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    _CodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_CodeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _CodeBtn.enabled = NO; 
    [self.view addSubview:_CodeBtn];
    
    [_CodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_CodeView.mas_right);
        make.bottom.mas_equalTo(_CodeView.mas_bottom);
    }];
    
    //注册按钮
    _ResetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ResetBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [_ResetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ResetBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_ResetBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _ResetBtn.tag = 100;
    _ResetBtn.layer.cornerRadius = 5;
    _ResetBtn.layer.masksToBounds = YES;
    _ResetBtn.userInteractionEnabled = NO;
    [self.view addSubview:_ResetBtn];
    
    [_ResetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(412 / 2, SCREEN_HEIGHT >= 667 ? 44 : 34));
        make.top.mas_equalTo(_CodeView.mas_bottom).offset(SCREEN_HEIGHT >= 667 ? 36 : 20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

#pragma mark  - 点击事件
- (void)BtnClick:(UIButton *)sender{
    
    __weak SendPhoneCodeViewController *WeakSelf = self;
    __weak UIButton *weakBtn = sender;
    
    if (sender.tag == 100) {
       
        if ([[UtilsCommon validPhoneNum:[_PhoneView text]] isEqualToString:@""]) {
            GCD_MAIN(^{
                [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请输入正确的手机号" viewtag:1 AfterDelay:3];
            });
            return;
        }
        
        //重置密码
        [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:@{@"cmd":@"checkCode",@"phone":_PhoneView.text,@"verificationCode":_CodeView.text} backData:NetSessionResponseTypeJSON success:^(id response) {
            if ([response[@"status"] intValue] == 1) {
                GCD_MAIN(^{
                    UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ResetPasswordViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"ResetPasswordView"];
                    VC.phone = self.PhoneView.text;
                    [WeakSelf.navigationController pushViewController:VC animated:YES];
                });
            }else{
                GCD_MAIN(^{
                    [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:response[@"msg"] viewtag:2 AfterDelay:3];
                });
            }
        } requestHead:nil faile:^(NSError *error) {
            GCD_MAIN(^{
                [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"验证失败" viewtag:2 AfterDelay:3];
            });
        }];
        
        return;
    }
    
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:@{@"cmd":@"getVerificationCode",@"phone":_PhoneView.text} backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            if ([response[@"status"] integerValue] == 0) {
                NSString *msg = response[@"msg"];
                [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:2 AfterDelay:3];
            }
            return ;
            
            //获取验证码成功
            WeakSelf.count = 60;
            
            if (!_countDownTimer) {
                _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:sender repeats:YES];
            }
            //验证码倒数计时
            [weakBtn setTitle:[NSString stringWithFormat:@"%i秒", WeakSelf.count] forState:UIControlStateDisabled];
            [weakBtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
            weakBtn.enabled = NO;
        })); 
        
        
    } requestHead:nil faile:^(NSError *error) {
        GCD_MAIN(^{
            [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"获取验证码失败" viewtag:2 AfterDelay:3];
        });
    }];
}


#pragma mark - 倒计时
- (void)timeFireMethod:(NSTimer*)timer{
    
    UIButton *sender = (UIButton *)timer.userInfo;
    
    if (_count == 0) {
        if ([UtilsCommon validPhoneNum:[self.PhoneView text]].length > 0) {
            sender.enabled = YES;
        }else{
            sender.enabled = NO;
        }
        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
        [sender setTitle:@"获取验证码" forState:UIControlStateDisabled];
        
        [self refreshbtn];
        
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        
    }else{
        _count--;
        [sender setTitle:[NSString stringWithFormat:@"%i秒", _count] forState:UIControlStateDisabled];
    }
}

- (void)refreshbtn{
    if ([UtilsCommon validPhoneNum:[self.PhoneView text]].length > 0 && [_CodeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
        _CodeBtn.enabled = YES;
        [_CodeBtn setTitleColor:HEX_RGB_COLOR(0x0b98f2) forState:UIControlStateNormal];
        
    }else if (!([UtilsCommon validPhoneNum:[self.PhoneView text]].length > 0) && [_CodeBtn.titleLabel.text isEqualToString:@"获取验证码"]){
        _CodeBtn.enabled = NO;
        [_CodeBtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    }
}

- (void)clear{
    
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    _count = 60;
}


- (void)textFieldChanged:(id)sender
{
    [self refreshbtn];
    
    
    //判断重置可点击 并且验证码正确！
    if ([self.PhoneView text].length > 0 && [self.CodeView text].length > 0 ) {
        _ResetBtn.userInteractionEnabled = YES;
        [_ResetBtn setBackgroundColor:HEX_RGB_COLOR(0x0b98f2)];
        
    } else {
        _ResetBtn.userInteractionEnabled = NO;
        [_ResetBtn setBackgroundColor:HEX_RGB_COLOR(0x969ca1)];
    }
}


#pragma mark - 返回
- (void)back{
 
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    
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
