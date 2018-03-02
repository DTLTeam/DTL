//
//  EditQuestionViewController.m
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EditQuestionViewController.h"

//Controller
#import "MainNavigationController.h"

@interface EditQuestionViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomH;

@property (nonatomic,assign)CGFloat defBottomH;

@property (nonatomic,assign)CGRect keyboardFrame;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIView *ChooseClick; 

@property (weak, nonatomic) IBOutlet UILabel *Title1;
@property (weak, nonatomic) IBOutlet UIButton *Title2;
@property (weak, nonatomic) IBOutlet UIView *Title2Line;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Title1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Title2Width;

@property (weak, nonatomic) IBOutlet UITextField *question;
@property (weak, nonatomic) IBOutlet UITextView *QuestionContent;

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextH;

@property (nonatomic,assign) AnswerType     MainAnswerType;

@property (nonatomic,strong) DraftsModel    *IsChangeModel;

@property (nonatomic,strong)void (^(ChangeClick))(BOOL Change); 

@end

@implementation EditQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUpGradient];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];
  
    if (SCREEN_HEIGHT < 667) {
        _Title1.font = [UIFont systemFontOfSize:11];
        _Title2.titleLabel.font = [UIFont systemFontOfSize:11];
        _anonymousBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        _Title1Width.constant -= 21;
        _Title2Width.constant -= 10;
    }
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
    
    [self setUpNav];
  
}

-(void)UserType:(AnswerType)type NavTitle:(NSString *)title{
    _MainAnswerType = type;
    
    if (_MainAnswerType == AnswerType_AskQuestionEnterprise) {
        //企业提问
        _Title1.hidden = YES;
        _Title2.hidden = YES;
        _anonymousBtn.hidden = YES;
        _BottomH.constant = _BottomH.constant - 32;
        _defBottomH = _BottomH.constant;
        
    }else if (_MainAnswerType == AnswerType_AskQuestionPerson){
        //个人提问
        _Title1.hidden = NO;
        _Title2.hidden = NO;
        
    }else if (_MainAnswerType == AnswerType_Answer){
        //个人回答问题
        _Title1.hidden = YES;
        _Title2.hidden = YES;
        _TextH.constant = _TextH.constant - CGRectGetMaxY(_line.frame) + 18 + 10;
        _question.hidden = YES;
        _line.hidden = YES;
        [_QuestionContent mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            } else {
                make.top.equalTo(self.view.mas_top).offset(10);
            }
        }];
    }
    
    _Title2Line.hidden = _Title2.hidden;
    
    self.title = title;
}

-(void)EditModel:(DraftsModel *)model WithHaveChangeClick:(void (^)(BOOL))ChangeClick{
    
    _ChangeClick = ChangeClick;
    _IsChangeModel = model;
    
    _question.text = model.title;
    _QuestionContent.text = model.content;
    if (_MainAnswerType == AnswerType_Answer) {
        _anonymousBtn.selected = [_IsChangeModel.anonymous integerValue];
    }
    
    
    NSString *st = @"";
    if (model.Type == AnswerType_AskQuestionPerson) {
        st = @"提问";
    }else if (model.Type == AnswerType_AskQuestionEnterprise){
        st = @"企业+";
    }else if (model.Type == AnswerType_Answer){
        st = model.title;
    }
    [self UserType:model.Type NavTitle:st];
}

- (void)setUpNav{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"" bgimage:nil  Title:@"取消" SelectedTitle:@" " titleFont:3 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(back)];
    [lbtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    lbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -14;
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftBtn];
    
    
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *rightBtn = [UIBarButtonItem returnTabBarItemWithBtn:rbtn image:@"" bgimage:nil  Title:@"发布" SelectedTitle:@""  titleFont:3 itemtype:Itemtype_rigth SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(SendOut)];
    [rbtn setTitleColor:HEX_RGB_COLOR(0x0b98f2) forState:UIControlStateNormal];
    rbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn]; 
    
}

#pragma mark - 渐变蒙版
- (void)setUpGradient{
 
    UIView *yourGradientView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH - 24, 20)];
    // 渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = yourGradientView.bounds;
    
    // 设置颜色
    gradientLayer.locations = @[[NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:1.0f]];

    gradientLayer.colors = @[ (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                              (id)[[UIColor whiteColor] colorWithAlphaComponent:1.0f].CGColor];
    
    // 添加渐变图层
    [yourGradientView.layer addSublayer:gradientLayer];
    [_BottomView addSubview:yourGradientView];
    
    _BottomView.clipsToBounds = NO;
    
}

