//
//  MainAskDetailViewController.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/2.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainAskDetailViewController.h"

#import "UserDataManager.h"

//Controller
#import "MainAskCommViewController.h"
#import "EditQuestionViewController.h"
#import "AnswerViewController.h"

//View
#import "AnswerTableViewCell.h"
#import "MainAskDetailHeadViewCellTableViewCell.h"

@interface MainAskDetailViewController () <UITableViewDelegate, UITableViewDataSource, AnswerTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSMutableArray *CommArr;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger startQuestionID;
@property (assign, nonatomic) BOOL all;

@end

@implementation MainAskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut) name:@"LoginOut" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showNavBar];
    [self showSearchNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showNavBar];
    [self showSearchNavBar];
    
    if (_currentPage < 1) { //未刷新过
        [_contentTableView.mj_header beginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_refreshBlock) {
        _refreshBlock(_model);
    }
}

- (void)dealloc {
    _refreshBlock = nil;
}


#pragma mark - 界面

- (void)setupInterface {
    
    _currentPage = 0;
    _startQuestionID = 0;
    _CommArr = [NSMutableArray array];
    
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedRowHeight = 9999;
    __weak typeof(self) weakSelf = self;
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    self.contentTableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        weakSelf.startQuestionID = 0;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    self.contentTableView.mj_header = header;
    
}


#pragma mark - 功能

#pragma mark 请求列表内容
- (void)requestContent:(NSInteger)page {
    
    __weak typeof(self) weakSelf = self;
    
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    NSDictionary *infoDic = @{@"cmd":@"getQuestionByQID",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"qID":weakSelf.model.askID,
                              @"pageSize":@20,
                              @"page":@(page),
                              @"maxQID":@(_startQuestionID)
                              };
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
        
            if (response && ([response[@"status"] intValue] == 1)) {

                if (page == 1) {
                    [weakSelf.CommArr removeAllObjects];
                    AnswerDataModel *mod = [[AnswerDataModel alloc] init];
                    [mod refreshModel:[[response valueForKey:@"data"] valueForKey:@"question"]];
                    weakSelf.startQuestionID = [mod.answerID integerValue];
                }

                if ([[response valueForKey:@"data"]valueForKey:@"question"]) {
                    
                    [weakSelf.model refreshModel:[[response valueForKey:@"data"]valueForKey:@"question"]];
                    
                }

                for (NSDictionary *dic in [[[response valueForKey:@"data"]valueForKey:@"answer"] valueForKey:@"data"]) {
                    AnswerDataModel *model = [[AnswerDataModel alloc] init];
                    [model refreshModel:dic];
                    [weakSelf.CommArr addObject:model];
                }
                
                [weakSelf.contentTableView reloadData];

            } else {
                
                weakSelf.currentPage--;
                
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"加载失败" viewtag:1 AfterDelay:1.5];
                
            }
            
            
            if (weakSelf.contentTableView.mj_header.isRefreshing) {
                [weakSelf.contentTableView.mj_header endRefreshing];
            }
            if (response && ([response[@"data"][@"answer"][@"current_page"] integerValue] == [response[@"data"][@"answer"][@"last_page"] integerValue])) {
                [weakSelf.contentTableView.mj_footer endRefreshingWithNoMoreData];
            } else if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                [weakSelf.contentTableView.mj_footer endRefreshing];
            }
            
        }));
     
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            
            weakSelf.currentPage--;
            
            [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
            
            if (weakSelf.contentTableView.mj_header.isRefreshing) {
                [weakSelf.contentTableView.mj_header endRefreshing];
            }
            if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                [weakSelf.contentTableView.mj_footer endRefreshing];
            }
            
        });
        
    }];
    
    
}


#pragma mark - AnswerTableViewCellDelegate

