//
//  MineViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MineViewController.h"

#import "UserDataManager.h"

//View
#import "HeadViewTableViewCell.h"

//Contoller
#import "DraftsViewController.h"
#import "SignInViewController.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSArray *dataArr;

@property (nonatomic,strong) UserDataManager *userManager;
@property (nonatomic,assign) BOOL pushChangeUser;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MineTopColor;
    
    UIImage *img = [[UIImage imageNamed:@"我的-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    //self.navigationController.navigationBarHidden = YES;
    _dataArr = @[@"申请成为答主",@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
    _userManager = [UserDataManager shareInstance];
    
    [self setupView];
    
    [self loginChange];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChange) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChange) name:@"LoginOut" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableviewReload) name:@"refreshData" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PushSetting"]) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBtn;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hiddenNavBar];
    [self hiddenSearchNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self hiddenNavBar];
    [self hiddenSearchNavBar];
    
    if (_pushChangeUser) {
        [_contentTableView reloadData];
        _pushChangeUser = NO;
    }
}


- (void)loginChange {
    
    //个人用户、企业用户切换
    
    if ([UserDataManager shareInstance].userModel.userType == loginType_Enterprise){
        _dataArr = @[@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
    } else {
        _dataArr = @[@"申请成为答主",@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
    }
    
    [self tableviewReload];
}

- (void)tableviewReload{
    
    [_contentTableView reloadData];
}

- (void)setupView
{
    self.navigationController.navigationBar.hidden = YES;
    
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = MineTopColor;
    
    _contentTableView.backgroundColor = self.view.backgroundColor;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        _contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(-statusBarHeight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }
    }];
    
}


#pragma mark - UIcontentTableViewDelegate & UIcontentTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return _dataArr.count;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            return (SCREEN_HEIGHT >= 667 ? 140 + 72 : 120 + 60) + statusBarHeight;
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        __weak MineViewController *WeakSelf = self;
        static NSString *identifier = @"headCell";
        HeadViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[HeadViewTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier action:^(NSInteger tag) {
                
                if ([UtilsCommon ShowLoginHud:WeakSelf.view Tag:200]) {
                    return ;
                }
                
                switch (tag) {
                    case 0:
                    {
                        [self performSegueWithIdentifier:@"pushMyAsk" sender:nil];
                    }
                        break;
                    case 1:
                    {
                        
                        [self performSegueWithIdentifier:@"pushMyAnswer" sender:nil];
                    }
                        break;
                    case 2:
                    {
                        [self performSegueWithIdentifier:@"pushMyFollow" sender:nil];
                    }
                        break;
                    case 3:
                    {
                        [self performSegueWithIdentifier:@"pushMyLike" sender:nil];
                    }
                        break;
                    default:
                        break;
                }
                
                }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [cell refreshViews:_userManager.userModel.userType];
        
        if (_userManager.userModel) {
            
            __weak HeadViewTableViewCell *weakCell = cell;
            [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:@{@"cmd":@"getMyReflection",@"userID":_userManager.userModel.userID} backData:NetSessionResponseTypeJSON success:^(id response) {
                GCD_MAIN(^{
                    if ([[response valueForKey:@"status"] intValue] == 1) {
                        NSDictionary *dic = response[@"data"];
                        NSInteger questionCount = [dic[@"questionCount"] integerValue];
                        NSInteger answerCount = [dic[@"answerCount"] integerValue];
                        NSInteger followCount = [dic[@"followCount"] integerValue];
                        NSInteger achievementCount = [dic[@"achievementCount"] integerValue];
                        
                        [weakCell updateAskInfo:questionCount answer:answerCount follow:followCount like:achievementCount];
                    }
                });
            } requestHead:nil faile:nil];
        }
        [cell updateInfo:_userManager.userModel.headIcon name:_userManager.userModel.nickName phone:_userManager.userModel.phone];
        
        
        return cell;
    }else
    {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        cell.textLabel.text = _dataArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_dataArr[indexPath.row]];
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 0) {
        if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
            _pushChangeUser = YES;
            return;
        }
    }
    
    switch (indexPath.section) {
        case 0:
        {
            _pushChangeUser = YES;
            
            if (![UserDataManager shareInstance].userModel) {
                UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SignInViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"SignInView"];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
                return;
            }
            [self performSegueWithIdentifier:@"pushInfo" sender:nil];
        }
            break;
        case 1:
        {
            NSString *title = _dataArr[indexPath.row];
            
            if ([title isEqualToString:@"申请成为答主"]){
                if (_userManager.userModel) {
                    if (_userManager.userModel.isAnswerer == 1) {
                        return;
                    }
                    if (_userManager.userModel.forbidden == 1) {
                        TipsViews *tips = [[TipsViews alloc]initWithFrame:self.view.bounds HaveCancel:YES];
                        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                        [window addSubview:tips];

                        __weak TipsViews *WeakTips = tips;
                        [tips showWithContent:@"由于您违反了用户管理协议，平台拒绝了您的答主申请" tipsImage:@"申请失败" LeftTitle:@"我知道了" RightTitle:@"联系我们" block:^(UIButton *btn) {
                            [WeakTips dissmiss];

                        } rightblock:^(UIButton *btn) {

                            [UtilsCommon CallPhone];
                        }];

                    }else if ([USER_DEFAULT boolForKey:_userManager.userModel.userID]) {
                        //已经申请过
                        TipsViews *tips = [[TipsViews alloc]initWithFrame:self.view.bounds HaveCancel:NO];
                        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                        [window addSubview:tips];

                        __weak TipsViews *WeakTips = tips;

                        [tips showWithContent:@"您已申请过答主,审核正在进行中,请耐心等待" tipsImage:@"正在审核中" LeftTitle:@"我知道了" RightTitle:nil block:^(UIButton *btn) {
                            [WeakTips dissmiss];

                        } rightblock:^(UIButton *btn) {

                        }];

                    }else
                    {
                        [self performSegueWithIdentifier:@"pushAnswer" sender:nil];
                    }
                }else
                {
                    
                    //test******************
                    [self performSegueWithIdentifier:@"pushAnswer" sender:nil];
                    //test******************
                }
                
            }else if ([title isEqualToString:@"草稿箱"]){
                DraftsViewController *vc = [[DraftsViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([title isEqualToString:@"帮助中心"]){
                [self performSegueWithIdentifier:@"pushHelp" sender:nil];
                
            }else if ([title isEqualToString:@"关于我们"]){
                [self performSegueWithIdentifier:@"pushAbout" sender:nil];
                
            }else if ([title isEqualToString:@"设置"]){
                _pushChangeUser = YES;
                [self performSegueWithIdentifier:@"PushSetting" sender:nil];
                
            }
        }
            break;
        default:
            break;
    }
    
}

@end
