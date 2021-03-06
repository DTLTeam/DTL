//
//  EnterpriseViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseViewController.h"

#import "UserDataManager.h"

//Controller
#import "BaseTabBarViewController.h"
#import "ApplicationEnterpriseViewController.h"
#import "EditQuestionViewController.h"

//View
#import "NotEnterpriseView.h"
#import "EnterpriseNotQuestionView.h"
#import "EnterpriseTableViewCell.h"

static NSString * CellIdentifier = @"EnterpriseCell";

@interface EnterpriseViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) EnterpriseNotQuestionView *notQusetionView;
@property (strong, nonatomic) NotEnterpriseView *notEnterpriseView;

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSMutableArray *contentArr;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger startQuestionID;

@end

@implementation EnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"企业+";
    
    [self setupTabBar];
    [self setupViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showNavBar];
    [self hiddenSearchNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showNavBar];
    [self hiddenSearchNavBar];
    
    UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
    if (userMod && (userMod.userType == loginType_Enterprise)) { //企业用户
        
        if (_contentArr.count > 0) { //有提问数据
            _notEnterpriseView.hidden = YES;
            _notQusetionView.hidden = YES;
            _contentTableView.hidden = NO;
        } else if (self.currentPage > 0) { //无提问数据且请求过
            _notEnterpriseView.hidden = YES;
            _notQusetionView.hidden = NO;
            _contentTableView.hidden = YES;
        }
        
        if (_currentPage < 1) {
            _notEnterpriseView.hidden = YES;
            _notQusetionView.hidden = YES;
            _contentTableView.hidden = NO;
            [_contentTableView.mj_header beginRefreshing];
        }
        
    } else { //非企业用户
        
        _notEnterpriseView.hidden = NO;
        _notQusetionView.hidden = YES;
        _contentTableView.hidden = YES;
        
    }
    
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        
        GCD_MAIN(^{
            BaseTabBarViewController *base = (BaseTabBarViewController *)self.tabBarController;
            base.selectedIndex = base.lastSelectedIndex;
        });
        
    }
    
}


#pragma mark - 界面

- (void)setupTabBar {
    
    UIImage *img = [[UIImage imageNamed:@"企业-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
}

- (void)setupViews {
    
    _contentArr = [NSMutableArray array];
    _currentPage = 0;
    _startQuestionID = 0;
    
    __weak typeof(self) weakSelf = self;
    
    _notQusetionView  = [[NSBundle mainBundle] loadNibNamed:@"EnterpriseNotQuestionView" owner:self options:nil][0];
    _notQusetionView.addQuestionClickBlock = ^(UIButton *sender) {
        //点击发布问题
        [weakSelf Consultation];
    };
    [self.view addSubview:_notQusetionView];
    
    [_notQusetionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.view);
    }];
    
    _notEnterpriseView = [[NSBundle mainBundle] loadNibNamed:@"NotEnterpriseView" owner:self options:nil][0];
    [self.view addSubview:_notEnterpriseView];
    
    [_notEnterpriseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.view);
    }];
    
    _contentTableView.backgroundColor = HEX_RGBA_COLOR(0xF2F2F2, 1);
    if (@available(iOS 11.0, *)) {
        _contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    _contentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedRowHeight = 9999;
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < 0) {
            weakSelf.currentPage = 0;
        }
        weakSelf.currentPage++;
        [weakSelf requestContent];
    }];
    _contentTableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        [weakSelf.contentArr removeAllObjects];
        [weakSelf.contentTableView reloadData];
        weakSelf.currentPage = 1;
        weakSelf.startQuestionID = 0;
        [weakSelf requestContent];
    }];
    _contentTableView.mj_header = header;
    
}


#pragma mark - 事件响应

#pragma mark 马上咨询专家
- (void)Consultation {
    //未登录
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        return;
    }
    
    self.tabBarController.tabBar.hidden = YES;
    EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
    [VC UserType:AnswerType_AskQuestionEnterprise NavTitle:@"企业+"];
    [self.navigationController pushViewController:VC animated:YES];
    
}


#pragma mark - 功能

- (void)requestContent {
    
    __weak typeof(self) weakSelf = self;
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    
    NSDictionary *infoDic = @{@"cmd":@"getCompanyQuestion",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"pageSize":@20,
                              @"page":@(self.currentPage),
                              @"maxQID":@(_startQuestionID)
                              };
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            
            if (response && ([response[@"status"] intValue] == 1)) {
                
                if (weakSelf.currentPage == 1) {
                    [weakSelf.contentArr removeAllObjects];
                    AskDataModel *mod = [[AskDataModel alloc] init];
                    [mod refreshModel:[response[@"data"][@"data"] firstObject]];
                    
                    weakSelf.startQuestionID = [mod.askID integerValue];
                }
                
                for (NSDictionary *dic in response[@"data"][@"data"]) {
                    
                    AskDataModel *model = [[AskDataModel alloc] init];
                    [model refreshModel:dic];
                    [model refreshAnswerItmes:dic[@"answer"]];
                    [weakSelf.contentArr addObject:model];
                    
                }
                
                [weakSelf.contentTableView reloadData];
                
                if (weakSelf.contentArr.count == 0) {
                    _notEnterpriseView.hidden = YES;
                    _notQusetionView.hidden = NO;
                    _contentTableView.hidden = YES;
                } else {
                    _notEnterpriseView.hidden = YES;
                    _notQusetionView.hidden = YES;
                    _contentTableView.hidden = NO;
                }
                
            } else {
                
                weakSelf.currentPage--;
                
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"加载失败" viewtag:1 AfterDelay:1.5];
                
            }
            
            if (weakSelf.contentTableView.mj_header.isRefreshing) {
                [weakSelf.contentTableView.mj_header endRefreshing];
            }
            if (response && ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue])) {
                [weakSelf.contentTableView.mj_footer endRefreshingWithNoMoreData];
            } else if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                [weakSelf.contentTableView.mj_footer endRefreshing];
            }
            
        }));
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            weakSelf.currentPage--;
            
            if (weakSelf.contentTableView.mj_header.isRefreshing) {
                [weakSelf.contentTableView.mj_header endRefreshing];
            }
            if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                [weakSelf.contentTableView.mj_footer endRefreshing];
            }
        });
        
    }];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EnterpriseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[EnterpriseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < _contentArr.count) {
        
        
        AskDataModel *model = _contentArr[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        [cell updateWithModel:model likeClick:^(NSInteger index) {
            
            AnswerDataModel *mod = model.answerItems[index];
            
            UserDataModel *userMod = [UserDataManager shareInstance].userModel;
            NSDictionary *infoDic = @{@"cmd":@"addLike",
                                      @"userID":(userMod ? userMod.userID : @""),
                                      @"aID":mod.answerID,
                                      };
            [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
                
                GCD_MAIN(^{
                    
                    [AskProgressHUD AskHideAnimatedInView:self.view.window viewtag:1 AfterDelay:0];
                    
                    if (response && ([response[@"status"] intValue] == 1)) {
                        
                        NSDictionary *dic = response[@"data"];
                        
                        //点击事件请求成功
                        [mod changeLikeStatus:[dic[@"isLike"] boolValue] count:[dic[@"likeCount"] integerValue]];
                        [weakSelf.contentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                        
                    } else {
                        
                        [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:response[@"msg"] viewtag:1 AfterDelay:1.5];
                        
                    }
                    
                });
                
            } requestHead:nil faile:^(NSError *error) {
                
                GCD_MAIN(^{
                    [AskProgressHUD AskHideAnimatedInView:self.view.window viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
                });
                
            }];
            
        }];
    }
    
    
    return cell;
}

@end

