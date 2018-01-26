//
//  MineViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeadView.h"


@interface MineViewController () <UITableViewDelegate,UITableViewDataSource,MineHeadViewDelegate>
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
 
    [self setUpViews];
    
   
}

- (void)setUpViews{
    MineHeadView *signView = [[NSBundle mainBundle] loadNibNamed:@"MineHeadView" owner:self options:nil][0];
    signView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(signView.bottomLine.frame));
    signView.delegate = self;
    self.tableView.tableHeaderView = signView;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UtilsCommon createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UtilsCommon createImageWithColor:[UIColor clearColor]]];
    navigationBar.shadowImage = [UtilsCommon createImageWithColor:[UIColor clearColor]];
    
}

#pragma mark - 头部按钮

#pragma mark - 我的提问
-(void)clickMyQuestion:(UITapGestureRecognizer *)sender{
    NSLog(@"我的提问");
}

#pragma mark - 我的回答
-(void)clickMyAnswer:(UITapGestureRecognizer *)sender{
    NSLog(@"我的回答");
    
}

#pragma mark - 我的关注
-(void)clickMyFollow:(UITapGestureRecognizer *)sender{
    NSLog(@"我的关注");
    
}

#pragma mark - 我的成就
-(void)clickMyAchievements:(UITapGestureRecognizer *)sender{
    NSLog(@"我的成就");
    
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
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.textLabel.text = dataArr[indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
