//
//  MainAskViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainAskViewController.h" 

#import "UserDataManager.h"

//View
#import "QuestionTableViewCell.h"

//Controller
#import "SignInViewController.h"

@interface MainAskViewController () <UITableViewDelegate, UITableViewDataSource, QuestionTableViewCellDelegate>

@property (strong, nonatomic) NSArray *advertisementArr;

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSMutableArray *contentArr;
@property (assign, nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger startQuestionID;

@end

@implementation MainAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [[UIImage imageNamed:@"home_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [self login];
    [self setupInterface];
    
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
    
    _startQuestionID = 0;
    _currentPage = -1;
    _contentArr = [NSMutableArray array];
    
    if (@available(iOS 11.0, *)) {
        _contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _contentTableView.backgroundColor = HEX_RGBA_COLOR(0xF1F1F1, 1);
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedRowHeight = 9999;
    _contentTableView.tableHeaderView = [[UIView alloc] init];
    _contentTableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    // 上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < 0) {
            weakSelf.currentPage = 0;
        }
        [weakSelf requestContent:weakSelf.currentPage];
        
    }];
    [footer setUpGifImage:@"上拉刷新"];
    self.contentTableView.mj_footer = footer;
    
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.startQuestionID = 0;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    [header setUpGifImage:@"下拉加载"];
    self.contentTableView.mj_header = header;
    
    
}


#pragma mark - 功能

#pragma mark 请求广告
- (void)requestAdvertisement {
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *infoDic = @{@"cmd":@"getBannderAD"};
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
       
        GCD_MAIN(^{
           
            if (response && ([response[@"status"] intValue] == 1)) {
                weakSelf.advertisementArr = response[@"data"];
                
                if (weakSelf.advertisementArr.count > 0) {
                    
                    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
                    weakSelf.contentTableView.tableHeaderView = headerView;
                    
                } else {
                    weakSelf.contentTableView.tableHeaderView = nil;
                }
                
            }
            
        });
        
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
    }];
    
}

