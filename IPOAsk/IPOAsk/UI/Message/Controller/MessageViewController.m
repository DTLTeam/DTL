//
//  MessageViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MessageViewController.h"

#import "AnswerOrLikeTableViewCell.h" 

@interface MessageViewController ()

@property (assign, nonatomic) NSInteger startQuestionID;

@end

static NSString * CellIdentifier = @"AOrLikeCell";

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息";
    
    [self setupNavBar];
    [self setupViews];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
    
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark - 界面

- (void)setupNavBar {
    
    UIImage *img = [[UIImage imageNamed:@"消息-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
}

- (void)setupViews {
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    self.bgImageView.backgroundColor = HEX_RGB_COLOR(0xF2F2F2);
    
    self.haveRefresh = YES;
    
    self.currentPage = 0;
    self.startQuestionID = 0;
    
    __weak typeof(self) weakSelf = self;
    
    //上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf requestContent:weakSelf.currentPage];
        
    }];
    self.myTableView.mj_footer = footer;
    
    //下拉刷新
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        weakSelf.startQuestionID = 0;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    self.myTableView.mj_header = header;
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 9999;
    [self.myTableView registerNib:[UINib nibWithNibName:@"AnswerOrLikeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
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
                    [weakSelf.sourceData removeAllObjects];
                    AnswerOrLikeModel *mod = [[AnswerOrLikeModel alloc] init];
                    [mod refreshModel:[resultDic[@"data"][@"data"] firstObject]];
                    weakSelf.startQuestionID = [mod.messageID integerValue];
                }
                
                for (NSDictionary *tempDic in resultDic[@"data"][@"data"]) {
                    
                    AnswerOrLikeModel *model = [[AnswerOrLikeModel alloc] init];
                    [model refreshModel:tempDic];
                    
                    [weakSelf.sourceData addObject:model];
                    
                }
                
                [weakSelf.myTableView reloadData];
                
            } else {
                
                weakSelf.currentPage--;
                
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"加载失败" viewtag:1 AfterDelay:1.5];
                
            }
            
            if (self.myTableView.mj_header.isRefreshing) {
                [self.myTableView.mj_header endRefreshing];
            }
            if (response && ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue])) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            } else if (weakSelf.myTableView.mj_footer.isRefreshing) {
                [weakSelf.myTableView.mj_footer endRefreshing];
            }
            
        });
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            weakSelf.currentPage--;
            
            [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerOrLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row < self.sourceData.count) {
        AnswerOrLikeModel *model = self.sourceData[indexPath.row];
        if (model) {
            [cell updateWithModel:model];
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row < self.sourceData.count) {
        AnswerOrLikeModel *model = self.sourceData[indexPath.row];
        
        AskDataModel *Askmodel = [[AskDataModel alloc]init];
        Askmodel.askId = model.questionID;
        Askmodel.title = model.questionTitle;
        Askmodel.content = model.questionTitle;
        Askmodel.addTime = [NSString stringWithFormat:@"%d",model.messageTime];
         
        
        //传问题模型
        MainAskDetailViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailViewController" owner:self options:nil].firstObject;
        VC.model = Askmodel;
        VC.Type = PushType_MyAsk;
        [self.navigationController pushViewController:VC animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}



/*
 
 @property (strong, nonatomic) NSString *askId;
 @property (nonatomic, strong) NSString *title;
 @property (strong, nonatomic) NSString *content;
 @property (strong, nonatomic) NSString *addTime;
 @property (assign, nonatomic) int View;
 @property (assign, nonatomic) int createUID;
 @property (assign, nonatomic) int Answer;
 @property (assign, nonatomic) int isAnonymous;
 @property (assign, nonatomic) int IsAttention;
 @property (assign, nonatomic) int isCompany;
 @property (assign, nonatomic) int Follow;
 
 */
@end
