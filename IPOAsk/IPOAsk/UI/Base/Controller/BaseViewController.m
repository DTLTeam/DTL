//
//  BaseViewController.m
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.navigationItem) {
        [self.navigationItem setHidesBackButton:YES];
    }
    
    if (!IS_IOS11LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpNavBgColor:(UIColor *)color RightBtn:(void (^)(UIButton *))rightbtn{
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"back" bgimage:nil  Title:@"" SelectedTitle:@" " titleFont:12 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(back)];
    [lbtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -14;
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftBtn];
    
    
    //占位 防止左边按钮偏移
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *rightBtn = [UIBarButtonItem returnTabBarItemWithBtn:rbtn image:@"" bgimage:nil  Title:@"占" SelectedTitle:@""  titleFont:1 itemtype:Itemtype_rigth SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(RightClick)];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn];
    [rbtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn];
    rbtn.tag = 2002;
    
    if (color) {
        [self.navigationController.navigationBar setShadowImage:[UtilsCommon createImageWithColor:HEX_RGB_COLOR(0xE9E9E9)]];
        self.navigationController.navigationBar.shadowImage = [UtilsCommon createImageWithColor:HEX_RGB_COLOR(0xE9E9E9)];
        self.navigationController.view.backgroundColor = color;
        self.view.backgroundColor = color;
    }
    
    if (rightbtn) {
        rightbtn(rbtn);
    }
}


- (void)showNavBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)hiddenNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)showSearchNavBar {
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        [(BaseNavigationController *)self.navigationController showSearchNavBar:YES];
    }
}

- (void)hiddenSearchNavBar {
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        [(BaseNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RightClick{
    
}

- (void)setUpBgViewWithTitle:(NSString *)title Image:(NSString *)Img Action:(SEL)action{
    
    //无数据背景图
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.hidden = YES;
    [self.view addSubview:_bgImageView];
    
    UIControl *control = [[UIControl alloc]initWithFrame:_bgImageView.frame];
    [control addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [_bgImageView addSubview:control];
    
    UILabel *label = [[UILabel alloc]init];
    label.tag = 2000;
    [self.bgImageView addSubview:label];
    label.text = title;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.bgImageView.mas_centerX);
        make.centerY.mas_equalTo(self.bgImageView.mas_centerY).offset(30);
    }];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:Img]];
    [self.bgImageView addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(label.mas_centerX).offset(30);
        make.bottom.mas_equalTo(label.mas_top).offset(-30);
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIContainerViewControllerCallbacks

- (void)willMoveToParentViewController:(UIViewController *)parent {
    DLog(@"------- willMove vc class : %@", NSStringFromClass([parent class]));
    
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    DLog(@"------- didMove vc class : %@", NSStringFromClass([parent class]));
    
    [super didMoveToParentViewController:parent];
    
    if (parent && [parent isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *nav = (UINavigationController *)parent;
        UIViewController *vc = nav.viewControllers.lastObject;
        [vc viewWillAppear:YES];
        
    }
    
}

@end
