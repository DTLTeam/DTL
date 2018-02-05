//
//  MainNavigationController.m
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainNavigationController.h"

//Controller
#import "SearchViewController.h"
#import "EditQuestionViewController.h"

#define AnimatedTime 0.3

@interface MainNavigationController () <UINavigationControllerDelegate>

//参数
@property (nonatomic) BOOL isShowBack;  //显示返回按钮

//导航栏
@property (strong, nonatomic) UIView *customNavBar;

@property (strong, nonatomic) UIButton      *backBtn;
@property (strong, nonatomic) UIView        *searchBGView;
@property (strong, nonatomic) UIButton      *putQuestionBtn;

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;
    
    [self setupNavBar];
    
    [self changeShowStatus:YES];
    
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


#pragma mark - 界面

- (void)setupNavBar {
    
    _isShowBack = YES;
    self.delegate = self;
    
    UIColor *barColor = [UIColor whiteColor];
    
    UIView *statusBGBar = [[UIView alloc] init];
    statusBGBar.backgroundColor = barColor;
    [self.view addSubview:statusBGBar];
    
    _customNavBar = [[UIView alloc] init];
    _customNavBar.backgroundColor = barColor;
    [self.view addSubview:_customNavBar];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEX_RGBA_COLOR(0xE2E2E7, 1);
    [_customNavBar addSubview:line];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_customNavBar addSubview:_backBtn];
    
    _searchBGView = [[UIView alloc] init]   ;
    _searchBGView.backgroundColor = HEX_RGBA_COLOR(0xEBEBEB, 1);
    _searchBGView.layer.masksToBounds = YES;
    _searchBGView.layer.cornerRadius = 5;
    [_customNavBar addSubview:_searchBGView];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"搜索.png"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_searchBGView addSubview:imgView];
    
    _searchTextField = [[UITextField alloc] init];
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"输入关键字搜索感兴趣的问题" attributes:@{NSForegroundColorAttributeName:HEX_RGBA_COLOR(0x959A9F, 1), NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    _searchTextField.attributedPlaceholder = placeholderString;
    _searchTextField.tintColor = HEX_RGBA_COLOR(0x999999, 1);
    _searchTextField.font = [UIFont systemFontOfSize:13];
    _searchTextField.delegate = self;
    [_searchBGView addSubview:_searchTextField];
    
    _putQuestionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_putQuestionBtn setTitleColor:HEX_RGBA_COLOR(0x333333, 1) forState:UIControlStateNormal];
    [_putQuestionBtn setTitleColor:HEX_RGBA_COLOR(0x333333, 1) forState:UIControlStateHighlighted];
    _putQuestionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_putQuestionBtn setImage:[UIImage imageNamed:@"提问.png"] forState:UIControlStateNormal];
    [_putQuestionBtn setImage:[UIImage imageNamed:@"提问.png"] forState:UIControlStateHighlighted];
    [_putQuestionBtn addTarget:self action:@selector(putQuestionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_customNavBar addSubview:_putQuestionBtn];
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [statusBGBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.offset(statusBarHeight);
        }
    }];
    
    CGFloat navBarHeight = self.navigationBar.frame.size.height;
    [_customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.equalTo(self.view.mas_top).offset(statusBarHeight);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }
        make.height.offset(navBarHeight);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_customNavBar.mas_left);
        make.right.equalTo(_customNavBar.mas_right);
        make.bottom.equalTo(_customNavBar.mas_bottom);
        make.height.offset(1);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_customNavBar.mas_left).offset(10);
        make.bottom.equalTo(_customNavBar.mas_bottom).offset(-2);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
    [_searchBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backBtn.mas_right).offset(10);
        make.right.equalTo(_putQuestionBtn.mas_left).offset(-10);
        make.bottom.equalTo(_customNavBar.mas_bottom).offset(-7);
        make.height.offset(30);
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBGView.mas_top).offset(2.5);
        make.bottom.equalTo(_searchBGView.mas_bottom).offset(-2.5);
        make.left.equalTo(_searchBGView.mas_left).offset(5);
        make.width.equalTo(imgView.mas_height);
    }];
    
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(5);
        make.right.equalTo(_searchBGView.mas_right).offset(-5);
        make.top.equalTo(_searchBGView.mas_top).offset(2.5);
        make.bottom.equalTo(_searchBGView.mas_bottom).offset(-2.5);
    }];
    
    [_putQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_customNavBar.mas_right).offset(-10);
        make.bottom.equalTo(_customNavBar.mas_bottom).offset(-2);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
}