- (void)back{
    
    if (_QuestionContent.text.length > 0 || _question.text.length > 0) {
        //提示保存草稿
        
        //没有修改
        if ([_question.text isEqualToString:_IsChangeModel.title] && [_QuestionContent.text isEqualToString:_IsChangeModel.content] && _anonymousBtn.selected == [_IsChangeModel.anonymous integerValue]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        __weak EditQuestionViewController *WeakSelf = self;
        
        [AskProgressHUD ShowTipsAlterViewWithTitle:@"提示" Message: _IsChangeModel ? @"是否保存修改？" : @"是否保存？" DefaultAction:@"是" CancelAction: _IsChangeModel ? @"不修改" : @"不保存" Defaulthandler:^(UIAlertAction *action) {
            DraftsModel *model = [[DraftsModel alloc]init];
            model.title = WeakSelf.MainAnswerType == AnswerType_Answer ? WeakSelf.title : WeakSelf.question.text;
            model.content = WeakSelf.QuestionContent.text;
            model.Type = WeakSelf.MainAnswerType;
            // 过滤空格
            model.content = [model.content stringByReplacingOccurrencesOfString:@" " withString:@""];
            model.Type = WeakSelf.MainAnswerType;
            model.anonymous =  @"0";
            model.UserId = [UserDataManager shareInstance].userModel.userID;
            
            if (WeakSelf.MainAnswerType != AnswerType_AskQuestionEnterprise) {//回答页面用户是否匿名
                model.anonymous = WeakSelf.anonymousBtn.selected ? @"1" : @"0";
            }
            
            if (_IsChangeModel) {
                model.Id = _IsChangeModel.Id;
                
                if ([[FMDBManager sharedInstance]UpdateToDB:model Where:[NSString stringWithFormat:@"where id = '%@'",_IsChangeModel.Id]]) {
                    WeakSelf.ChangeClick(YES);
                    WeakSelf.ChangeClick = nil;
                    [WeakSelf.navigationController popViewControllerAnimated:YES];
                    
                }else [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"修改失败" viewtag:100 AfterDelay:5];
                
            }else if ([[FMDBManager sharedInstance]insertToDB:model] && !_IsChangeModel){
                
                [WeakSelf.navigationController popViewControllerAnimated:YES];
                
            }else{
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"保存失败" viewtag:100 AfterDelay:5];
            }
            
        } cancelhandler:^(UIAlertAction *action) {
            
            [WeakSelf.navigationController popViewControllerAnimated:YES];
            
        } ControllerView:^(UIAlertController *vc) {
            [WeakSelf presentViewController:vc animated:YES completion:nil];
        }];
         
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发布
- (void)SendOut{
    
    if (_question.text.length == 0 && _MainAnswerType != AnswerType_Answer) {
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请写标题!" viewtag:100 AfterDelay:3];
        return;
    }
    
    if (_QuestionContent.text.length == 0) {
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请写内容!" viewtag:100 AfterDelay:3];
        return;
    }
    
    
    if (_IsChangeModel && [[FMDBManager sharedInstance]DeleteWithSqlDB:[DraftsModel class] Where:[NSString stringWithFormat:@" where id = %@",_IsChangeModel.Id]]) {
        //发布草稿
        _ChangeClick(YES);
        _ChangeClick = nil;
        
        //发布接口
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        //发布接口
        [self requestSend];
    }
    
}

- (void)requestSend {
    
    __weak typeof(self) weakSelf = self;
    
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    NSDictionary *infoDic;
    switch (_MainAnswerType) {
        case AnswerType_Answer:
        {
            infoDic = @{@"cmd":@"askComment",
                        @"userID":(userMod ? userMod.userID : @""),
                        @"qID":(_questionID ? _questionID : _IsChangeModel.Id),
                        @"isAnonymous":@(_anonymousBtn.selected),
                        @"content":_QuestionContent.text
                        };
        }
            break;
        case AnswerType_AskQuestionPerson:
        {
            infoDic = @{@"cmd":@"addQuestion",
                        @"userID":(userMod ? userMod.userID : @""),
                        @"isAnonymous":@(_anonymousBtn.selected),
                        @"title":_question.text,
                        @"content":_QuestionContent.text
                        };
        }
            break;
        default:
            break;
    }
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            
            if (response && ([response[@"status"] intValue] == 1)) {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
            
        }));
        
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
    }];
    
}

#pragma mark - 联系我们
- (IBAction)Call:(UIButton *)sender {
    
    [UtilsCommon CallPhone];
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


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    _question.text =  [_question.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    // 不让输入表情
    if ([textField isFirstResponder]) {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            
            return NO;
        }
    }
    
    //过滤空格
    if ([string isEqualToString:@" "]) {
        return  NO;
    }
    
    return YES;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    // 不让输入表情
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            
            return NO;
        }
    }
    return YES;
}


#pragma mark - 键盘状态改变通知

#pragma mark 键盘隐藏时隐藏评论工具栏
- (void)KeyboardDidHideNotification:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.38 animations:^{
        
        _BottomH.constant = _defBottomH;
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark 键盘显示时弹出评论工具栏
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

@end
