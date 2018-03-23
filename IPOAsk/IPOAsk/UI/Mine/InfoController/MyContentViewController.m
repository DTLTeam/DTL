//
//  MyContentViewController.m
//  IPOAsk
//
//  Created by updrv on 2018/3/21.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyContentViewController.h"

#import "UserDataManager.h"

//View
#import "FollowTableViewCell.h"
#import "LikeTableViewCell.h"

@interface MyContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *bgErrorView;
@property (strong, nonatomic) UIImageView *bgErrorImageView;
@property (strong, nonatomic) UILabel *bgErrorTitleLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *contentItems;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation MyContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (_vcType) {
        case kMyContentQuestion:
        {
            self.title = @"我的提问";
        }
            break;
        case kMyContentAnswer:
        {
            self.title = @"我的回答";
        }
            break;
        case kMyContentFollow:
        {
            self.title = @"我的关注";
        }
            break;
        case kMyContentLike:
        {
            self.title = @"我的点赞";
        }
            break;
        default:
            break;
    }
    
    self.view.backgroundColor = HEX_RGBA_COLOR(0xF1F1F1, 1);
    
    [self setUpNavBgColor:nil RightBtn:nil];
    [self initInterface];
    [self initBGErrorView];
    
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
    
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 界面

- (void)initInterface {
    
    if (_vcType == kMyContentQuestion || _vcType == kMyContentAnswer) {
        self.view.backgroundColor = HEX_RGBA_COLOR(0xF1F1F1, 1);
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    _currentPage = 0;
    _contentItems = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    if (_vcType == kMyContentQuestion || _vcType == kMyContentAnswer) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 9999;
    } else {
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.estimatedRowHeight = 0;
    }
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < 0) {
            weakSelf.currentPage = 0;
        }
        weakSelf.currentPage++;
        [weakSelf requestContentList];
    }];
    _tableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        [weakSelf.contentItems removeAllObjects];
        [weakSelf.tableView reloadData];
        weakSelf.currentPage = 1;
        [weakSelf requestContentList];
    }];
    _tableView.mj_header = header;
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.bottom.left.right.equalTo(self.view);
        }
    }];
    
}

- (void)initBGErrorView {
    
    _bgErrorView = [[UIView alloc] init];
    _bgErrorView.backgroundColor = HEX_RGBA_COLOR(0xF1F1F1, 1);
    _bgErrorView.userInteractionEnabled = YES;
    [self.view addSubview:_bgErrorView];
    _bgErrorView.hidden = YES;
    
    //无数据背景图
    _bgErrorImageView = [[UIImageView alloc] init];
    _bgErrorImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgErrorImageView.image = [UIImage imageNamed:@"没有提问.png"];
    [_bgErrorView addSubview:_bgErrorImageView];
    
    _bgErrorTitleLabel = [[UILabel alloc]init];
    _bgErrorTitleLabel.textAlignment = NSTextAlignmentCenter;
    _bgErrorTitleLabel.numberOfLines = 0;
    [_bgErrorView addSubview:_bgErrorTitleLabel];
    
    switch (_vcType) {
        case kMyContentQuestion:
        {
            _bgErrorTitleLabel.text = @"暂无提问哦!";
        }
            break;
        case kMyContentAnswer:
        {
            _bgErrorTitleLabel.text = @"暂无回答哦!";
        }
            break;
        case kMyContentFollow:
        {
            _bgErrorTitleLabel.text = @"暂无关注哦!";
        }
            break;
        case kMyContentLike:
        {
            _bgErrorTitleLabel.text = @"暂无成就哦!";
        }
            break;
        default:
            break;
    }
    
    
    [_bgErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [_bgErrorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgErrorView.mas_centerX).offset(25);
        make.centerY.equalTo(_bgErrorView.mas_centerY).offset(-50);
    }];
    
    [_bgErrorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgErrorView.mas_centerX);
        make.top.equalTo(_bgErrorImageView.mas_bottom).offset(20);
    }];
    
}


#pragma mark - 功能

