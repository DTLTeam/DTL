//
//  MyFollowViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/1/29.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyFollowViewController.h"

#import "FollowTableViewCell.h"

@interface MyFollowViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *followArr;
@property (nonatomic,assign) NSInteger  currentPage;

@end

@implementation MyFollowViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 1;
    _followArr = [NSMutableArray array];
    
    __weak MyFollowViewController *weakSelf = self;
    // 上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage ++;
        
        [weakSelf performSelector:@selector(end) withObject:nil afterDelay:5];
        
    }];
    [footer setUpGifImage:@"上拉刷新"];
    self.tableView.mj_footer = footer;
    
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf.followArr removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [header setUpGifImage:@"下拉加载"];
    self.tableView.mj_header = header;
    
    [self getFollowList];
}

- (void)getFollowList
{
     __weak MyFollowViewController *weakSelf = self;
    [[UserDataManager shareInstance] getFollowWithpage:[NSString stringWithFormat:@"%d",(int)_currentPage] finish:^(NSArray *dataArr) {
        GCD_MAIN(^{
            if (dataArr.count > 0) {
                [weakSelf.followArr addObjectsFromArray:dataArr];
                [weakSelf.tableView reloadData];
            }
            if (dataArr.count == 0 && weakSelf.followArr.count > 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [weakSelf end];
            }
        });
    }];
}

- (void)end{
    
    //没有更多了了
    [self.tableView.mj_footer endRefreshing];
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
    self.title = @"我的关注";
    [self setUpNavBgColor:MineTopColor];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hiddenNav];
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
    return _followArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [view addSubview:line];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FollowTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    FollowDataModel *model = _followArr[indexPath.section];
    [cell updateFollowCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