#pragma mark 请求列表内容
- (void)requestContent:(NSInteger)page {
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *infoDic = @{@"cmd":@"getQuestionIndex",
                              @"userID":@"90b333b92b630b472467b9b4ccbe42a4",
                              @"pageSize":@20,
                              @"page":@(page),
                              @"maxQID":@(_startQuestionID)
                              };
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
        
//            /* test */
//            for (int i = 0; i < 15; i++) {
//
//                QuestionModel *model = [[QuestionModel alloc] init];
//
//                int j = arc4random() % 4;
//                switch (j) {
//                    case 0:
//                    {
//                        [model refreshModel:@{@"title":@"《黑暗之魂3》进阶解读：魔法、教义与血脉的起源",
//                                              @"content":@"在这里首先要感谢一下姆罗和葉舞灵两位大大，姆罗在B站的黑魂系列视频使我入门黑魂3的剧情解读，并且在群内、YY各种讨论中也在脑洞方面给予很多启发。而葉舞灵大大的考据帖子我表示五体投地，其考证手段，严谨之程度，理论推理方面无一不是上佳的考据文，让我可以从另外一个视角进行魂3的剧情解读。此文在很大程度上也是对以上两位大大，以及诸多魂3剧情解读者的一个小结，文中也会用到很多剧情解读者的素材和推理。夸张一点说，站在两位巨人的肩膀上，我才能看得更远~ (以下描述中，如有魂1魂2与魂3发生冲突，均以魂3为最终解释。)",
//                                              @"nickName":@"机核",
//                                              @"headIcon":@"https://pic3.zhimg.com/50/f82d2dc42_s.jpg",
//                                              @"addTime":@"1517664976",
//                                              @"view":@(arc4random() % 50000),
//                                              @"answer":@(arc4random() % 2000),
//                                              @"follow":@(arc4random() % 3500),
//                                              @"isFollow":@(arc4random() & 2),
//                                              @"isAnonymous":@(arc4random() & 2)
//                                              }];
//                    }
//                        break;
//                    case 1:
//                    {
//                        [model refreshModel:@{@"title":@"假期回家如何向长辈解释你玩的游戏内容？",
//                                              @"content":@"“你这玩的什么啊”“战地1，就是第一次世界大战那个打枪的游戏”“哦”“儿子我问你一个问题啊，这游戏里面为啥人都拿机枪冲锋枪啊，一战的枪不是打一下拉一下的那种吗？”“.......”“怎么跟你解释呢，就是说，这个游戏比较魔幻吧......”“哦我懂了，就跟电视上拿着机枪突突鬼子一样”“...差不多吧”",
//                                              @"nickName":@"王兆洋",
//                                              @"headIcon":@"https://pic3.zhimg.com/50/b82923ad93d08d56f4b6c570c7d25c8e_s.jpg",
//                                              @"addTime":@"1517564864",
//                                              @"view":@(arc4random() % 50000),
//                                              @"answer":@(arc4random() % 2000),
//                                              @"follow":@(arc4random() % 3500),
//                                              @"isFollow":@(arc4random() & 2),
//                                              @"isAnonymous":@(arc4random() & 2)
//                                              }];
//                    }
//                        break;
//                    case 2:
//                    {
//                        [model refreshModel:@{@"title":@"正义必胜",
//                                              @"content":@"简单来说，这件事情就是我用我自己的实力，战胜了外挂，同时痛击了污蔑我是外挂的人，取得了一场来之不易的胜利。对抗外挂，我们人人有责，刻不容缓，同时，比外挂要更可恨的，是那些别有用心的玩家和坑爹的游戏机制。",
//                                              @"nickName":@"郝艺益",
//                                              @"headIcon":@"https://pic3.zhimg.com/50/f82d2dc42_s.jpg",
//                                              @"addTime":@"1517533541",
//                                              @"view":@(arc4random() % 50000),
//                                              @"answer":@(arc4random() % 2000),
//                                              @"follow":@(arc4random() % 3500),
//                                              @"isFollow":@(arc4random() & 2),
//                                              @"isAnonymous":@(arc4random() & 2)
//                                              }];
//                    }
//                        break;
//                    case 3:
//                    {
//                        [model refreshModel:@{@"title":@"如何看待育碧商城 2 月 2 日游戏一折出售 bug？",
//                                              @"content":@"这种事情怎么感觉这么眼熟呢？ <图>",
//                                              @"nickName":@"干拌面",
//                                              @"headIcon":@"https://pic2.zhimg.com/50/v2-bc4b14216b5c903942b42d3f1a74920d_s.jpg",
//                                              @"addTime":@"1517461658",
//                                              @"view":@(arc4random() % 50000),
//                                              @"answer":@(arc4random() % 2000),
//                                              @"follow":@(arc4random() % 3500),
//                                              @"isFollow":@(arc4random() & 2),
//                                              @"isAnonymous":@(arc4random() & 2)
//                                              }];
//                    }
//                        break;
//                    default:
//                        break;
//                }
//
//                [weakSelf.contentArr addObject:model];
//            }
            
            if (response && ([response[@"status"] intValue] == 1)) {

                if (page == 0) {
                    [weakSelf.contentArr removeAllObjects];
                    QuestionModel *mod = [[QuestionModel alloc] init];
                    [mod refreshModel:[response[@"data"][@"data"] firstObject]];
                    weakSelf.startQuestionID = [mod.questionID integerValue];
                }
                weakSelf.currentPage = page;
                weakSelf.currentPage++;
                
                for (NSDictionary *dic in response[@"data"][@"data"]) {

                    QuestionModel *model = [[QuestionModel alloc] init];
                    [model refreshModel:dic];
                    [weakSelf.contentArr addObject:model];

                }

            }
            
            [weakSelf.contentTableView reloadData];
            
            if (weakSelf.contentTableView.mj_header.isRefreshing) {
                [weakSelf.contentTableView.mj_header endRefreshing];
            }
            if (response && ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue])) {
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

-(void)login{
    
   
    __weak MainAskViewController *WeakSelf = self;
    
    //自动登录
    [self AutomaticLoginSuccess:^(BOOL success) {
        if (!success) {
            UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SignInViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"SignInView"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
            [WeakSelf.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }];
}


#pragma mark - QuestionTableViewCellDelegate

- (void)attentionWithCell:(QuestionTableViewCell *)cell {
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        return;
    }
    
    NSIndexPath *indexPath = [_contentTableView indexPathForCell:cell];
    QuestionModel *mod = _contentArr[indexPath.section];
    
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
                [weakSelf.contentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        });
        
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
        
        
    }];
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        return;
    }
    
    QuestionModel *model = _contentArr[indexPath.section];
    
    //传问题模型
    MainAskDetailViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailViewController" owner:self options:nil].firstObject;
    VC.model = model;
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"questionCell";
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Main:YES];
        cell.delegate = self;
    }
    
    [cell refreshWithModel:_contentArr[indexPath.section]];
    
    return cell;
    
}

