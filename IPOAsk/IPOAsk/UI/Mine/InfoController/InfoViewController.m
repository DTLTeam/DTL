//
//  InfoViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/1/27.
//  Copyright © 2018年 law. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation InfoViewController
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = @[@[@"头像",@"昵称",@"真实姓名",@"绑定邮箱",@"公司名称",@"简介"],@[@"用户类型",@"是否答主"]];
    [self setupView];

}

- (void)setupView
{
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1];
    
    CGFloat height = 150 + 7 * 60 + 10;
    if (height + NAVBAR_HEIGHT >= SCREEN_HEIGHT) {
        height = SCREEN_HEIGHT;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"个人资料";
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
    if (section == 0) {
        return 6;
    }else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5)
    {
        return 150;
    }else
    {
        return 60.5;
    }
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
        view.backgroundColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1];
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
        if (indexPath.row != 5 || (indexPath.section == 1 && indexPath.row == 1)) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH, 0.5)];
            view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            [cell addSubview:view];
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
            UIImageView *headImgViwe = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 40, 40)];
            headImgViwe.image = [UIImage imageNamed:@"默认头像"];
            headImgViwe.layer.cornerRadius = 20;
            headImgViwe.layer.masksToBounds = YES;
            [cell addSubview:headImgViwe];
        }else if (indexPath.row == 5)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 20)];
            label.text = dataArr[indexPath.section][indexPath.row];
            [cell addSubview:label];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, SCREEN_WIDTH - 80, 110)];
            label2.numberOfLines = 0;
            label2.text = @"320 x 480、640x960、640 × 1136、750x1334、1242 × 2208、1125 × 243640x40、58x58、60x60、76x76、80x80、87x87、120x120、152x152、167x167、180x180、1024x1024";
            [cell addSubview:label2];
            
        }else
        {
            cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = dataArr[indexPath.section][indexPath.row];
        }
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
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
