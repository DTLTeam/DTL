//
//  MyAskViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyAskViewController.h"
#import "FollowTableViewCell.h"

#import "UserDataManager.h"

@interface MyAskViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *askArr;
@property (nonatomic,assign) NSInteger  currentPage;

@end

@implementation MyAskViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //无数据背景
    [self setUpBgViewWithTitle:@"暂无提问哦!" Image:@"没有提问" Action:@selector(getAskList)];
    
    
    _currentPage = 1;
    _askArr = [NSMutableArray array];
    
    __weak MyAskViewController *weakSelf = self;
    // 上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage ++;
        
        [weakSelf performSelector:@selector(end) withObject:nil afterDelay:5];
        
    }];
    [footer setUpGifImage:@"上拉刷新"];
    self.tableView.mj_footer = footer;
    
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf.askArr removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [header setUpGifImage:@"下拉加载"];
    self.tableView.mj_header = header;
    
    [self getAskList];
}


- (void)getAskList
{
    __weak MyAskViewController *weakSelf = self;
    [[UserDataManager shareInstance] getAskWithpage:[NSString stringWithFormat:@"%d",(int)_currentPage] finish:^(NSArray *dataArr) {
        GCD_MAIN(^{
            if (dataArr.count > 0) {
                [weakSelf.askArr addObjectsFromArray:dataArr];
                [weakSelf.tableView reloadData];
            }
            if (dataArr.count == 0 && weakSelf.askArr.count > 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [weakSelf end];
            }
            
        });
    }];
}

- (void)end{
    if (_askArr.count == 0) {
        _tableView.hidden = YES;
        self.bgImageView.hidden = NO;
    }
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
    self.title = @"我的提问";
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
    return _askArr.count;
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
    AskDataModel *model = _askArr[indexPath.section];
    [cell updateAskCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AskDataModel *model = _askArr[indexPath.section];
 
    //传问题模型
    MainAskDetailViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailViewController" owner:self options:nil].firstObject;
    VC.model = model;
    VC.Type = PushType_MyAnswer;
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
