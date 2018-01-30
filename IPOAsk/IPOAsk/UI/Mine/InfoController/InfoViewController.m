//
//  InfoViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/1/27.
//  Copyright © 2018年 law. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InfoViewController
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = @[@[@"头像"],@[@"昵称",@"真实姓名",@"绑定邮箱",@"公司名称",@"简介"],@[@"用户类型",@"是否答主"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.title = @"我的资料";
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 5;
    }else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.row == 4)
    {
        return 150;
    }else
    {
        return 61;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
        UIImageView *headImgViwe = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 20, 60, 60)];
        headImgViwe.backgroundColor = [UIColor redColor];
        [cell addSubview:headImgViwe];
    }else if (indexPath.row == 4)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 20)];
        label.text = dataArr[indexPath.section][indexPath.row];
        [cell addSubview:label];
    }else
    {
        cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"个人用户";
        }else
        {
            cell.detailTextLabel.text = @"否";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