- (void)likeWithCell:(AnswerTableViewCell *)cell {
    
    NSIndexPath *indexPath = [_contentTableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    AnswerDataModel *mod = [_CommArr objectAtIndex:(indexPath.section - 1)];
    
    __weak typeof(self) weakSelf = self;
    
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
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_CommArr.count == 0) {
        return  1;
    }
    return _CommArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_CommArr.count == 0) {//没有评论
        return 70;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_CommArr.count == 0) {//没有评论
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        label.text = @"还没有人回复这个问题，快去抢答助力小伙伴";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HEX_RGB_COLOR(0x969ca1);
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0) { //评论
        if (indexPath.section - 1 < _CommArr.count) {
            
            AnswerDataModel *model = _CommArr[indexPath.section - 1];
            
            MainAskCommViewController *VC = [[[NSBundle mainBundle] loadNibNamed:@"MainAskCommViewController" owner:self options:nil] firstObject];
            VC.questionTitle = _model.questionTitle;
            VC.answerMod = model;
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) { //问题内容
        
        MainAskDetailHeadViewCellTableViewCell *head  = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailHeadViewCellTableViewCell" owner:self options:nil][0];
        head.ContentLabel.numberOfLines = _all ? 0 : 5;
        
        __weak typeof(self) weakSelf = self;
        __weak UITableView *WeakTableView = tableView;
        
        [head UpdateContent:_model WithFollowClick:^(UIButton *btn) {
            
            UserDataModel *userMod = [UserDataManager shareInstance].userModel;
            NSDictionary *infoDic = @{@"cmd":@"addFollow",
                                      @"userID":(userMod ? userMod.userID : @""),
                                      @"qID":weakSelf.model.askID
                                      };
            [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
                
                GCD_MAIN(^{
                
                    if (response && ([response[@"status"] intValue] == 1)) {
                        
                        NSDictionary *dic = response[@"data"]; 
                        
                        //点击事件请求成功
                        [weakSelf.model changeAttentionStatus:[dic[@"isFollow"] boolValue] count:[dic[@"followCount"] integerValue]];
                        [weakSelf.contentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshData" object:nil];
                        
                    } else {
                        
                        [AskProgressHUD AskHideAnimatedInView:self.view.window viewtag:1 AfterDelay:0];
                        [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:response[@"msg"] viewtag:1 AfterDelay:1.5];
                        
                    }
                    
                });
             
            } requestHead:nil faile:^(NSError *error) {
                
                GCD_MAIN(^{
                    [AskProgressHUD AskHideAnimatedInView:self.view.window viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:self.view.window Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
                });
                
            }];
            
            
        } WithAnswerClick:^(UIButton *btn) {
            
            UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
            if (userMod.isAnswerer == 1) { //只有个人可以回答
                
                EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
                VC.questionID = weakSelf.model.askID;
                [VC UserType:AnswerType_Answer NavTitle:weakSelf.model.questionTitle];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            } else {
                TipsViews *alertView = [[TipsViews alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) HaveCancel:YES];
                [alertView showWithContent:@"申请成为答主才可以助力回复小伙伴的问题噢!" tipsImage:@"不是企业用户.png" LeftTitle:@"以后再说" RightTitle:@"申请成为答主" block:^(UIButton *btn) {
                    
                    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                        alertView.alpha = 0;
                        [alertView layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        [alertView removeFromSuperview];
                    }];
                    
                } rightblock:^(UIButton *btn) {
                    
                    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                        alertView.alpha = 0;
                        [alertView layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        [alertView removeFromSuperview];
                        
                        [weakSelf applyAnswerer];
                    }];
                    
                }];
                [weakSelf.view.window addSubview:alertView];
            }
            
        } WithAllClick:^(BOOL click) {
            weakSelf.all = YES;
            [WeakTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        return head;
        
    } else { //回复
    
        static NSString *identifier = @"AnswerTableViewCell";
        AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        if (indexPath.section - 1 < _CommArr.count) {
            [cell refreshWithModel:_CommArr[indexPath.section - 1]];
        }

        return cell;
        
    }
    
}


- (void)applyAnswerer{
    
    if ( [UserDataManager shareInstance].userModel.forbidden == 1) {
        TipsViews *tips = [[TipsViews alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) HaveCancel:YES];
        [self.view.window addSubview:tips];
        
        __weak TipsViews *WeakTips = tips;
        [tips showWithContent:@"由于您违反了用户管理协议，平台拒绝了您的答主申请" tipsImage:@"申请失败" LeftTitle:@"我知道了" RightTitle:@"联系我们" block:^(UIButton *btn) {
            [WeakTips dissmiss];
            
        } rightblock:^(UIButton *btn) {
            
            [UtilsCommon CallPhone];
        }];
        
        return;
        
    }else if ([USER_DEFAULT boolForKey: [UserDataManager shareInstance].userModel.userID]) {
        //已经申请过
        TipsViews *tips = [[TipsViews alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) HaveCancel:NO];
        
        [self.view.window addSubview:tips];
    
        __weak TipsViews *WeakTips = tips;
        
        [tips showWithContent:@"您已申请过答主,审核正在进行中,请耐心等待" tipsImage:@"正在审核中" LeftTitle:@"我知道了" RightTitle:nil block:^(UIButton *btn) {
            [WeakTips dissmiss];
            
        } rightblock:^(UIButton *btn) {
            
        }];
        
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AnswerViewController *answerVC = [sb instantiateViewControllerWithIdentifier:@"AnswerView"];
    [self.navigationController pushViewController:answerVC animated:YES];
    
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginOut{
    [self back];
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

@end
