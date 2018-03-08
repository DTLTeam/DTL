//
//  AnswerViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AnswerViewController.h"

#import "UserDataManager.h"

@interface AnswerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (weak, nonatomic) IBOutlet UITextView *experienceTextView;

@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopViewH;

@property (assign, nonatomic) AnswerCellType Select;
@property (assign, nonatomic) CGFloat tableViewHeight;
@property (assign, nonatomic) CGFloat keyboardHeight;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"申请成为答主";
    
    self.view.backgroundColor = MineTopColor;
    _answerBtn.layer.cornerRadius = 3;
    _tableViewHeight = SCREEN_HEIGHT;
    
    [self setUpNavBgColor:nil RightBtn:nil];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        [(BaseNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [NOTIFICATIONCENTER removeObserver:self];
}


- (IBAction)ansterAction:(id)sender {
    
    UserDataManager *manager = [UserDataManager shareInstance];
    if (!manager.userModel) {
        return;
    }
    
    if (_nameTextField.text.length > 0 && _companyTextField.text.length > 0 && _jobTextField.text.length > 0 && _experienceTextView.text.length > 0) {
        
        __weak AnswerViewController *WeakSelf = self;
        [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:@{@"cmd":@"applyAnswerer",@"userID":manager.userModel.userID,@"realName":_nameTextField.text,@"company":@"_companyTextField.text",@"jobTitle":_jobTextField.text,@"experience":_experienceTextView.text} backData:NetSessionResponseTypeJSON success:^(id response) {
            GCD_MAIN(^{
                NSString *msg = @"申请成功";
                if ([response[@"status"] intValue] == 1) {
                    [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:2 AfterDelay:3];
                    [USER_DEFAULT setBool:YES forKey:manager.userModel.userID];
                    [USER_DEFAULT synchronize];
                    
                    [WeakSelf performSelector:@selector(popController) withObject:nil afterDelay:3.0]; 
                }else
                {
                    msg = response[@"msg"];
                    [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:2 AfterDelay:3];
                    
                    if ([msg containsString:@"申请中"]) {
                        [USER_DEFAULT setBool:YES forKey:manager.userModel.userID];
                        [USER_DEFAULT synchronize];
                        
                        [WeakSelf performSelector:@selector(popController) withObject:nil afterDelay:3.0];
                    }
                }
                
            });
        } requestHead:nil faile:^(NSError *error) {
            GCD_MAIN(^{
                [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"申请失败" viewtag:2 AfterDelay:3];
            });
        }];
    }
}

- (void)popController{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    _Select = textView.tag;
    
    [self keyboardShowChangeFrame:YES];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _Select = textField.tag;
    
    if (SCREEN_HEIGHT <= 667 && (_Select == AnswerCellType_introduction || _Select == AnswerCellType_postName)) {
        [self keyboardShowChangeFrame:YES];
        
    }else [self keyboardShowChangeFrame:NO];
    
    return YES;
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
   
    [self keyboardShowChangeFrame:NO];
}

#pragma mark -键盘显示时弹出评论工具栏
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    _keyboardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height / 2 - CGRectGetHeight(_answerBtn.frame);
    
    if (_Select == AnswerCellType_introduction && SCREEN_HEIGHT <= 667) {
        
        [self keyboardShowChangeFrame:YES];
    }
}

- (void)keyboardShowChangeFrame:(BOOL)change{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.38 animations:^{
        
        if (change) {
            
            _TopViewH.constant = -_keyboardHeight;
            
        }else{
            _TopViewH.constant = 0; 
        }
        
        [self.view layoutIfNeeded];
    }];
    
    
}


@end
