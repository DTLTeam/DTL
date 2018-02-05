//
//  RegisterView.m
//  IPOAsk
//
//  Created by adminMac on 2018/1/31.
//  Copyright © 2018年 law. All rights reserved.
//

#import "RegisterView.h"
#import "TextFieldViews.h"
#import "loginEnterpriseRegisterView.h"

@interface RegisterView()
 
@property (nonatomic,strong)loginEnterpriseRegisterView *LoginEnterpriseRegisterView;

@property (nonatomic,assign)loginType LoginType;

@property (nonatomic,strong)TextFieldViews *PhoneView;

@property (nonatomic,strong)TextFieldViews *CodeView;

@property (nonatomic,strong)TextFieldViews *PasswordView;

@property (nonatomic,strong)NSTimer *countDownTimer;

@property (nonatomic,assign)int     count;

@property (nonatomic,strong)UIButton *CodeBtn;

@property (nonatomic,strong)UIButton *SecurityBtn;

@property (nonatomic,strong)UIButton *RegisterBtn;

@property (nonatomic,strong)UIButton *LoginBtn;


@property (nonatomic,strong)void (^(ClickBlock))(RegisterbtnType type,NSString *phone,NSString *Password,NSString *Code);

@end


@implementation RegisterView

-(instancetype)initWithAction:(void (^)(RegisterbtnType, NSString *, NSString *, NSString *))block{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _LoginType = loginType_Person;
        
        [NOTIFICATIONCENTER addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        
        _ClickBlock = block;
        
        [self setUpViews];
        
    }
    return self;
}

 

- (void)setUpViews{
    
    //手机号
    _PhoneView = [[TextFieldViews alloc]init];
    [_PhoneView textFieldPlaceholder:@"手机号" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:NO Height:74];
    [self addSubview:_PhoneView];
    
    [_PhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(40);
        make.right.mas_equalTo(self.mas_right).offset(-40);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(SCREEN_HEIGHT >= 667 ? @74 : @60);
    }];
    
    
    //验证码
    _CodeView = [[TextFieldViews alloc]init];
    [_CodeView textFieldPlaceholder:@"验证码" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:YES Height:74];
    [self addSubview:_CodeView];
    
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
    _CodeBtn.tag = RegisterbtnType_Code;
    [self addSubview:_CodeBtn];
    
    [_CodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_CodeView.mas_right);
        make.bottom.mas_equalTo(_CodeView.mas_bottom);
    }];
    
    
    
    //密码
    _PasswordView = [[TextFieldViews alloc]init];
    [_PasswordView textFieldPlaceholder:@"设置密码" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:YES Height:74];
    [self addSubview:_PasswordView];
    
    [_PasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_CodeView.mas_bottom);
        make.left.mas_equalTo(_CodeView.mas_left);
        make.right.mas_equalTo(_CodeView.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT >= 667 ? @74 : @60);
    }];
    
    //是否显示密码
    _SecurityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SecurityBtn setImage:[UIImage imageNamed:@"不显示密码"] forState:UIControlStateNormal];
    [_SecurityBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _SecurityBtn.tag = RegisterbtnType_Security;
    [self addSubview:_SecurityBtn];
    
    [_SecurityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_PasswordView.mas_right);
        make.bottom.mas_equalTo(_PasswordView.mas_bottom).offset(-3);
    }];
    
    //提示
    UILabel *label = [[UILabel alloc]init];
    label.text = @"字母和数字组合，8-20位之间";
    label.textColor = HEX_RGB_COLOR(0xff443b);
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_PasswordView.mas_bottom);
        make.left.mas_equalTo(_PasswordView.mas_left);
        make.right.mas_equalTo(_PasswordView.mas_right);
        make.height.mas_equalTo(@30);
    }];
    
    
    //注册按钮
    _RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_RegisterBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_RegisterBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _RegisterBtn.tag = RegisterbtnType_Register;
    _RegisterBtn.layer.cornerRadius = 5;
    _RegisterBtn.layer.masksToBounds = YES;
    [self addSubview:_RegisterBtn];
    
    [_RegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(412 / 2, SCREEN_HEIGHT >= 667 ? 44 : 34));
        make.top.mas_equalTo(label.mas_bottom).offset(SCREEN_HEIGHT >= 667 ? 36 : 20);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    
    //登录按钮
    _LoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_LoginBtn setTitle:@"已有账号登录" forState:UIControlStateNormal];
    [_LoginBtn setTitleColor:HEX_RGB_COLOR(0x0b98f2) forState:UIControlStateNormal];
    [_LoginBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _LoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _LoginBtn.tag = RegisterbtnType_Login;
    [self addSubview:_LoginBtn];
    
    [_LoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_PasswordView.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-29); 
    }];
    
    //协议
    UIButton * AgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [AgreementBtn setTitle:@"证金快答隐私政策协议" forState:UIControlStateNormal];
    [AgreementBtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    [AgreementBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    AgreementBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    AgreementBtn.tag = RegisterbtnType_Agreement;
    [self addSubview:AgreementBtn];
    
    [AgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_PasswordView.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-29);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor  = HEX_RGB_COLOR(0x969ca1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(AgreementBtn);
        make.height.equalTo(@0.5);
    }];
}


