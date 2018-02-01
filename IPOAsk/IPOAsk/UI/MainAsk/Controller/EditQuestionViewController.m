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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BtnBottomH;

@end

@implementation EditQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _defBottomH = _BottomH.constant;
    
    [self setUpNav];
    
    [self setUpGradient];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];
 
}

-(void)UserType:(loginType)type{
    
    if (type == loginType_Person) {
        //匿名发布
        _ChooseClick.hidden = NO;
        _BottomView.hidden = YES;
    }else if (type == loginType_Enterprise){
        //企业发布
        _ChooseClick.hidden = NO;
        _BottomView.hidden = YES;
    }
}
- (void)setUpNav{
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"" bgimage:nil  Title:@"取消" SelectedTitle:@" " titleFont:12 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(back)];
    [lbtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -14;
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftBtn];
    
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *rightBtn = [UIBarButtonItem returnTabBarItemWithBtn:rbtn image:@"" bgimage:nil  Title:@"发布" SelectedTitle:@""  titleFont:12 itemtype:Itemtype_rigth SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(SendOut)];
    [rbtn setTitleColor:HEX_RGB_COLOR(0x0b98f2) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn]; 
    
}

- (void)setUpGradient{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_BottomView addSubview:blurView];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.and.right.mas_equalTo(_BottomView);
    }];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _BottomView.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(__bridge id)[UIColor colorWithWhite:0 alpha:1].CGColor];
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

#pragma mark - 匿名发布
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
        _BtnBottomH.constant = -30;
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
        
        _BottomH.constant = CGRectGetHeight(_keyboardFrame) - 40;
        _BtnBottomH.constant = - 60;
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
