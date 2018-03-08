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

@interface MainNavigationController () <UINavigationControllerDelegate,UITextViewDelegate>

//参数
@property (nonatomic) BOOL isShowSearchBar; //是否显示搜索栏
@property (nonatomic) BOOL isShowBack;      //是否显示返回按钮

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
    [self.navigationBar addObserver:self forKeyPath:@"hidden" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    [self changeShowStatus:YES];
    
    _searchTextField.delegate = self;
    [_searchTextField addTarget:self action:@selector(searchTextChangeAction:)  forControlEvents:UIControlEventAllEditingEvents];
    
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
    
    _isShowSearchBar = YES;
    _isShowBack = YES;
    self.delegate = self;
    
    _customNavBar = [[UIView alloc] init];
    _customNavBar.backgroundColor = [UIColor whiteColor];
    [self.navigationBar addSubview:_customNavBar];
    
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
    imgView.contentMode = UIViewContentModeCenter;
    [_searchBGView addSubview:imgView];
    
    _searchTextField = [[UITextField alloc] init];
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"输入关键字搜索感兴趣的问题" attributes:@{NSForegroundColorAttributeName:HEX_RGBA_COLOR(0x959A9F, 1), NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    _searchTextField.attributedPlaceholder = placeholderString;
//    _searchTextField.tintColor = HEX_RGBA_COLOR(0x999999, 1);
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.returnKeyType = UIReturnKeyDone;
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
    
    
    [_customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_top);
        make.bottom.equalTo(self.navigationBar.mas_bottom);
        make.left.equalTo(self.navigationBar.mas_left);
        make.right.equalTo(self.navigationBar.mas_right);
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
        
        if (_searchTextField.text.length > 0) {
            _searchTextField.text = @"";
        }
        
        [self popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark 发布问题
- (void)putQuestionAction:(id)sender {
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        return;
    }
    
    self.tabBarController.tabBar.hidden = YES;
    EditQuestionViewController *editQuestionVC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:nil options:nil].firstObject;
    [editQuestionVC UserType:AnswerType_AskQuestionPerson NavTitle:@"提问"];
 
    [self pushViewController:editQuestionVC animated:YES];
    
}

#pragma mark 搜索框输入内容改变
- (void)searchTextChangeAction:(id)sender {
    
    if (_searchDelegate && [_searchDelegate respondsToSelector:@selector(searchTextChange:)]) {
        UITextField *textField = (UITextField *)sender;
        [_searchDelegate searchTextChange:textField.text];
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 不让输入表情
    if ([textField isFirstResponder]) {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            
            return NO;
        }
    }
    return YES;
}

#pragma mark - 功能

#pragma mark 显示搜索导航栏
- (void)showSearchNavBar:(BOOL)animated {
    
    _isShowSearchBar = YES;
    if (_customNavBar.hidden && !self.navigationBar.hidden) {
        
        if (animated) {
            
            _customNavBar.alpha = 0;
            _customNavBar.hidden = NO;
            [UIView animateWithDuration:AnimatedTime animations:^{
                
                _customNavBar.alpha = 1;
                
            } completion:^(BOOL finished) {
                
            }];
            
        } else {
            
            _customNavBar.hidden = NO;
            
        }
        
        [self changeShowStatus:AnimatedTime];
        
    }
    
}

#pragma mark 隐藏搜索导航栏
- (void)hideSearchNavBar:(BOOL)animated {
    
    _isShowSearchBar = NO;
    if (!_customNavBar.hidden) {
        
        if (animated) {
            
            _customNavBar.alpha = 1;
            [UIView animateWithDuration:AnimatedTime animations:^{
                
                _customNavBar.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                _customNavBar.alpha = 1;
                _customNavBar.hidden = YES;
                
            }];
            
        } else {
            
            _customNavBar.hidden = YES;
            
        }
        
        [self changeShowStatus:animated];
        
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
  
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        return NO;
    }
    
    id vc = self.viewControllers.lastObject;
    if (![vc isKindOfClass:[SearchViewController class]]) {
        
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        [self pushViewController:searchVC animated:YES];
        
        return NO;
        
    } else {
        
        if (_searchDelegate && [_searchDelegate respondsToSelector:@selector(searchTextChange:)]) {
            [_searchDelegate searchTextChange:_searchTextField.text];
        }
        
        return YES;
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    NSString *str = _searchTextField.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _searchTextField.text = str;
    
    if (_searchDelegate && [_searchDelegate respondsToSelector:@selector(beginSearch)]) {
        [_searchDelegate beginSearch];
    }
    
    return NO;
    
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (_searchTextField.isEditing) {
        [self.view endEditing:YES];
    }
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.backBarButtonItem = nil;
    

    for (UIView *view in self.navigationBar.subviews) {
        if ([NSStringFromClass ([view class]) containsString:@"BarBackIndicatorView"] ){
            view.hidden = YES;
            NSLog(@"%@---",[view class]);
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (_searchTextField.isEditing) {
        [self.view endEditing:YES];
    }
    
    [self changeShowStatus:animated];
    
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    self.navigationItem.leftBarButtonItems = nil;
    if ([keyPath isEqualToString:@"hidden"]) {
        
        if ([change[NSKeyValueChangeNewKey] boolValue]) { //隐藏
            
            _customNavBar.hidden = YES;
            
        } else { //显示
            
            if (_isShowSearchBar) {
                _customNavBar.hidden = NO;
            }
            
        }
        
    }
    
}

@end
