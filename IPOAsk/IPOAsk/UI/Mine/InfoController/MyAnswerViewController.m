//
//  MyAnswerViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/2/1.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyAnswerViewController.h"
#import "FollowTableViewCell.h"

@interface MyAnswerViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *answerArr;
@property (nonatomic,assign) NSInteger  currentPage;
@end
 

@implementation MyAnswerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //无数据背景
    [self setUpBgViewWithTitle:@"暂无回答哦!" Image:@"没有提问" Action:@selector(getAnswerList)];
    

    _currentPage = 1;
    _answerArr = [NSMutableArray array];
    
    __weak MyAnswerViewController *weakSelf = self;
    // 上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage ++;
        
      
        [weakSelf performSelector:@selector(end) withObject:nil afterDelay:5];
        
    }];
    [footer setUpGifImage:@"上拉刷新"];
    self.tableView.mj_footer = footer;
    
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf.answerArr removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [header setUpGifImage:@"下拉加载"];
    self.tableView.mj_header = header;
    
    [self getAnswerList];
}

- (void)getAnswerList
{
    __weak MyAnswerViewController *weakSelf = self;
    [[UserDataManager shareInstance] getAnswerWithpage:[NSString stringWithFormat:@"%d",(int)_currentPage] finish:^(NSArray *dataArr) {
        GCD_MAIN(^{
            if (dataArr.count > 0) {
                [weakSelf.answerArr addObjectsFromArray:dataArr];
                [weakSelf.tableView reloadData];
            }
            if (dataArr.count == 0 && weakSelf.answerArr.count > 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [weakSelf end];
            }
            
        });
    }];
}

- (void)end{
    if (_answerArr.count == 0) {
        _tableView.hidden = YES;
        self.bgImageView.hidden = NO;
    }
    //没有更多了了
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.title = @"我的回答";
    [self setUpNavBgColor:MineTopColor RightBtn:^(UIButton *btn) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hiddenNav];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _answerArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [view addSubview:line];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FollowTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    AnswerDataModel *model = _answerArr[indexPath.section];
    [cell updateAnswerCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
