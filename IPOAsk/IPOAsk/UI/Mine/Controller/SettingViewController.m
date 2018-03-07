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
    
   
    dataArr = @[@"消息通知",@"给APP评分",@"用户协议",@"联系我们",@"退出当前帐号"];
    
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = MineTopColor;
    
    CGFloat height = dataArr.count * 50 + 10;
    if (height + NAVBAR_HEIGHT >= SCREEN_HEIGHT) {
        height = SCREEN_HEIGHT;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"设置";
    [self setUpNavBgColor:MineTopColor RightBtn:^(UIButton *btn) {
        
    }];
    
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController hideSearchNavBar:YES];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == dataArr.count - 2) {
        return 10;
    }
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == dataArr.count - 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = MineTopColor;
        return view;
    }
    return [[UIView alloc]init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
        [cell addSubview:view];
    }
    
    if (indexPath.section < dataArr.count - 1) {
        cell.textLabel.text = dataArr[indexPath.section];
        if (indexPath.section == 0) {
            if (!_Switch) {
                _Switch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 60, 40)];
                [_Switch addTarget:self action:@selector(changeNotificationOpen:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell addSubview:_Switch];
            
            [self refreshSwitch:_Switch Change:NO];
        }
    }else{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[dataArr lastObject] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [btn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    
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
