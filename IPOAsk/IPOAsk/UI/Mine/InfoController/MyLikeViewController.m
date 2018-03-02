//
//  MyLikeViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyLikeViewController.h"

#import "UserDataManager.h"

//View
#import "LikeTableViewCell.h"

@interface MyLikeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *likeArr;
@property (nonatomic,assign) NSInteger  currentPage;

@end

@implementation MyLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的成就";
    
    [self setUpNavBgColor:MineTopColor RightBtn:^(UIButton *btn) {
        
    }];
    
    [self initInterface];
    
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
    
    [self setUpNavBgColor:MineTopColor RightBtn:^(UIButton *btn) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
    
    [_tableView.mj_header beginRefreshing];
    
}


#pragma mark - 界面

- (void)initInterface {
    
    _currentPage = 0;
    _likeArr = [NSMutableArray array];
    
    //无数据背景
    [self setUpBgViewWithTitle:@"暂无成就哦!" Image:@"没有提问" Action:@selector(getLikeList)];
    
    __weak typeof(self) weakSelf = self;
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getLikeList];
    }];
    _tableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        [weakSelf.likeArr removeAllObjects];
        [weakSelf.tableView reloadData];
        weakSelf.currentPage = 1;
        [weakSelf getLikeList];
    }];
    _tableView.mj_header = header;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.estimatedRowHeight = 999;
    
}


#pragma mark - 功能

- (void)getLikeList
{
    __weak typeof(self) weakSelf = self;
    
    [[UserDataManager shareInstance] getLikeWithpage:[NSString stringWithFormat:@"%d",(int)_currentPage] finish:^(NSArray *dataArr, BOOL isEnd) {
        
        if (dataArr) { //请求成功
            
            if (dataArr.count > 0) { //有数据
                
                if (weakSelf.currentPage == 1) {
                    [weakSelf.likeArr removeAllObjects];
                }
                [weakSelf.likeArr addObjectsFromArray:dataArr];
                [weakSelf.tableView reloadData];
                
            } else { //无数据
                
                if (weakSelf.likeArr.count == 0) { //之前也无数据
                    [weakSelf end];
                }
                
            }
            
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                if (isEnd) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            }
            
        } else { //请求失败
            
            weakSelf.currentPage--;
            
            [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:@"网络请求失败" viewtag:0 AfterDelay:1.5];
            
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
        }
        
    } fail:^(NSError *error) {
        
        weakSelf.currentPage--;
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:@"网络连接错误" viewtag:0 AfterDelay:1.5];
        
        if (weakSelf.tableView.mj_header.isRefreshing) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        if (weakSelf.tableView.mj_footer.isRefreshing) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    }];
}

- (void)end {
    if (_likeArr.count == 0) {
        _tableView.hidden = YES;
        self.bgImageView.hidden = NO;
    }
    //没有更多了
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _likeArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    LikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LikeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    LikeDataModel *model = _likeArr[indexPath.section];
    [cell updateCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
