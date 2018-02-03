//
//  EditQuestionViewController.m
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EditQuestionViewController.h"

@interface EditQuestionViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomH;

@property (nonatomic,assign)CGFloat defBottomH;

@property (nonatomic,assign)CGRect keyboardFrame;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIView *ChooseClick; 

@property (weak, nonatomic) IBOutlet UILabel *Title1;
@property (weak, nonatomic) IBOutlet UIButton *Title2;
@property (weak, nonatomic) IBOutlet UIView *Title2Line;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;

@property (weak, nonatomic) IBOutlet UITextField *question;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextH;

@end

@implementation EditQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUpNav];
    
    [self setUpGradient];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];
 
}

-(void)UserType:(AnswerType)type NavTitle:(NSString *)title{
    
    if (type == AnswerType_AskQuestionEnterprise) {
        //企业提问
        _Title1.hidden = YES;
        _Title2.hidden = YES;
        _anonymousBtn.hidden = YES;
        
    }else if (type == AnswerType_AskQuestionPerson){
        //个人提问
        _Title1.hidden = NO;
        _Title2.hidden = NO;
        
    }else if (type == AnswerType_Answer){
        //个人回答问题
        _Title1.hidden = YES;
        _Title2.hidden = YES;
        _TextH.constant = _TextH.constant - CGRectGetMaxY(_line.frame) + 18 + 10;
        _question.hidden = YES;
        _line.hidden = YES;
    }
    
    _Title2Line.hidden = _Title2.hidden;
    
    self.title = title;
}
- (void)setUpNav{
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"" bgimage:nil  Title:@"取消" SelectedTitle:@" " titleFont:16 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(back)];
    [lbtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -14;
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftBtn];
    
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *rightBtn = [UIBarButtonItem returnTabBarItemWithBtn:rbtn image:@"" bgimage:nil  Title:@"发布" SelectedTitle:@""  titleFont:16 itemtype:Itemtype_rigth SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(SendOut)];
    [rbtn setTitleColor:HEX_RGB_COLOR(0x0b98f2) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn]; 
    
}

- (void)setUpGradient{
 
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _BottomView.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [_BottomView.layer setMask:gradientLayer];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发布
- (void)SendOut{
    
    
    //发布成功
    [self back];
}

#pragma mark - 联系我们
- (IBAction)Call:(UIButton *)sender {
    
    if (IS_IOS10LATER) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]] options:@{} completionHandler:nil];
        
    }else  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
    
}

#pragma mark - 匿名发布按钮
- (IBAction)HiddenName:(UIButton *)sender {
    sender.selected = !sender.selected;
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
        
        _BottomH.constant = _defBottomH;
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
        
        if (!IS_IPHONE_X) {
            
            _BottomH.constant = CGRectGetHeight(_keyboardFrame) + _defBottomH ;
        }else{
            
            _BottomH.constant = CGRectGetHeight(_keyboardFrame) + _defBottomH - 24;
        }
        
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
