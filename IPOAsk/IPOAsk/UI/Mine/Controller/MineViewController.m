//
//  MineViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MineViewController.h"
#import "DraftsViewController.h"
#import "SignInViewController.h"

#import "HeadViewTableViewCell.h"

#import "UserDataManager.h"



@interface MineViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) UserDataManager *userManager;
@property (nonatomic,assign) BOOL pushChangeUser;
@end

@implementation MineViewController
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [[UIImage imageNamed:@"我的-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    //self.navigationController.navigationBarHidden = YES;
    dataArr = @[@"",@"申请成为答主",@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
    _userManager = [UserDataManager shareInstance];
    
    [self setupView];
    
    [self loginChange];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChange) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChange) name:@"LoginOut" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
    if (_pushChangeUser) {
        [_tableView reloadData];
        _pushChangeUser = NO;
    }
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNeedsNavigationBackground:0.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setNeedsNavigationBackground:1.0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    [self.navigationController.navigationBar setBackgroundImage:[UtilsCommon createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UtilsCommon createImageWithColor:[UIColor clearColor]]];
    self.navigationController.navigationBar.shadowImage = [UtilsCommon createImageWithColor:[UIColor clearColor]];
    
//    // 导航栏背景透明度设置
//    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
//    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
//    if (self.navigationController.navigationBar.isTranslucent) {
//        if (backgroundImageView != nil && backgroundImageView.image != nil) {
//            barBackgroundView.alpha = alpha;
//        } else if([barBackgroundView subviews].count > 1){
//            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
//            if (backgroundEffectView != nil) {
//                backgroundEffectView.alpha = alpha;
//            }
//        }
//    } else {
//        barBackgroundView.alpha = alpha;
//    }
//    self.navigationController.navigationBar.clipsToBounds = alpha == 0.0;
}


- (void)loginChange{
    
    //个人用户、企业用户切换
    
    if ([UserDataManager shareInstance].userModel.userType == loginType_Enterprise){
        
        dataArr = @[@"",@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
        CGFloat height = 160 + 72 + (dataArr.count - 1) * 50.5 + 10;
        if (SCREEN_HEIGHT < 667) {
            height = 140 + 60 + (dataArr.count - 1) * 50.5 + 10;
        }
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        
    }else{
        dataArr = @[@"",@"申请成为答主",@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
        CGFloat height = 160 + 72 + (dataArr.count - 1) * 50.5 + 10;
        if (SCREEN_HEIGHT < 667) {
            height = 140 + 60 + (dataArr.count - 1) * 50.5 + 10;
        }
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    }
    
    [_tableView reloadData];
}

- (void)setupView
{
    self.view.backgroundColor = MineTopColor;
    
    CGFloat height = 160 + 72 + dataArr.count * 50.5 + 10;
//    if (height + TABBAR_HEIGHT >= SCREEN_HEIGHT) {
//        height = SCREEN_HEIGHT;
//    }
    if (SCREEN_HEIGHT < 667) {
        height = 140 + 60 + dataArr.count * 50.5 + 10;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
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


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return SCREEN_HEIGHT >= 667 ? 160 + 72 : 140 + 60;
    }
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = MineTopColor;
        return view;
    }
    return [[UIView alloc]init];
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
                
                self.navigationController.navigationBarHidden = NO;
                self.navigationController.tabBarController.tabBar.hidden = YES;
                
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
            [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyReflection",@"userID":_userManager.userModel.userID} backData:NetSessionResponseTypeJSON success:^(id response) {
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
            if (indexPath.section != 6) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, SCREEN_WIDTH, 0.5)];
                view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                [cell addSubview:view];
            }
        }
        cell.textLabel.text = dataArr[indexPath.section];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.imageView.image = [UIImage imageNamed:dataArr[indexPath.section]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section != 0) {
        if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
            _pushChangeUser = YES;
            return;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    NSString *title = dataArr[indexPath.section];
    
    if ([title isEqualToString:@""]) {
        _pushChangeUser = YES;
        
        if (![UserDataManager shareInstance].userModel) {
            UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SignInViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"SignInView"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            return;
        }
        [self performSegueWithIdentifier:@"pushInfo" sender:nil];
        
    }else if ([title isEqualToString:@"申请成为答主"]){
        if (_userManager.userModel) {
            self.navigationController.tabBarController.tabBar.hidden = NO;
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
            self.navigationController.tabBarController.tabBar.hidden = NO;
            
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




@end
