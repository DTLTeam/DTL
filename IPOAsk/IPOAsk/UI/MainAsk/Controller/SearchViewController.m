//
//  SearchViewController.m
//  IPOAsk
//
//  Created by updrv on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SearchViewController.h"

//Controller
#import "MainNavigationController.h"
#import "EditQuestionViewController.h"
#import "MainAskDetailViewController.h"

//View
#import "QuestionTableViewCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MainNavigationControllerDelegate, QuestionTableViewCellDelegate>

//搜索内容
@property (strong, nonatomic) UIView        *searchContentView;
@property (strong, nonatomic) UITableView   *historyTableView;
@property (strong, nonatomic) UITableView   *searchNetworkTableView;
@property (strong, nonatomic) UIView        *searchFailView;

@property (strong, nonatomic) NSMutableArray *historyItems;
@property (strong, nonatomic) NSMutableArray *searchNetworkItems;

@property (nonatomic) NSInteger startQuestionID;
@property (nonatomic) NSInteger curSearchPage;
@property (strong, nonatomic) NSString *searchContent;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    [self setupInterface];
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
    
    //限制同时只存在一个搜索类页面
    NSInteger count = 0;
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[self class]]) {
            count++;
        }
    }
    if (count > 1) {
        NSMutableArray *vcItems = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        NSInteger removeIndex = 0;
        for (id vc in vcItems.reverseObjectEnumerator) { //从页面数组的末尾开始向前移除
            if ([vc isKindOfClass:[self class]]) {
                if (removeIndex != 0) { //保留最后一个显示的搜索页面
                    [vcItems removeObject:vc];
                }
                removeIndex++;
            }
        }
        self.navigationController.viewControllers = vcItems;
    }
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController showSearchNavBar:YES];
    }
    
    _historyItems = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"history_search_items"]];
    [_historyTableView reloadData];
    [_searchNetworkItems removeAllObjects];
    [_historyTableView reloadData];
    [_searchNetworkTableView reloadData];
    
    _historyTableView.hidden = NO;
    _searchNetworkTableView.hidden = YES;
    _searchFailView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        
        MainNavigationController *mainNav = (MainNavigationController *)self.navigationController;
        mainNav.searchDelegate = self;
        [mainNav.searchTextField becomeFirstResponder];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        
        MainNavigationController *mainNav = (MainNavigationController *)self.navigationController;
        mainNav.searchDelegate = nil;
        [mainNav.searchTextField resignFirstResponder];
        
    }
}


#pragma mark - 界面

- (void)setupInterface {
    
    _historyItems = [NSMutableArray array];
    _searchNetworkItems = [NSMutableArray array];
    _startQuestionID = 0;
    
    _searchContentView = [[UIView alloc] init];
    _searchContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchContentView];
    
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _historyTableView.backgroundColor = _searchContentView.backgroundColor;
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _historyTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _historyTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _historyTableView.tableHeaderView = [[UIView alloc] init];
    _historyTableView.tableFooterView = [[UIView alloc] init];
    [_searchContentView addSubview:_historyTableView];
    
    _searchNetworkTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _searchNetworkTableView.backgroundColor = HEX_RGBA_COLOR(0xF1F1F1, 1);
    _searchNetworkTableView.delegate = self;
    _searchNetworkTableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _searchNetworkTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _searchNetworkTableView.tableHeaderView = [[UIView alloc] init];
    _searchNetworkTableView.tableFooterView = [[UIView alloc] init];
    [_searchContentView addSubview:_searchNetworkTableView];
    
    _searchNetworkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchNetworkTableView.rowHeight = UITableViewAutomaticDimension;
    _searchNetworkTableView.estimatedRowHeight = 9999;
    
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (_curSearchPage < 0) {
            _curSearchPage = 0;
        }
        [self requestSearchInfo:_searchContent page:_curSearchPage];
    }];
    [footer setUpGifImage:@"上拉刷新"];
    _searchNetworkTableView.mj_footer = footer;
    
    _searchFailView = [[UIView alloc] init];
    _searchFailView.backgroundColor = _searchContentView.backgroundColor;
    [_searchContentView addSubview:_searchFailView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(hideKeyboard:)];
    _searchFailView.userInteractionEnabled = YES;
    [_searchFailView addGestureRecognizer:tap];
    
    UIImageView *failImgView = [[UIImageView alloc] init];
    failImgView.image = [UIImage imageNamed:@"没有提问.png"];
    failImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_searchFailView addSubview:failImgView];
    
    UILabel *failTextLabel = [[UILabel alloc] init];
    failTextLabel.textAlignment = NSTextAlignmentCenter;
    failTextLabel.font = [UIFont systemFontOfSize:13];
    failTextLabel.textColor = HEX_RGBA_COLOR(0x666666, 1);
    failTextLabel.text = @"你要找的问题还没有人提问过，马上去咨询小伙伴";
    [_searchFailView addSubview:failTextLabel];
    
    UIButton *putQuestionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    putQuestionBtn.backgroundColor = HEX_RGBA_COLOR(0x0A98F2, 1);
    putQuestionBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [putQuestionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [putQuestionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [putQuestionBtn setTitle:@"去提问" forState:UIControlStateNormal];
    [putQuestionBtn addTarget:self action:@selector(putQuestionAction:) forControlEvents:UIControlEventTouchUpInside];
    putQuestionBtn.layer.masksToBounds = YES;
    putQuestionBtn.layer.cornerRadius = 5;
    [_searchFailView addSubview:putQuestionBtn];
    
    
    [_searchContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    [_historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchContentView.mas_top);
        make.left.equalTo(_searchContentView.mas_left);
        make.right.equalTo(_searchContentView.mas_right);
        make.bottom.equalTo(_searchContentView.mas_bottom);
    }];
    
    [_searchNetworkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchContentView.mas_top);
        make.left.equalTo(_searchContentView.mas_left);
        make.right.equalTo(_searchContentView.mas_right);
        make.bottom.equalTo(_searchContentView.mas_bottom);
    }];
    
    [_searchFailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchContentView.mas_top);
        make.left.equalTo(_searchContentView.mas_left);
        make.right.equalTo(_searchContentView.mas_right);
        make.bottom.equalTo(_searchContentView.mas_bottom);
    }];
    
    [failImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_searchFailView.mas_centerX).offset(25);
        make.centerY.equalTo(_searchFailView.mas_centerY).offset(-90);
        make.width.offset(140);
        make.height.offset(110);
    }];
    
    [failTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(failImgView.mas_bottom).offset(10);
        make.left.equalTo(_searchFailView.mas_left).offset(20);
        make.right.equalTo(_searchFailView.mas_right).offset(-20);
    }];
    
    [putQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(failTextLabel.mas_bottom).offset(10);
        make.centerX.equalTo(_searchFailView.mas_centerX);
        make.width.offset(206);
        make.height.offset(44);
    }];
    
}


