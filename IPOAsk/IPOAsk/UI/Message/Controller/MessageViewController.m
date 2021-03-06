//
//  MessageViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MessageViewController.h"

//Controller
#import "MainAskDetailViewController.h"
#import "MainAskCommViewController.h"

//View
#import "AnswerOrLikeTableViewCell.h" 

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSMutableArray *contentArr;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger startQuestionID;

@end

static NSString * CellIdentifier = @"AOrLikeCell";

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息";
    
    [self setupNavBar];
    [self setupInterface];
    
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
    
    [_contentTableView.mj_header beginRefreshing];
}


#pragma mark - 界面

- (void)setupNavBar {
    
//    UIImage *img = [[UIImage imageNamed:@"消息-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.navigationController.tabBarItem setSelectedImage:img];
//    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
}

- (void)setupInterface {
    
    _startQuestionID = 0;
    _currentPage = 0;
    _contentArr = [NSMutableArray array];
    
    if (@available(iOS 11.0, *)) {
        _contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _contentTableView.backgroundColor = [UIColor whiteColor];
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedRowHeight = 9999;
    _contentTableView.tableHeaderView = [[UIView alloc] init];
    _contentTableView.tableFooterView = [[UIView alloc] init];
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    
    __weak typeof(self) weakSelf = self;
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < 0) {
            weakSelf.currentPage = 0;
        }
        weakSelf.currentPage++;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    _contentTableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        weakSelf.startQuestionID = 0;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    _contentTableView.mj_header = header;
    
    [_contentTableView registerNib:[UINib nibWithNibName:@"AnswerOrLikeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
}


#pragma mark - 功能

- (void)requestContent:(NSInteger)page {
    
    __weak typeof(self) weakSelf = self;
    UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
    
    NSDictionary *infoDic = @{@"cmd":@"getNotice",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"pageSize":@(20),
                              @"page":@(page),
                              @"maxNID":@(_startQuestionID)
                              };
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN(^{
            
            NSDictionary *resultDic = response;
            BOOL isSuccess = (resultDic && [resultDic[@"status"] intValue] == 1) ? YES : NO;
            
            if (isSuccess) {
                
                if (page == 1) {
                    [weakSelf.contentArr removeAllObjects];
                    AnswerOrLikeModel *mod = [[AnswerOrLikeModel alloc] init];
                    [mod refreshModel:[resultDic[@"data"][@"data"] firstObject]];
                    weakSelf.startQuestionID = [mod.messageID integerValue];
                }
                
                for (NSDictionary *tempDic in resultDic[@"data"][@"data"]) {
                    
                    AnswerOrLikeModel *model = [[AnswerOrLikeModel alloc] init];
                    [model refreshModel:tempDic];
                    
                    [weakSelf.contentArr addObject:model];
                    
                    if ([userMod userType] == loginType_NoLogin && weakSelf.contentArr.count == 5) {
                        [weakSelf.contentTableView reloadData];
                        
                        if (weakSelf.contentTableView.mj_header.isRefreshing) {
                            [weakSelf.contentTableView.mj_header endRefreshing];
                        }
                        if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                            [weakSelf.contentTableView.mj_footer endRefreshing];
                        }
                        return ;
                    }
                }
                
                [weakSelf.contentTableView reloadData];
                
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
            
        });
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            weakSelf.currentPage--;
            
            [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerOrLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row < _contentArr.count) {
        AnswerOrLikeModel *model = _contentArr[indexPath.row];
        if (model) {
            [cell updateWithModel:model];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _contentArr.count) {
        
        AnswerOrLikeModel *model = _contentArr[indexPath.row];
        
        switch (model.infoType) {
            case ContentType_Follow:
            {
                //传问题模型
                MainAskDetailViewController *askDetailVC = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailViewController" owner:self options:nil].firstObject;
                askDetailVC.questionID = model.questionID;
                [self.navigationController pushViewController:askDetailVC animated:YES];
            }
                break;
            default:
            {
                //传问题模型
                MainAskCommViewController *askCommVC = [[NSBundle mainBundle] loadNibNamed:@"MainAskCommViewController" owner:self options:nil].firstObject;
                askCommVC.questionID = model.questionID;
                askCommVC.answerID = model.answerID;
                [self.navigationController pushViewController:askCommVC animated:YES];
            }
                break;
        }
        
    }
}

@end
