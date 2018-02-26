//
//  MainAskDetailViewController.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/2.
//  Copyright © 2018年 law. All rights reserved.
//

#define haveComm 1  //test****************有无评论

#import "MainAskDetailViewController.h"

#import "UserDataManager.h"

//Controller
#import "MainAskCommViewController.h"
#import "EditQuestionViewController.h"
#import "AnswerViewController.h"

//Model
#import "AnswerModel.h"

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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController showSearchNavBar:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (_currentPage < 0) { //未刷新过
        [_contentTableView.mj_header beginRefreshing];
    }
    
}


#pragma mark - 界面

- (void)setupInterface {
    
    _currentPage = -1;
    _CommArr = [NSMutableArray array];
    
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedRowHeight = 9999;
    __weak typeof(self) weakSelf = self;
    
    // 上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage <= 0) {
            weakSelf.currentPage = 0;
        }
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    [footer setUpGifImage:@"上拉刷新"];
    self.contentTableView.mj_footer = footer;
    
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    [header setUpGifImage:@"下拉加载"];
    self.contentTableView.mj_header = header;
    
}


#pragma mark - 功能

#pragma mark 请求列表内容
- (void)requestContent:(NSInteger)page {
   
    NSString *Id = @"";
    if (_Type == PushType_Main) {
        _model = (QuestionModel *)_model;
        Id = [_model questionID];
    }else if (_Type == PushType_MyAnswer){
        _model = (AskDataModel *)_model;
        Id = [_model askId];
    }
    
    __weak typeof(self) weakSelf = self;
    
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    NSDictionary *infoDic = @{@"cmd":@"getQuestionByQID",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"qID":Id,
                              @"pageSize":@20,
                              @"page":@(page),
                              @"maxQID":@(_startQuestionID)
                              };
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
        
            if (response && ([response[@"status"] intValue] == 1)) {

                if (page == 0) {
                    [weakSelf.CommArr removeAllObjects];
                    QuestionModel *mod = [[QuestionModel alloc] init];
                    [mod refreshModel:[response[@"data"][@"question"][@"data"] firstObject]];
                    weakSelf.startQuestionID = [mod.questionID integerValue];
                }
                weakSelf.currentPage = page;
                weakSelf.currentPage++;

                if (response[@"data"][@"question"]) {
                    if (weakSelf.Type == PushType_Main) {
                        weakSelf.model = (QuestionModel*)weakSelf.model;
                    }else if (weakSelf.Type == PushType_MyAnswer){
                        weakSelf.model = (AskDataModel *)weakSelf.model;
                    }
                    [weakSelf.model refreshModel:response[@"data"][@"question"]];
                }

                for (NSDictionary *dic in response[@"data"][@"answer"][@"data"]) {
                    AnswerModel *model = [[AnswerModel alloc] init];
                    [model refreshModel:dic];
                    [weakSelf.CommArr addObject:model];
                }

            }
            
            [_contentTableView reloadData];
            
            if (weakSelf.contentTableView.mj_header.isRefreshing) {
                [weakSelf.contentTableView.mj_header endRefreshing];
            }
            if (response && ([response[@"data"][@"answer"][@"current_page"] integerValue] == [response[@"data"][@"answer"][@"last_page"] integerValue])) {
                [weakSelf.contentTableView.mj_footer endRefreshingWithNoMoreData];
            } else if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                [weakSelf.contentTableView.mj_footer endRefreshing];
            }
            
        }));
     
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
        GCD_MAIN(^{
            
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
    AnswerModel *mod = [_CommArr objectAtIndex:(indexPath.section - 1)];
    
    __weak typeof(self) weakSelf = self;
    
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    NSDictionary *infoDic = @{@"cmd":@"addLike",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"qID":mod.answerID,
                              };
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN(^{
            
            if (response && ([response[@"status"] intValue] == 1)) {
                
                NSDictionary *dic = response[@"data"];
                
                //点击事件请求成功
                [mod changeLikeStatus:[dic[@"isLike"] boolValue] count:[dic[@"likeCount"] integerValue]];
                [weakSelf.contentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        });
        
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
    }];
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!haveComm) {
        return  1;
    }
    return _CommArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!haveComm) {//没有评论
        return 70;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!haveComm) {//没有评论
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
            
            AnswerModel *model = _CommArr[indexPath.section - 1];
            
            MainAskCommViewController *VC = [[[NSBundle mainBundle] loadNibNamed:@"MainAskCommViewController" owner:self options:nil] firstObject];
            VC.questionTitle = [_model title];
            VC.answerMod = model;
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) { //问题内容
        
        MainAskDetailHeadViewCellTableViewCell *head  = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailHeadViewCellTableViewCell" owner:self options:nil][0];
        head.ContentLabel.numberOfLines = _all ? 0 : 5;
        
        __weak MainAskDetailViewController *WeakSelf = self;
        __weak UITableView *WeakTableView = tableView;
        __weak QuestionModel *WeakModel = _model;
        
        __weak NSString *Id = @"";
        if (_Type == PushType_Main) {
            _model = (QuestionModel *)_model;
            Id = [_model questionID];
        }else if (_Type == PushType_MyAnswer){
            _model = (AskDataModel *)_model;
            Id = [_model askId];
        }
        
        [head UpdateContent:_model WithFollowClick:^(UIButton *btn) {
            
            UserDataModel *userMod = [UserDataManager shareInstance].userModel;
            NSDictionary *infoDic = @{@"cmd":@"addFollow",
                                      @"userID":(userMod ? userMod.userID : @""),
                                      @"qID":Id
                                      };
            [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
                
                GCD_MAIN(^{
                    
                    if (response && ([response[@"status"] intValue] == 1)) {
                        
                        NSDictionary *dic = response[@"data"];
                        
                        //点击事件请求成功
                        [WeakSelf.model changeAttentionStatus:[dic[@"isFollow"] boolValue] count:[dic[@"followCount"] integerValue]];
                        [WeakSelf.contentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }
                    
                });
                
            } requestHead:^(id response) {
                
            } faile:^(NSError *error) {
                
            }];
            
            
        } WithAnswerClick:^(UIButton *btn) {
            
            UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
            if (userMod.isAnswerer > 0) {
                WeakSelf.navigationController.navigationBarHidden = NO;
                
                EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
                VC.questionID = Id;
                [VC UserType:AnswerType_Answer NavTitle:WeakModel.title];
                [WeakSelf.navigationController pushViewController:VC animated:YES];
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
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    AnswerViewController *answerVC = [sb instantiateViewControllerWithIdentifier:@"AnswerView"];
                    [WeakSelf.navigationController pushViewController:answerVC animated:YES];
                    
                    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                        alertView.alpha = 0;
                        [alertView layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        [alertView removeFromSuperview];
                    }];
                    
                }];
                [WeakSelf.view.window addSubview:alertView];
            }
            
        } WithAllClick:^(BOOL click) {
            WeakSelf.all = YES;
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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