#pragma mark - 事件响应

#pragma mark 发布问题
- (void)putQuestionAction:(id)sender {
    
    EditQuestionViewController *editQuestionVC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:nil options:nil].firstObject;
    [editQuestionVC UserType:AnswerType_AskQuestionPerson NavTitle:@"提问"];
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
    [self.navigationController pushViewController:editQuestionVC animated:YES];
    
}

#pragma mark 隐藏键盘
- (void)hideKeyboard:(id)sender {
    
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        
        UITextField *searchTextField = ((MainNavigationController *)self.navigationController).searchTextField;
        if (searchTextField.isEditing) {
            [searchTextField resignFirstResponder];
        }
        
    }
    
}

#pragma mark 删除历史搜索
- (void)deleteHistoryAction:(id)sender {
    
    UITableViewCell *cell = (UITableViewCell *)((UIButton *)sender).superview;
    NSIndexPath *indexPath = [_historyTableView indexPathForCell:cell];
    
    NSString *question = _historyItems[indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyItems = [NSMutableArray arrayWithArray:[defaults objectForKey:@"history_search_items"]];
    
    if ([historyItems containsObject:question]) {
        [historyItems removeObject:question];
    }
    
    [defaults setObject:historyItems forKey:@"history_search_items"];
    [defaults synchronize];
    
    _historyItems = historyItems;
    [_historyTableView reloadData];
    
}


#pragma mark - 功能

#pragma mark 搜索问题
- (void)requestSearchInfo:(NSString *)questionTitle page:(NSInteger)page {
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *infoDic = @{@"cmd":@"getQuestionIndex",
                              @"userID":@"90b333b92b630b472467b9b4ccbe42a4",
                              @"pageSize":@20,
                              @"page":@(page),
                              @"keyword":questionTitle,
                              @"maxQID":@(_startQuestionID)
                              };
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN(^{
            
            if (response && ([response[@"status"] integerValue] == 1)) {
                
                if (page == 0) {
                    [weakSelf.searchNetworkItems removeAllObjects];
                    QuestionModel *mod = [[QuestionModel alloc] init];
                    [mod refreshModel:[response[@"data"][@"data"] firstObject]];
                    weakSelf.startQuestionID = [mod.questionID integerValue];
                }
                weakSelf.curSearchPage = page;
                weakSelf.curSearchPage++;
                
                for (NSDictionary *dic in response[@"data"][@"data"]) {
                    QuestionModel *mod = [[QuestionModel alloc] init];
                    [mod refreshModel:dic];
                    [weakSelf.searchNetworkItems addObject:mod];
                }
                
            }
            
            [weakSelf.searchNetworkTableView reloadData];
            
            if (page == 0 && weakSelf.searchNetworkItems.count > 0
                && questionTitle.length > 0
                && weakSelf.searchContent.length > 0) {
                weakSelf.historyTableView.hidden = YES;
                weakSelf.searchNetworkTableView.hidden = NO;
                weakSelf.searchFailView.hidden = YES;
            } else {
                weakSelf.historyTableView.hidden = YES;
                weakSelf.searchNetworkTableView.hidden = YES;
                weakSelf.searchFailView.hidden = NO;
            }
            
        });
        
        if (weakSelf.searchNetworkTableView.mj_footer.isRefreshing) {
            if ([response[@"data"][@"current_page"] integerValue] != [response[@"data"][@"last_page"] integerValue]) {
                [weakSelf.searchNetworkTableView.mj_footer endRefreshing];
            } else {
                [weakSelf.searchNetworkTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
        GCD_MAIN(^{
            if (weakSelf.searchNetworkTableView.mj_footer.isRefreshing) {
                [weakSelf.searchNetworkTableView.mj_footer endRefreshing];
            }
        });
        
    }];
    
}


#pragma mark - MainNavigationControllerDelegate

- (void)searchTextChange:(NSString *)text {
    
    _searchContent = text;
    [_searchNetworkItems removeAllObjects];
    [_searchNetworkTableView reloadData];
    
    if (_searchContent.length == 0) {
        
        _historyTableView.hidden = NO;
        _searchNetworkTableView.hidden = YES;
        _searchFailView.hidden = YES;
        
    }
    
}

- (void)beginSearch {
    
    if (_searchContent.length > 0) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *tempItems = [NSMutableArray arrayWithArray:[defaults objectForKey:@"history_search_items"]];
        if ([tempItems containsObject:_searchContent]) {
            [tempItems removeObject:_searchContent];
        }
        [tempItems insertObject:_searchContent atIndex:0];
        
        [defaults setObject:tempItems forKey:@"history_search_items"];
        [defaults synchronize];
        
        _historyItems = tempItems;
        [_historyTableView reloadData];
        
        [_searchNetworkItems removeAllObjects];
        [_searchNetworkTableView reloadData];
        
        _curSearchPage = 0;
        _startQuestionID = 0;
        [_searchNetworkTableView.mj_footer beginRefreshing];
        
    }
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self hideKeyboard:nil];
    
}


