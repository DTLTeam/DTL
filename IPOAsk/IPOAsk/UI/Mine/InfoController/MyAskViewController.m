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
    
    self.title = @"我的提问";
    [self setUpNavBgColor:nil RightBtn:nil];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hiddenTabBar];
    [self showNavBar];
    [self hiddenSearchNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 界面

- (void)initInterface {
    
    _currentPage = 0;
    _askArr = [NSMutableArray array];
    
    //无数据背景
    [self setUpBgViewWithTitle:@"暂无提问哦!" Image:@"没有提问" Action:@selector(getAskList)];
    
    __weak typeof(self) weakSelf = self;
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < 0) {
            weakSelf.currentPage = 0;
        }
        weakSelf.currentPage++;
        [weakSelf getAskList];
    }];
    _tableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        [weakSelf.askArr removeAllObjects];
        [weakSelf.tableView reloadData];
        weakSelf.currentPage = 1;
        [weakSelf getAskList];
    }];
    _tableView.mj_header = header;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.estimatedRowHeight = 999;
    
}


#pragma mark - 功能

- (void)getAskList
{
    __weak typeof(self) weakSelf = self;
    
    [[UserDataManager shareInstance] getAskWithpage:_currentPage finish:^(NSArray *dataArr, BOOL isEnd) {
            
        if (dataArr) { //请求成功
            
            if (dataArr.count > 0) { //有数据
                
                if (weakSelf.currentPage == 1) {
                    [weakSelf.askArr removeAllObjects];
                }
                [weakSelf.askArr addObjectsFromArray:dataArr];
                [weakSelf.tableView reloadData];
                
            } else { //无数据
                
                if (weakSelf.askArr.count == 0) { //之前也无数据
                    [weakSelf end];
                }
                
            }
            
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (isEnd) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_footer endRefreshing];
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
    if (_askArr.count == 0) {
        _tableView.hidden = YES;
        self.bgImageView.hidden = NO;
    }
    //没有更多了
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _askArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    if (indexPath.section < _askArr.count) { //崩溃
        AskDataModel *model = _askArr[indexPath.section];
        
        //传问题模型
        MainAskDetailViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailViewController" owner:self options:nil].firstObject;
        VC.model = model;
        VC.Type = PushType_MyAsk;
//        self.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:VC animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
