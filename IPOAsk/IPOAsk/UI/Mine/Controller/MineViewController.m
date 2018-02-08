//
//  MineViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MineViewController.h"
#import "DraftsViewController.h"

#import "HeadViewTableViewCell.h"

#import "UserDataManager.h"



@interface MineViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) UserDataManager *userManager;
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
    dataArr = @[@"我的钱包",@"申请成为答主",@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
    _userManager = [UserDataManager shareInstance];
    [self setupView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self setNeedsNavigationBackground:0.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self setNeedsNavigationBackground:1.0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationController.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else if([barBackgroundView subviews].count > 1){
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    self.navigationController.navigationBar.clipsToBounds = alpha == 0.0;
}

- (void)setupView
{
    self.view.backgroundColor = MineTopColor;
    
    CGFloat height = 160 + 64 + dataArr.count * 50.5 + 10;
    if (height + TABBAR_HEIGHT >= SCREEN_HEIGHT) {
        height = SCREEN_HEIGHT;
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
    return dataArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160 + 64;
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
        static NSString *identifier = @"headCell";
        HeadViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[HeadViewTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier action:^(NSInteger tag) {
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
        cell.textLabel.text = dataArr[indexPath.section - 1];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.imageView.image = [UIImage imageNamed:dataArr[indexPath.section - 1]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"pushInfo" sender:nil];
            break;
        case 1:
        {
            [self performSegueWithIdentifier:@"pushWallet" sender:nil];
        }
            break;
        case 2:
        {
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
                
            }
        }
            break;
        case 3:
        {
            DraftsViewController *vc = [[DraftsViewController alloc]init]; 
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            [self performSegueWithIdentifier:@"pushHelp" sender:nil];
        }
            break;
        case 5:
        {
            [self performSegueWithIdentifier:@"pushAbout" sender:nil];
        }
            break;
        case 6:
        {
            [self performSegueWithIdentifier:@"PushSetting" sender:nil];
        }
            break;
        default:
            break;
    }
}




@end