#pragma mark - 自动登录
- (void)AutomaticLoginSuccess:(void(^)(BOOL success))Success{
    
    NSDictionary *User = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo_only"];
    NSDictionary *dataDic = [User valueForKey:@"User"];
    
    
    if (dataDic) {
        
        //判断类型是否变化
        __weak MainAskViewController *WeakSelf = self;
        [AskProgressHUD AskShowInView:self.view viewtag:1];
        
        [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"login",@"phone":dataDic[@"phone"],@"password":[User valueForKey:@"Pwd"]} backData:NetSessionResponseTypeJSON success:^(id response) {
            NSDictionary *dic = (NSDictionary *)response;
            int result = [dic[@"status"] intValue];
            NSDictionary *dataDic = dic[@"data"];
            if (result == 1 && dataDic) {
                GCD_MAIN((^{
                    //缓存登录数据
                    UserDataManager *manager = [UserDataManager shareInstance];
                    UserDataModel *model = [[UserDataModel alloc] init];
                    model.userID = dataDic[@"userID"];
                    model.headIcon = dataDic[@"headIcon"];
                    model.phone = dataDic[@"phone"];
                    model.realName = dataDic[@"realName"];
                    model.nickName = dataDic[@"nickName"];
                    model.company = dataDic[@"company"];
                    model.details = dataDic[@"details"];
                    model.email = dataDic[@"email"];
                    model.forbidden = [dataDic[@"forbidden"] intValue];
                    model.isAnswerer = [dataDic[@"isAnswerer"] intValue];
                    model.userType = [dataDic[@"userType"] intValue];
                    [manager loginSetUpModel:model];
                    
                    
                    if (1) {
                        [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"自动登录成功！" viewtag:1 AfterDelay:3];
                        
                        NSDictionary *UserDefaults = @{@"User":dataDic,@"Pwd":[User valueForKey:@"Pwd"]};
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:UserDefaults forKey:@"UserInfo_only"];
                        [defaults synchronize];
                        Success(YES);
                        
                    }else{
                        //类型发生变化
                        
                        
                        
                        
                        Success(NO);
                    }
                }));
            }else{
                
                GCD_MAIN(^{
                    //登录失败
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:nil forKey:@"UserInfo_only"];
                    [defaults synchronize];
                    
                    [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                    [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:[dic valueForKey:@"msg"] viewtag:1 AfterDelay:3];
                    Success(NO);
                });
            }
        } requestHead:nil faile:^(NSError *error) {
            
            GCD_MAIN(^{
                //登录失败
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"UserInfo_only"];
                [defaults synchronize];
                
                [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"登录失败" viewtag:1 AfterDelay:3];
                Success(NO);
            });
        }];
        
    }else Success(NO);
    
  
}

@end
