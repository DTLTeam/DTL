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
#import "QJCheckVersionUpdate.h"

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut) name:@"LoginOut" object:nil];
    
    [self login];
    [self setupInterface];
    
    [self checkVerionUpdate];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController showSearchNavBar:YES];
    }
    
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
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < 0) {
            weakSelf.currentPage = 0;
        }
        [weakSelf requestContent:weakSelf.currentPage];
        
    }];
    self.contentTableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        weakSelf.startQuestionID = 0;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
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
    
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *infoDic = @{@"cmd":@"getQuestionIndex",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"pageSize":@20,
                              @"page":@(page),
                              @"maxQID":@(_startQuestionID)
                              };
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            
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
            if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                if (response && ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue])) {
                    [weakSelf.contentTableView.mj_footer endRefreshingWithNoMoreData];
                } else if (weakSelf.contentTableView.mj_footer.isRefreshing) {
                    [weakSelf.contentTableView.mj_footer endRefreshing];
                }
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
    
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    NSDictionary *infoDic = @{@"cmd":@"addFollow",
                              @"userID":(userMod ? userMod.userID : @""),
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
    VC.Type = PushType_Main;
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

/**
 *  检查版本更新
 */
- (void)checkVerionUpdate
{
    QJCheckVersionUpdate *update = [[QJCheckVersionUpdate alloc] init];
    [update showAlertView];
}


#pragma mark - 自动登录
- (void)AutomaticLoginSuccess:(void(^)(BOOL success))Success{
    
    NSDictionary *User = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo_only"];
    NSDictionary *dataDic = [User valueForKey:@"User"];
    
    
    if (dataDic) {
        
        //判断类型是否变化
        __weak MainAskViewController *WeakSelf = self;
        [AskProgressHUD AskShowInView:self.view viewtag:1];
        
        [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"login",@"phone":dataDic[@"phone"],@"password":[UtilsCommon md5WithString:[User valueForKey:@"Pwd"]]} backData:NetSessionResponseTypeJSON success:^(id response) {
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
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginSuccess" object:nil];
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
        
    } else
        Success(NO);
    
}

#pragma mark - 退出登录
- (void)loginOut{
    
    //刷新页面
    NSLog(@"退出");
}

@end
