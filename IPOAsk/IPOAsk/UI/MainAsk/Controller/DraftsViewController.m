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



@implementation DraftsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bgImageView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.backgroundColor = HEX_RGB_COLOR(0xF2F2F2);
    
    self.haveRefresh = NO;

    
    [self setUpData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    self.title = @"草稿箱";
    
    [self setUpNav];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)setUpNav{
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"back" bgimage:nil  Title:@"" SelectedTitle:@" " titleFont:12 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(back)];
    [lbtn setTitleColor:HEX_RGB_COLOR(0x969ca1) forState:UIControlStateNormal];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -14;
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftBtn];
    
    
    //占位 防止左边按钮偏移
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *rightBtn = [UIBarButtonItem returnTabBarItemWithBtn:rbtn image:@"" bgimage:nil  Title:@"占" SelectedTitle:@""  titleFont:1 itemtype:Itemtype_rigth SystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn];
    [rbtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[fixedButton, rightBtn];
    
    [self.navigationController.navigationBar setShadowImage:[UtilsCommon createImageWithColor:HEX_RGB_COLOR(0xE9E9E9)]];
    self.navigationController.navigationBar.shadowImage = [UtilsCommon createImageWithColor:HEX_RGB_COLOR(0xE9E9E9)];
}

- (void)setUpData{
    [self.sourceData removeAllObjects];
    
    self.sourceData = [NSMutableArray arrayWithArray:[[FMDBManager sharedInstance]ArrWithSqlDB:[DraftsModel class]Where:@"" orderBy:@"order by id desc" offset:0]]; 
    self.BgTitle = @"暂无草稿哦";
    self.BgImage = @"没有提问";
    
    self.haveData = self.sourceData.count > 0 ? YES : NO; 
}

#pragma mark -  UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DraftsTableViewCell *cell  = [[NSBundle mainBundle] loadNibNamed:@"DraftsTableViewCell" owner:self options:nil][0];
    
    if (indexPath.row < self.sourceData.count) {
        
        DraftsModel *model = self.sourceData[indexPath.row];
        [cell UpLoadCell:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.row < self.sourceData.count) {
        DraftsModel *model = self.sourceData[indexPath.row];
        
        __weak DraftsViewController *WeakSelf = self;
        EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
       if ([self.navigationController isKindOfClass:[MainNavigationController class]]) {
        [(MainNavigationController *)self.navigationController hideSearchNavBar:YES];
    }
        [VC EditModel:model WithHaveChangeClick:^(BOOL Change) {
            
            [WeakSelf setUpData];//有更改 刷新数据
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }else [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"异常" viewtag:100 AfterDelay:5];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.sourceData.count) {
        DraftsModel *model = self.sourceData[indexPath.row];
        
        if ( [[FMDBManager sharedInstance]DeleteWithSqlDB:[DraftsModel class] Where:[NSString stringWithFormat:@" where id = %@",model.Id]]) {
            
            [self.sourceData removeObjectAtIndex:indexPath.row];
            [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            self.haveData = self.sourceData.count > 0 ? YES : NO;
            
        }else [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"删除失败" viewtag:100 AfterDelay:5];
        
    }else [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"删除失败" viewtag:100 AfterDelay:5];
   
    
   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
