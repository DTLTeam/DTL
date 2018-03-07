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
@property (assign, nonatomic) NSInteger startQuestionID;

@end

@implementation MainAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [[UIImage imageNamed:@"home_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:@"LoginOut" object:nil];
    
    [self automaticLogin];
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
    
    if (_currentPage < 1) { //未刷新过
        [_contentTableView.mj_header beginRefreshing];
    }
    
}


#pragma mark - 界面

- (void)setupInterface {
    
    _startQuestionID = 0;
    _currentPage = 0;
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

#pragma mark 请求广告
- (void)requestAdvertisement {
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *infoDic = @{@"cmd":@"getBannderAD"};
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
       
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
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    
    NSDictionary *infoDic = @{@"cmd":@"getQuestionIndex",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"pageSize":@20,
                              @"page":@(page),
                              @"maxQID":@(_startQuestionID)
                              };
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            
            if (response && ([response[@"status"] intValue] == 1)) {

                if (page == 1) {
                    [weakSelf.contentArr removeAllObjects];
                    QuestionModel *mod = [[QuestionModel alloc] init];
                    [mod refreshModel:[response[@"data"][@"data"] firstObject]];
                    weakSelf.startQuestionID = [mod.questionID integerValue];
                }
                
                for (NSDictionary *dic in response[@"data"][@"data"]) {

                    QuestionModel *model = [[QuestionModel alloc] init];
                    [model refreshModel:dic];
                    [weakSelf.contentArr addObject:model];

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

#pragma mark 自动登录
- (void)automaticLogin {
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo_only"];
    NSDictionary *dataDic = [userDic valueForKey:@"User"];
    
    if (dataDic) { //存在可登录用户
        
        __weak typeof(self) weakSelf = self;
        [AskProgressHUD AskShowGifImageReloadInView:self.view Title:@"自动登录中" viewtag:2];
        
        [[UserDataManager shareInstance] signInWithAccount:dataDic[@"phone"] password:userDic[@"Pwd"] complated:^(BOOL isSignInSuccess, NSString *message) {
            
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:2 AfterDelay:0];
            
            if (isSignInSuccess) {
                
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"自动登录成功!" viewtag:1 AfterDelay:1.5];
                
            } else {
                
                //登录失败
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:message viewtag:1 AfterDelay:1.5];
                
                UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SignInViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"SignInView"];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
                
            }
            
        } networkError:^(NSError *error) {
            
            //网络错误
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:2 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
            
        }];
        
    }else{
        //没有用户登录
        UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SignInViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"SignInView"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }
    
}

#pragma mark - 退出登录
- (void)loginOut {
    
    //刷新页面
    NSLog(@"退出");
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
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
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

@end