#pragma mark - 事件响应

#pragma mark 返回
- (void)backAction:(id)sender {
    
    if (self.viewControllers.count > 1) {
        
        if (_searchTextField.isEditing || _searchTextField.text.length > 0) {
            _searchTextField.text = @"";
            [self.view endEditing:YES];
        }
        
        [self popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark 发布问题
- (void)putQuestionAction:(id)sender {
    
    [self hideSearchNavBar];
    
    EditQuestionViewController *editQuestionVC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:nil options:nil].firstObject;
    [self pushViewController:editQuestionVC animated:YES];
    
}


#pragma mark - 功能

#pragma mark 显示搜索导航栏
- (void)showSearchNavBar {
    
    if (_customNavBar.hidden) {
        _customNavBar.hidden = NO;
        [self changeShowStatus:NO];
    }
    
}

#pragma mark 隐藏搜索导航栏
- (void)hideSearchNavBar {
    
    if (!_customNavBar.hidden) {
        _customNavBar.hidden = YES;
        [self changeShowStatus:NO];
    }
    
}

#pragma mark 改变显示状态
- (void)changeShowStatus:(BOOL)animated {
    
    id vc = self.viewControllers.lastObject;
    if ([vc isKindOfClass:[SearchViewController class]]) { //搜索页面
        
        if (_isShowBack) { //已显示返回按钮才需要改变布局
            _isShowBack = NO;
            
            if (animated) {
                
                _backBtn.userInteractionEnabled = NO;
                _searchTextField.userInteractionEnabled = NO;
                [UIView animateWithDuration:AnimatedTime animations:^{
                    
                    _backBtn.alpha = 0;
                    
                    CGRect frame = _searchBGView.frame;
                    frame.origin.x -= (CGRectGetWidth(_backBtn.frame) + CGRectGetMinX(_backBtn.frame));
                    frame.size.width += (CGRectGetWidth(_backBtn.frame) + CGRectGetMinX(_backBtn.frame));
                    _searchBGView.frame = frame;
                    
                } completion:^(BOOL finished) {
                    
                    [_searchBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_backBtn.mas_left);
                        make.right.equalTo(_putQuestionBtn.mas_left).offset(-10);
                        make.bottom.equalTo(_customNavBar.mas_bottom).offset(-7);
                        make.height.offset(30);
                    }];
                    _backBtn.userInteractionEnabled = YES;
                    _searchTextField.userInteractionEnabled = YES;
                    
                }];
                
            } else {
                
                _backBtn.alpha = 0;
                [_searchBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_backBtn.mas_left);
                    make.right.equalTo(_putQuestionBtn.mas_left).offset(-10);
                    make.bottom.equalTo(_customNavBar.mas_bottom).offset(-7);
                    make.height.offset(30);
                }];
                
            }
            
        }
        
        [_putQuestionBtn setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [_putQuestionBtn setImage:[[UIImage alloc] init] forState:UIControlStateHighlighted];
        [_putQuestionBtn removeTarget:self action:@selector(putQuestionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_putQuestionBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_putQuestionBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
    } else { //非搜索页面
        
        [_putQuestionBtn setTitle:@"" forState:UIControlStateNormal];
        [_putQuestionBtn removeTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_putQuestionBtn setImage:[UIImage imageNamed:@"提问.png"] forState:UIControlStateNormal];
        [_putQuestionBtn setImage:[UIImage imageNamed:@"提问.png"] forState:UIControlStateHighlighted];
        [_putQuestionBtn addTarget:self action:@selector(putQuestionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.viewControllers.count > 1) { //非入口页面需要显示返回按钮
            
            if (!_isShowBack) { //已隐藏返回按钮才需要改变布局
                _isShowBack = YES;
                
                if (animated) {
                    
                    _backBtn.userInteractionEnabled = NO;
                    _searchTextField.userInteractionEnabled = NO;
                    [UIView animateWithDuration:AnimatedTime animations:^{
                        
                        _backBtn.alpha = 1;
                        
                        CGRect frame = _searchBGView.frame;
                        frame.origin.x += (CGRectGetWidth(_backBtn.frame) + CGRectGetMinX(_backBtn.frame));
                        frame.size.width -= (CGRectGetWidth(_backBtn.frame) + CGRectGetMinX(_backBtn.frame));
                        _searchBGView.frame = frame;
                        
                    } completion:^(BOOL finished) {
                        
                        [_searchBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(_backBtn.mas_right).offset(10);
                            make.right.equalTo(_putQuestionBtn.mas_left).offset(-10);
                            make.bottom.equalTo(_customNavBar.mas_bottom).offset(-7);
                            make.height.offset(30);
                        }];
                        _backBtn.userInteractionEnabled = YES;
                        _searchTextField.userInteractionEnabled = YES;
                        
                    }];
                    
                } else {
                    
                    _backBtn.alpha = 1;
                    [_searchBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_backBtn.mas_right).offset(10);
                        make.right.equalTo(_putQuestionBtn.mas_left).offset(-10);
                        make.bottom.equalTo(_customNavBar.mas_bottom).offset(-7);
                        make.height.offset(30);
                    }];
                    
                }
            }
            
        } else if (self.viewControllers.count <= 1) { //入口页面需要隐藏返回按钮
            
            if (_isShowBack) { //已显示返回按钮才需要改变布局
                _isShowBack = NO;
                
                if (animated) {
                    
                    _backBtn.userInteractionEnabled = NO;
                    _searchTextField.userInteractionEnabled = NO;
                    [UIView animateWithDuration:AnimatedTime animations:^{
                        
                        _backBtn.alpha = 0;
                        
                        CGRect frame = _searchBGView.frame;
                        frame.origin.x -= (CGRectGetWidth(_backBtn.frame) + CGRectGetMinX(_backBtn.frame));
                        frame.size.width += (CGRectGetWidth(_backBtn.frame) + CGRectGetMinX(_backBtn.frame));
                        _searchBGView.frame = frame;
                        
                    } completion:^(BOOL finished) {
                        
                        [_searchBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(_backBtn.mas_left);
                            make.right.equalTo(_putQuestionBtn.mas_left).offset(-10);
                            make.bottom.equalTo(_customNavBar.mas_bottom).offset(-7);
                            make.height.offset(30);
                        }];
                        _backBtn.userInteractionEnabled = YES;
                        _searchTextField.userInteractionEnabled = YES;
                        
                    }];
                    
                } else {
                    
                    _backBtn.alpha = 0;
                    [_searchBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_backBtn.mas_left);
                        make.right.equalTo(_putQuestionBtn.mas_left).offset(-10);
                        make.bottom.equalTo(_customNavBar.mas_bottom).offset(-7);
                        make.height.offset(30);
                    }];
                    
                }
            }
            
        }
        
    }
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    id vc = self.viewControllers.lastObject;
    if (![vc isKindOfClass:[SearchViewController class]]) {
        
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        [self pushViewController:searchVC animated:YES];
        
        return NO;
        
    } else {
        
        return YES;
        
    }
    
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self changeShowStatus:animated];
    
}

@end
