//
//  loginView.m
//  IPOAsk
//
//  Created by adminMac on 2018/1/30.
//  Copyright © 2018年 law. All rights reserved.
//

#import "loginView.h"
#import "TextFieldViews.h"

@interface loginView()

@property (nonatomic,strong)UIView *PersonView;

@property (nonatomic,assign)loginType LoginType;

@property (nonatomic,strong)TextFieldViews *NameView;

@property (nonatomic,strong)TextFieldViews *PasswordView;

@property (nonatomic,strong)UIButton       *loginBtn;


@property (nonatomic,strong)void (^(ClickBlock))(btnType tag,NSString *userName,NSString *Password);

@end

@implementation loginView

-(instancetype)initWithAction:(void (^)(btnType, NSString *, NSString *))block{
    self = [super init];
   
    if (self) {
        _ClickBlock = block;
    
        [NOTIFICATIONCENTER addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
        
        [self setUpViews];
        
    }
    return self;
}

 
- (void)setUpViews{

    _PersonView = [[UIView alloc]init];
    [self addSubview:_PersonView];
    
    
    _NameView = [[TextFieldViews alloc]init];
    [_NameView textFieldPlaceholder:@"手机号" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:NO Height:74];
    [_PersonView addSubview:_NameView];
    
    [_NameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_PersonView.mas_left).offset(40);
        make.right.mas_equalTo(_PersonView.mas_right).offset(-40);
        make.top.mas_equalTo(_PersonView.mas_top);
        make.height.mas_equalTo(@74);
    }];
    
    _PasswordView = [[TextFieldViews alloc]init];
    [_PasswordView textFieldPlaceholder:@"请输入登录密码" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:YES Height:74]; 
    [_PersonView addSubview:_PasswordView];
    
    [_PasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_NameView.mas_bottom);
        make.left.mas_equalTo(_NameView.mas_left);
        make.right.mas_equalTo(_NameView.mas_right);
        make.height.mas_equalTo(@74);
    }];
    
    
    
    [_PersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.and.bottom.right.mas_equalTo(self);
       
    }];
    
  
    for (NSInteger i = 0 ; i < 4 ; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        
        if (i == btnType_login - 100) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor lightGrayColor]];
            [btn setTitle:@"登录" forState:UIControlStateNormal];
            _loginBtn = btn;
            
            //登录
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.top.mas_equalTo(_PasswordView.mas_bottom).offset(52);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 50));
            }];
            
        }else if (i == btnType_forgot - 100 || i == btnType_pass - 100){
            [btn setTitleColor:HEX_RGB_COLOR(0x969CA1) forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
            
            if (i == btnType_forgot - 100) {
                [btn setTitle:@"忘记密码?" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                 //忘记密码
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.top.mas_equalTo(_loginBtn.mas_bottom).offset(16);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 50));
                }];
                
            }else{
                [btn setTitle:@"随便看看" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                //随便看看
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self).offset(40);
                    make.bottom.mas_equalTo(self.mas_bottom).offset(-40);
                }];
            }
            
            
        }else if (i == btnType_register - 100){
            [btn setTitleColor:HEX_RGB_COLOR(0x0b98f2) forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:@"新用户注册" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            
            //新用户注册
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-40);
                make.bottom.mas_equalTo(self.mas_bottom).offset(-40);
            }];
        }
        
    }
}

#pragma mark - 按钮点击事件
- (void)btnClick:(UIButton *)sender{
 
    _ClickBlock(sender.tag,[_NameView text],[_PasswordView text]);
    
}

-(void)changeType:(loginType)type{
    _LoginType = type;
    
    if (_LoginType == loginType_Person) {
        [_NameView changePlaceholderText:@"请输入个人用户名"];
        
    }else if (_LoginType == loginType_Enterprise){
        [_NameView changePlaceholderText:@"用户名或邮箱"];
    }
    
    [_NameView clearText];
    [_PasswordView clearText];
   
    [self textFieldChanged];
}

- (void)textFieldChanged
{
    //判断登录可点击
    if ([self.NameView text].length > 0 && [self.PasswordView text].length > 0) {
        [_loginBtn setBackgroundColor:[UIColor blackColor]];
        _loginBtn.userInteractionEnabled = YES;
        
    } else {
        [_loginBtn setBackgroundColor:[UIColor lightGrayColor]];
        _loginBtn.userInteractionEnabled = NO;
         
    }
}
@end