#pragma mark - QuestionTableViewCellDelegate

- (void)attentionWithCell:(QuestionTableViewCell *)cell {
    
    NSIndexPath *indexPath = [_searchNetworkTableView indexPathForCell:cell];
    QuestionModel *mod = _searchNetworkItems[indexPath.section];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *infoDic = @{@"cmd":@"addFollow",
                              @"userID":@"90b333b92b630b472467b9b4ccbe42a4",
                              @"qID":mod.questionID,
                              };
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN(^{
            
            if (response && ([response[@"status"] intValue] == 1)) {
                
                NSDictionary *dic = response[@"data"];
                
                //点击事件请求成功
                [mod changeAttentionStatus:[dic[@"isFollow"] boolValue] count:[dic[@"followCount"] integerValue]];
                [weakSelf.searchNetworkTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        });
        
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
        
        
    }];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == _historyTableView) {
        return 1;
    } else {
        return _searchNetworkItems.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _historyTableView) {
        return _historyItems.count;
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _historyTableView) {
        return 50;
    } else {
        return 10;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _historyTableView) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(headerView.frame))];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
        titleLabel.text = @"搜索历史";
        [headerView addSubview:titleLabel];
        
        return headerView;
        
    } else {
        return [[UIView alloc] init];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _historyTableView) {
        return 49;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    if (tableView == _historyTableView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
            cell.imageView.image = [UIImage imageNamed:@"搜索历史.png"];
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(0, 0, 40, 40);
            [deleteBtn setImage:[UIImage imageNamed:@"删除搜索历史.png"] forState:UIControlStateNormal];
            [deleteBtn setImage:[UIImage imageNamed:@"删除搜索历史.png"] forState:UIControlStateHighlighted];
            [deleteBtn addTarget:self action:@selector(deleteHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = deleteBtn;
        }
        
        cell.textLabel.text = _historyItems[indexPath.row];
        
        return cell;
        
    } else {
        
        QuestionTableViewCell *cell = [_searchNetworkTableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Main:YES];
            cell.delegate = self;
        }
        
        QuestionModel *mod = _searchNetworkItems[indexPath.section];
        cell.searchContent = _searchContent;
        [cell refreshWithModel:mod];
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hideKeyboard:nil];
    
    if (tableView == _historyTableView) { //历史搜索
        
        NSString *question = _historyItems[indexPath.row];
        
        _curSearchPage = 0;
        _searchContent = question;
        if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
            MainNavigationController *mainNav = (MainNavigationController *)self.navigationController;
            _searchContent = question;
            mainNav.searchTextField.text = _searchContent;
        }
        
        NSMutableArray *tempItems = [NSMutableArray arrayWithArray:_historyItems];
        [tempItems removeObject:question];
        [tempItems insertObject:question atIndex:0];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tempItems forKey:@"history_search_items"];
        [defaults synchronize];
        
        _historyItems = tempItems;
        [_historyTableView reloadData];
        
        [_searchNetworkTableView.mj_footer beginRefreshing];
        
    } else { //网络搜索
        
        QuestionModel *mod = _searchNetworkItems[indexPath.section];
        
        MainAskDetailViewController *mainAskDetailVC = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailViewController" owner:nil options:nil].firstObject;
        mainAskDetailVC.model = mod;
        [self.navigationController pushViewController:mainAskDetailVC animated:YES];
        
    }
    
    
}

@end
