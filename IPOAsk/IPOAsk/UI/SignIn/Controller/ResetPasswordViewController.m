//
//  ResetPasswordViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SignInViewController.h"


#import "TextFieldViews.h" 

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet TextFieldViews *password1;
 
@property (weak, nonatomic) IBOutlet TextFieldViews *password2;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"重置密码";
    
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
   
    [_password1 textFieldPlaceholder:@"新密码" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:NO Height:88];
    [_password2 textFieldPlaceholder:@"确认密码" KeyboardType:UIKeyboardTypeDefault SecureTextEntry:NO Height:88];
    
}


#pragma mark - 重置密码
- (IBAction)ResetPassword:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([_password1 text].length == 0 && [_password2 text].length == 0) {
        [self.view endEditing:YES];
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请输入重置密码!" viewtag:100 AfterDelay:3];
        return;
    }
    
    if (![[_password1 text] isEqualToString:[_password2 text]] && ([_password1 text].length > 0 || [_password2 text].length > 0)) {
        NSLog(@"不一致");
        [self.view endEditing:YES];
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"两次密码不一致!" viewtag:100 AfterDelay:3];
        
    }else{
        
        if (![self returnTruePassword:[_password1 text]] ) {
            
            [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"字母和数字组合，8-20位之间！" viewtag:1 AfterDelay:3];
            return;
        }
        
        //上传接口 成功 返回
        __weak ResetPasswordViewController *WeakSelf = self;
        [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:@{@"cmd":@"resetPassword",@"phone":WeakSelf.phone,@"password":[UtilsCommon md5WithString:_password1.text]} backData:NetSessionResponseTypeJSON success:^(id response) {
            GCD_MAIN(^{
                NSString *msg = @"修改成功";
                if ([response[@"status"] intValue] == 1) {
//                    UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    ResetPasswordViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"ResetPasswordView"];
//                    [WeakSelf.navigationController pushViewController:VC animated:YES];
                    
                    [WeakSelf performSelector:@selector(returnBack) withObject:nil afterDelay:1.0];
                    
                }else
                {
                    msg = @"修改失败";
                }
                
                [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:2 AfterDelay:1.0];
                
                
            });
        } requestHead:nil faile:^(NSError *error) {
            GCD_MAIN(^{
                [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"修改失败" viewtag:2 AfterDelay:1.0];
            });
        }];

    }
}
#pragma mark -触摸空白地方隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

-(void)returnBack{
    
        static BOOL haveController;
        haveController = NO;

        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[SignInViewController class]]) {
                haveController = YES;

                self.navigationController.navigationBar.hidden = YES;
                self.navigationController.navigationBar.translucent = YES;
                [self.navigationController popToViewController:controller animated:YES];
            }
        }

        if (!haveController) {
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