- (void)requestContentList {
    
    __weak typeof(self) weakSelf = self;
    
    switch (_vcType) {
        case kMyContentQuestion:
        {
            [[UserDataManager shareInstance] getAskWithpage:_currentPage finish:^(NSArray *dataArr, BOOL isEnd) {
                
                [weakSelf requestResultWithData:dataArr isEnd:isEnd];
                
            } fail:^(NSError *error) {
                
                [weakSelf requestError:error];
                
            }];
        }
            break;
        case kMyContentAnswer:
        {
            [[UserDataManager shareInstance] getAnswerWithpage:_currentPage finish:^(NSArray *dataArr, BOOL isEnd) {
                
                [weakSelf requestResultWithData:dataArr isEnd:isEnd];
                
            } fail:^(NSError *error) {
                
                [weakSelf requestError:error];
                
            }];
        }
            break;
        case kMyContentFollow:
        {
            [[UserDataManager shareInstance] getFollowWithpage:_currentPage finish:^(NSArray *dataArr, BOOL isEnd) {
                
                [weakSelf requestResultWithData:dataArr isEnd:isEnd];
                
            } fail:^(NSError *error) {
                
                [weakSelf requestError:error];
                
            }];
        }
            break;
        case kMyContentLike:
        {
            [[UserDataManager shareInstance] getLikeWithpage:_currentPage finish:^(NSArray *dataArr, BOOL isEnd) {
                
                [weakSelf requestResultWithData:dataArr isEnd:isEnd];
                
            } fail:^(NSError *error) {
                
                [weakSelf requestError:error];
                
            }];
        }
            break;
        default:
            break;
    }
    
}

- (void)requestResultWithData:(NSArray *)dataArr isEnd:(BOOL)isEnd {
    
    if (dataArr) { //请求成功
        
        if (dataArr.count > 0) { //有数据
            
            if (_currentPage == 1) {
                [_contentItems removeAllObjects];
            }
            [_contentItems addObjectsFromArray:dataArr];
            [_tableView reloadData];
            
        } else { //无数据
            
            if (_contentItems.count == 0) { //之前也无数据
                _tableView.hidden = YES;
                _bgErrorView.hidden = NO;
            }
            
        }
        
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (isEnd) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        } else if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        
    } else { //请求失败
        
        _currentPage--;
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:@"网络请求失败" viewtag:0 AfterDelay:1.5];
        
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        
    }
    
}

- (void)requestError:(NSError *)error {
    
    _currentPage--;
    
    [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:@"网络连接错误" viewtag:0 AfterDelay:1.5];
    
    if (_tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
    }
    if (_tableView.mj_footer.isRefreshing) {
        [_tableView.mj_footer endRefreshing];
    }
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _contentItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_vcType) {
        case kMyContentFollow:
        {
            return 60;
        }
            break;
        case kMyContentLike:
        {
            return 100;
        }
            break;
        default:
        {
            return UITableViewAutomaticDimension;
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_vcType == kMyContentQuestion || _vcType == kMyContentAnswer) {
        return 10;
    } else {
        return 1;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (_vcType == kMyContentQuestion || _vcType == kMyContentAnswer) {
        
        return [[UIView alloc] init];
        
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
        [view addSubview:line];
        return view;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    
    if (_vcType == kMyContentLike) {
        
        LikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[LikeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        if (_contentItems.count > indexPath.section) {
            [cell updateCell:_contentItems[indexPath.section]];
        }
        
        return cell;
        
    } else {
        
        FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FollowTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        if (_contentItems.count > indexPath.section) {
            [cell updateAskCell:_contentItems[indexPath.section]];
        }
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (_vcType) {
        case kMyContentQuestion:
        case kMyContentAnswer:
        {
            AskDataModel *model = _contentItems[indexPath.section];
            
            //传问题模型
            MainAskDetailViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailViewController" owner:self options:nil].firstObject;
            VC.questionID = model.askID;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case kMyContentFollow:
        {
            
        }
            break;
        case kMyContentLike:
        {
            
        }
            break;
        default:
            break;
    }
    
}

@end
