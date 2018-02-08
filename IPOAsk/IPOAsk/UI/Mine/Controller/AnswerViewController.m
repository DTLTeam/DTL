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


@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MineTopColor;
    _answerBtn.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.title = @"申请成为答主";
    [self setUpNavBgColor:MineTopColor];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hiddenNav];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)ansterAction:(id)sender {
    
    UserDataManager *manager = [UserDataManager shareInstance];
    if (!manager.userModel) {
        return;
    }
    
    if (_nameTextField.text.length > 0 && _companyTextField.text.length > 0 && _jobTextField.text.length > 0 && _experienceTextView.text.length > 0) {
        
        __weak AnswerViewController *WeakSelf = self;
        [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"applyAnswerer",@"userID":manager.userModel.userID,@"realName":_nameTextField.text,@"company":@"_companyTextField.text",@"jobTitle":_jobTextField.text,@"experience":_experienceTextView.text} backData:NetSessionResponseTypeJSON success:^(id response) {
            GCD_MAIN(^{
                NSString *msg = @"申请成功";
                if ([response[@"status"] intValue] == 1) {
                    [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:2 AfterDelay:3];
                    [USER_DEFAULT setBool:YES forKey:manager.userModel.userID];
                    [USER_DEFAULT synchronize];
                    [WeakSelf.navigationController popViewControllerAnimated:YES];
                }else
                {
                    msg = response[@"msg"];
                    [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:2 AfterDelay:3];
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

@end