#pragma mark  - 点击事件
- (void)BtnClick:(UIButton *)sender{
    
    
    if (sender.tag == RegisterbtnType_Code) {
        //获取验证码
        _count = 60;
        
        if (!_countDownTimer) {
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:sender repeats:YES];
        }
        //验证码倒数计时
        [sender setTitle:[NSString stringWithFormat:@"%i秒", _count] forState:UIControlStateDisabled];
        [sender setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
        sender.enabled = NO;
        
    } else if (sender.tag == RegisterbtnType_Security){
        [_PasswordView changeSecureTextEntry:sender.selected];
        sender.selected = !sender.selected;
        
        [_SecurityBtn setImage:sender.selected ? [UIImage imageNamed:@"显示密码"] : [UIImage imageNamed:@"不显示密码"] forState:UIControlStateNormal];
    }
    
    _ClickBlock(sender.tag,[_PhoneView text],[_PasswordView text],[_CodeView text]);
}

- (void)clear{
    
    //还原
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    _count = 60;
    [_CodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_CodeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
    [_CodeBtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    _CodeBtn.enabled = NO;
    
    [_PhoneView clearText];
    [_CodeView clearText];
    [_PasswordView clearText];
    
    [self endEditing:YES];
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

#pragma mark - 切换个人用户/企业用户
-(void)changeType:(loginType)type{
    if (_LoginType == type) {
        return;
    }
    
    _LoginType = type;
    
    if (type == loginType_Person) {
        //个人用户
    }else if (type == loginType_Enterprise){
        //企业用户
        if (!_LoginEnterpriseRegisterView) {
            _LoginEnterpriseRegisterView = [[NSBundle mainBundle] loadNibNamed:@"loginEnterpriseRegisterView" owner:self options:nil][0];
            _LoginEnterpriseRegisterView.backgroundColor = [UIColor whiteColor];
            _LoginEnterpriseRegisterView.alpha = 0;
            [self addSubview:_LoginEnterpriseRegisterView];
            
            [_LoginEnterpriseRegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.top.and.right.and.bottom.mas_equalTo(self); 
            }];
            
            __weak RegisterView *WeakView = self;
            _LoginEnterpriseRegisterView.loginClickBlock = ^(UIButton *sender) {
                //点击登录
                WeakView.ClickBlock(RegisterbtnType_Login,@"",@"",@""); 
            } ;
        }
    }
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _LoginEnterpriseRegisterView.alpha = _LoginType == loginType_Enterprise ? 1 : 0;
      
        [self layoutIfNeeded];
        
    }completion:nil];
    
}

- (void)textFieldChanged:(id)sender
{
    [self refreshbtn];
    
    
    //判断注册可点击
    if ([self.PhoneView text].length > 0 && [self.CodeView text].length > 0 && [self.PasswordView text].length > 0 ) {
        _RegisterBtn.userInteractionEnabled = YES;
        [_RegisterBtn setBackgroundColor:HEX_RGB_COLOR(0x0b98f2)];
        
    } else {
        _RegisterBtn.userInteractionEnabled = NO;
        [_RegisterBtn setBackgroundColor:HEX_RGB_COLOR(0x969ca1)];
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

@end
