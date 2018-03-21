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
    
    [self setUpNavBgColor:nil RightBtn:nil];
    [self setupView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showNavBar];
    [self hiddenSearchNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showNavBar];
    [self hiddenSearchNavBar];
}


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
                    _Switch.on = [UserDataManager shareInstance].userModel.isPushMessage;
                    
                    cell.accessoryView = _Switch;
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

- (void)changeNotificationOpen:(UISwitch *)sender {
    
    [self refreshSwitch:sender Change:sender.on];
    
}

#pragma mark - 通知状态刷新
- (void)refreshSwitch:(UISwitch *)Switch Change:(BOOL)change {
    
    if (!change) {
        
        //关闭推送消息
        [[UserDataManager shareInstance] unbindPushToken:^(BOOL isSuccess) {
            
            if (isSuccess) { //成功
                Switch.on = change;
                [UserDataManager shareInstance].userModel.isPushMessage = NO;
            } else { //失败
                Switch.on = [UserDataManager shareInstance].userModel.isPushMessage;
            }
            
        }];
    
    } else {
        
        //开启推送消息
        [[UserDataManager shareInstance] bindPushToken:^(BOOL isSuccess) {
            
            if (isSuccess) { //成功
                Switch.on = change;
                [UserDataManager shareInstance].userModel.isPushMessage = YES;
            } else { //失败
                Switch.on = [UserDataManager shareInstance].userModel.isPushMessage;
            }
            
        }];
        
    }
    
}

#pragma mark - 退出登录
- (void)loginOut {
    
    [AskProgressHUD AskShowTitleInView:self.view Title:@"正在退出登录..." viewtag:10];
    
    UserDataManager *userManager = [UserDataManager shareInstance];
    [userManager loginSetUpModel:nil];
    [userManager unbindPushToken:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            [AskProgressHUD AskHideAnimatedInView:self.view viewtag:10 AfterDelay:0];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:@"UserInfo_only"];
            [defaults synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginOut" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"退出失败" viewtag:10 AfterDelay:1.5];
            
        }
        
    }];
    
    
}

@end
