//
//  MainAskViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainAskViewController.h"

//View
#import "QuestionTableViewCell.h"
#import "SignInViewController.h"

@interface MainAskViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSMutableArray *contentArr;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation MainAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self login];//
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

- (void)viewDidAppear:(BOOL)animated{
    
    
    if (_currentPage < 0) { //未刷新过
        [_contentTableView.mj_header beginRefreshing];
    }
}


#pragma mark - 界面

- (void)setupInterface {
    
    _currentPage = -1;
    
    __weak typeof(self) weakSelf = self;
    //刷新
    _contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 0;
        [weakSelf requestContent:weakSelf.currentPage];
        
    }];
    //加载
    _contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _currentPage++;
        [weakSelf requestContent:weakSelf.currentPage];
        
    }];
    
}


#pragma mark - 功能

#pragma mark 请求列表内容
- (void)requestContent:(NSInteger)page {
    
    
    /* test */
    sleep(3);
    
    if (_currentPage == 0) {
        [_contentArr removeAllObjects];
    }
    [_contentArr addObjectsFromArray:@[@"", @"", @"", @"", @"", @""]];
    [_contentTableView reloadData];
    
    if (_contentTableView.mj_header.isRefreshing) {
        [_contentTableView.mj_header endRefreshing];
    }
    if (_contentTableView.mj_footer.isRefreshing) {
        [_contentTableView.mj_footer endRefreshing];
    }
    return;
    /* test */
    
    
    __weak typeof(self) weakSelf = self;
    [[AskHttpLink shareInstance] post:@"" bodyparam:nil backData:NetSessionResponseTypeJSON success:^(id response) {

        sleep(3);
        
        if (weakSelf.currentPage == 0) {
            [weakSelf.contentArr removeAllObjects];
        }
        [weakSelf.contentArr addObjectsFromArray:@[@"", @"", @"", @"", @"", @""]];
        [_contentTableView reloadData];
        
        if (weakSelf.contentTableView.mj_header.isRefreshing) {
            [weakSelf.contentTableView.mj_header endRefreshing];
        }
        if (weakSelf.contentTableView.mj_footer.isRefreshing) {
            [weakSelf.contentTableView.mj_footer endRefreshing];
        }
        
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
        if (weakSelf.contentTableView.mj_header.isRefreshing) {
            [weakSelf.contentTableView.mj_header endRefreshing];
        }
        if (weakSelf.contentTableView.mj_footer.isRefreshing) {
            [weakSelf.contentTableView.mj_footer endRefreshing];
        }
        
    }];
    
}

-(void)login{
    
    UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *VC = [storyboayd instantiateViewControllerWithIdentifier:@"SignInView"];
    [self presentViewController:VC animated:YES completion:nil];
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _contentArr[indexPath.row];
    
    return cell;
    
}

@end
