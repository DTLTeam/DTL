//
//  SettingViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong)  UISwitch *Switch;

@end

@implementation SettingViewController
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    self.view.backgroundColor = MineTopColor;
    
    [self setUpNavBgColor:nil RightBtn:nil];
    [self setupView];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}

- (void)setupView
{
    dataArr = @[@[@"消息通知", @"给APP评分", @"用户协议", @"联系我们"], @[@"退出当前帐号"]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = MineTopColor;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        [(BaseNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //[self hiddenNav];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                default:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                    break;
            }
            
            if (indexPath.row < [dataArr[indexPath.section] count]) {
                cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
                if (indexPath.row == 0) {
                    if (!_Switch) {
                        _Switch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 60, 40)];
                        [_Switch addTarget:self action:@selector(changeNotificationOpen:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    cell.accessoryView = _Switch;
                    
                    [self refreshSwitch:_Switch Change:NO];
                }
            }
            
            return cell;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"signOutCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                UILabel *textLabel = [[UILabel alloc] init];
                textLabel.text = dataArr[indexPath.section][indexPath.row];
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.backgroundColor = cell.backgroundColor;
                textLabel.userInteractionEnabled = NO;
                [cell addSubview:textLabel];
                
                [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(cell.mas_centerX);
                    make.centerY.equalTo(cell.mas_centerY);
                    make.width.offset(200);
                    make.height.offset(30);
                }];
            }
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    switch (indexPath.section) {
        case 1:
        {
            [self loginOut];
        }
            break;
        default:
            break;
    }
}

- (void)changeNotificationOpen:(UISwitch *)sender{
    
    [self refreshSwitch:_Switch Change:YES];
}

#pragma mark - 通知状态刷新
- (void)refreshSwitch:(UISwitch *)Switch Change:(BOOL)change{
    NSDictionary *openInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"User_OpenNotification"];
    
    static NSString *Open = @"1";
    
    if (![openInfo valueForKey:@"Open"]) {
        //默认打开
        Switch.on = YES;
    
    }else{
        if ([[openInfo valueForKey:@"Open"]isEqualToString:@"1"]) {
            Switch.on = YES;
        }else if ([[openInfo valueForKey:@"Open"]isEqualToString:@"0"]){
            Switch.on = NO;
        }
    }
    
    if (change) {
        if ([[openInfo valueForKey:@"Open"]isEqualToString:@"1"]) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            Open = @"0";
            
        }else if ([[openInfo valueForKey:@"Open"]isEqualToString:@"0"]){
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            Open = @"1";
            
        }
        
        NSDictionary *UserDefaults = @{@"Open":Open};
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UserDefaults forKey:@"User_OpenNotification"];
        [defaults synchronize];
        
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 退出登录
- (void)loginOut{
    
    UserDataManager *userManager = [UserDataManager shareInstance];
    [userManager loginSetUpModel:nil];
    [userManager signOut];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"UserInfo_only"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginOut" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
