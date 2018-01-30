//
//  MineViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MineViewController.h"

#import "HeadViewTableViewCell.h"

@interface MineViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MineViewController
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataArr = @[@"我的钱包",@"申请成为答主",@"草稿箱",@"帮助中心",@"关于我们",@"设置"];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UtilsCommon createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UtilsCommon createImageWithColor:[UIColor clearColor]]];
    navigationBar.shadowImage = [UtilsCommon createImageWithColor:[UIColor clearColor]];
    
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
        return 170;
    }
    return 60;
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
                        
                    }
                        break;
                    case 1:
                    {
                        
                    }
                        break;
                    case 2:
                    {
                        [self performSegueWithIdentifier:@"pushMyFollow" sender:nil];
                    }
                        break;
                    case 3:
                    {
                        
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
        }
        cell.textLabel.text = dataArr[indexPath.section - 1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            [self performSegueWithIdentifier:@"pushAnswer" sender:nil];
        }
            break;
        case 3:
        {
            [self performSegueWithIdentifier:@"pushDraft" sender:nil];
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
