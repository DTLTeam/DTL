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

@interface EnterpriseViewController ()

@property (strong, nonatomic) EnterpriseNotQuestionView *notQusetionView;
@property (strong, nonatomic) NotEnterpriseView *notEnterpriseView;

@property (assign, nonatomic) NSInteger startQuestionID;

@end

@implementation EnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [[UIImage imageNamed:@"企业-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.title = @"企业+";
    
    [self setupViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
    UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
    if (userMod && (userMod.userType == loginType_Enterprise)) { //企业用户
        
        if (self.sourceData.count > 0) { //有提问数据
            _notEnterpriseView.hidden = YES;
            _notQusetionView.hidden = YES;
            self.myTableView.hidden = NO;
        } else if (self.currentPage > 0) { //无提问数据且请求过
            _notEnterpriseView.hidden = YES;
            _notQusetionView.hidden = NO;
            self.myTableView.hidden = YES;
        }
        
    } else { //非企业用户
        
        _notEnterpriseView.hidden = NO;
        _notQusetionView.hidden = YES;
        self.myTableView.hidden = YES;
        
    }
    
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        
        GCD_MAIN(^{
            BaseTabBarViewController *base = (BaseTabBarViewController *)self.tabBarController;
            base.selectedIndex = base.lastSelectedIndex;
        });
    }
    
    if (self.currentPage < 1) {
        _notEnterpriseView.hidden = YES;
        _notQusetionView.hidden = YES;
        self.myTableView.hidden = NO;
        [self.myTableView.mj_header beginRefreshing];
    }
    
}


#pragma mark - 界面

- (void)setupViews {
    
    self.currentPage = 0;
    self.startQuestionID = 0;
    
    __weak typeof(self) weakSelf = self;
    
    _notQusetionView  = [[NSBundle mainBundle] loadNibNamed:@"EnterpriseNotQuestionView" owner:self options:nil][0];
    [self.bgImageView addSubview:_notQusetionView];
    
    [_notQusetionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.bgImageView);
    }];
    
    //点击发布问题
    _notQusetionView.addQuestionClickBlock = ^(UIButton *sender) {
        [weakSelf Consultation];
    };
    
    _notEnterpriseView = [[NSBundle mainBundle] loadNibNamed:@"NotEnterpriseView" owner:self options:nil][0];
    [self.bgImageView addSubview:_notEnterpriseView];
    
    [_notEnterpriseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.bgImageView);
    }];
    
    self.bgImageView.backgroundColor = [UIColor clearColor];
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < 0) {
            weakSelf.currentPage = 0;
        }
        weakSelf.currentPage++;
        [weakSelf requestContent];
    }];
    self.myTableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        [weakSelf.sourceData removeAllObjects];
        [weakSelf.myTableView reloadData];
        weakSelf.currentPage = 1;
        weakSelf.startQuestionID = 0;
        [weakSelf requestContent];
    }];
    self.myTableView.mj_header = header;
    
    self.myTableView.backgroundColor = HEX_RGBA_COLOR(0xF2F2F2, 1);
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 9999;
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }
    }];
    
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
                    [weakSelf.sourceData removeAllObjects];
                    EnterpriseModel *mod = [[EnterpriseModel alloc] init];
                    [mod refreshModel:[response[@"data"][@"data"] firstObject]];
                    weakSelf.startQuestionID = [mod.questionMod.questionID integerValue];
                }
                
                for (NSDictionary *dic in response[@"data"][@"data"]) {
                    
                    EnterpriseModel *model = [[EnterpriseModel alloc] init];
                    [model refreshModel:dic];
                    [weakSelf.sourceData addObject:model];
                    
                }
                
                [weakSelf.myTableView reloadData];
                
            } else {
                
                weakSelf.currentPage--;
                
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"加载失败" viewtag:1 AfterDelay:1.5];
                
            }
            
            if (weakSelf.myTableView.mj_header.isRefreshing) {
                [weakSelf.myTableView.mj_header endRefreshing];
            }
            if (response && ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue])) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            } else if (weakSelf.myTableView.mj_footer.isRefreshing) {
                [weakSelf.myTableView.mj_footer endRefreshing];
            }
            
        }));
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            weakSelf.currentPage--;
            
            if (weakSelf.myTableView.mj_header.isRefreshing) {
                [weakSelf.myTableView.mj_header endRefreshing];
            }
            if (weakSelf.myTableView.mj_footer.isRefreshing) {
                [weakSelf.myTableView.mj_footer endRefreshing];
            }
        });
        
    }];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sourceData.count;
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
    
    if (indexPath.row < self.sourceData.count) {
        
        __weak EnterpriseTableViewCell *weakCell = cell;
        EnterpriseModel *model = self.sourceData[indexPath.row];
        
        [cell updateWithModel:model likeClick:^(BOOL like, NSInteger index) {
            
            UserDataModel *userMod = [UserDataManager shareInstance].userModel;
            NSDictionary *infoDic = @{@"cmd":@"addLike",
                                      @"userID":(userMod ? userMod.userID : @""),
                                      @"aID":@""
                                      };
            [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
                
                GCD_MAIN(^{
                    
                    if (response && ([response[@"status"] intValue] == 1)) {
                        
//                        NSDictionary *dic = response[@"data"];
//
//                        if (dic[@""]) {
//                            model.Exper_haveLike = !model.Exper_haveLike;
//                            [weakCell likeClickSuccess];
//                        }
                        
                    }
                    
                });
                
            } requestHead:nil faile:^(NSError *error) {
                
            }];
            
        }];
    }
    
    
    return cell;
}

@end

