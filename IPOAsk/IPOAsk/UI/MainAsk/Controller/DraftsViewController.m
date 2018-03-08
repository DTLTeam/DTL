//
//  DraftsViewController.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import "DraftsViewController.h"
#import "EditQuestionViewController.h"

#import "DraftsTableViewCell.h"

@interface DraftsViewController ()  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *contentTableView;

@property (strong, nonatomic) NSMutableArray *contentArr;

@end

@implementation DraftsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"草稿箱";
    
    [self setUpNavBgColor:nil RightBtn:nil];
    [self setupInterface];
    [self setupData];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]]) {
        [(BaseNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
}


#pragma mark - 界面

- (void)setupInterface {
    
    _contentArr = [NSMutableArray array];
    
    _contentTableView = [[UITableView alloc] init];
    if (@available(iOS 11.0, *)) {
        _contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _contentTableView.backgroundColor = [UIColor whiteColor];
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedRowHeight = 9999;
    _contentTableView.tableHeaderView = [[UIView alloc] init];
    _contentTableView.tableFooterView = [[UIView alloc] init];
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:_contentTableView];
    
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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


#pragma mark - 功能

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData {
    
    [_contentArr removeAllObjects];
    
    _contentArr = [NSMutableArray arrayWithArray:[[FMDBManager sharedInstance]ArrWithSqlDB:[DraftsModel class]Where:[NSString stringWithFormat:@"UserId = '%@'",[UserDataManager shareInstance].userModel.userID] orderBy:@"order by id desc" offset:0]];
    [_contentTableView reloadData];
//    self.BgTitle = @"暂无草稿哦";
//    self.BgImage = @"没有提问";
    
}


#pragma mark -  UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DraftsTableViewCell *cell  = [[NSBundle mainBundle] loadNibNamed:@"DraftsTableViewCell" owner:self options:nil][0];
    
    if (indexPath.row < _contentArr.count) {
        
        DraftsModel *model = _contentArr[indexPath.row];
        [cell UpLoadCell:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.row < _contentArr.count) {
        
        __weak typeof(self) weakSelf = self;
        DraftsModel *model = _contentArr[indexPath.row];
        
        EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
        [VC EditModel:model WithHaveChangeClick:^(BOOL Change) {
            [weakSelf setupData];
        }];
        [self.navigationController pushViewController:VC animated:YES];
        
    } else
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"异常" viewtag:100 AfterDelay:5];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _contentArr.count) {
        DraftsModel *model = _contentArr[indexPath.row];
        
        if ( [[FMDBManager sharedInstance]DeleteWithSqlDB:[DraftsModel class] Where:[NSString stringWithFormat:@" where id = %@",model.Id]]) {
            
            [_contentArr removeObjectAtIndex:indexPath.row];
            [_contentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else
            [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"删除失败" viewtag:100 AfterDelay:5];
        
    }else
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"删除失败" viewtag:100 AfterDelay:5];
   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
