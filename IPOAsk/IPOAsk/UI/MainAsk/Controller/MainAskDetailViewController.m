//
//  MainAskDetailViewController.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/2.
//  Copyright © 2018年 law. All rights reserved.
//

#define haveComm 1  //test****************有无评论

#import "MainAskDetailViewController.h"
#import "MainAskCommViewController.h"
#import "EditQuestionViewController.h"

//View
#import "SearchView.h"
#import "QuestionTableViewCell.h"
#import "MainAskDetailHeadViewCellTableViewCell.h"

@interface MainAskDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (strong, nonatomic) NSMutableArray *CommArr;
@property (strong, nonatomic) QuestionModel *QuestionModal;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) BOOL all;

@end

@implementation MainAskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupInterface];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    self.navigationController.navigationBarHidden = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"back" bgimage:nil  Title:@"" SelectedTitle:@" " titleFont:12 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [lbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftBtn = nil;
    
    [self.view addSubview:lbtn];
    
    SearchView *view = [[SearchView alloc]initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH - 44, 44) SearchClick:^(NSString * searchtext) {
        
        NSLog(@"%@",searchtext);
    } WithAnswerClick:^(BOOL answer) {
        NSLog(@"点击发表");
    }];
    
    lbtn.center = CGPointMake(lbtn.center.x, view.center.y);
    
    [self.view addSubview:view];
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
    _contentTableView.estimatedRowHeight = 999;
    __weak typeof(self) weakSelf = self;
    
    // 上拉加载
    MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [weakSelf requestContent:weakSelf.currentPage];
        
    }];
    [footer setUpGifImage:@"下拉加载"];
    self.contentTableView.mj_footer = footer;
    
    MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 0;
        [weakSelf requestContent:weakSelf.currentPage];
    }];
    [header setUpGifImage:@"上拉刷新"];
    self.contentTableView.mj_header = header;
    
}


#pragma mark - 功能

#pragma mark 请求列表内容
- (void)requestContent:(NSInteger)page {
    
    
    /* test */
    
    if (_currentPage == 0) {
        [_CommArr removeAllObjects];
    }
    
    for (int i = 0; i < 15; i++) {
        QuestionModel *model = [[QuestionModel alloc] init];
        [model refreshModel:nil];
        [_CommArr addObject:model];
        
        //test*******************
        if (i == 0) {
            _QuestionModal = model;
        }
        //test*******************
        
    }
    
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
            [weakSelf.CommArr removeAllObjects];
        }
        [weakSelf.CommArr addObjectsFromArray:@[@"", @"", @"", @"", @"", @""]];
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
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}


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
        self.navigationController.navigationBarHidden = NO;
        if (indexPath.section < _CommArr.count + 1) {
            
            QuestionModel *model = _CommArr[indexPath.section + 1];
            
            MainAskCommViewController *VC = [[[NSBundle mainBundle] loadNibNamed:@"MainAskCommViewController" owner:self options:nil] firstObject];
            [VC UpdateContentWithModel:model];
            VC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //并且有数据
        MainAskDetailHeadViewCellTableViewCell *head  = [[NSBundle mainBundle] loadNibNamed:@"MainAskDetailHeadViewCellTableViewCell" owner:self options:nil][0];
        head.ContentLabel.numberOfLines = _all ? 0 : 5;
        
        
        __weak MainAskDetailViewController *WeakSelf = self;
        __weak UITableView *WeakTableView = tableView;
        __weak QuestionModel *WeakModel = _QuestionModal;
        
        [head UpdateContent:_QuestionModal WithFollowClick:^(UIButton *btn) {
            NSLog(@"%@",btn);
            
            //成功
            btn.selected = !btn.selected;
        }WithAnswerClick:^(UIButton *btn) {
            
            WeakSelf.navigationController.navigationBarHidden = NO;
            
            EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
            [VC UserType:AnswerType_Answer NavTitle:WeakModel.title];
            [WeakSelf.navigationController pushViewController:VC animated:YES];
            
        } WithAllClick:^(BOOL click) {
            WeakSelf.all = YES;
            [WeakTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        return head;
    }
    
    static NSString *identifier = @"questiondetailCell";
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Main:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section < _CommArr.count) {
        [cell refreshWithModel:_CommArr[indexPath.section]];
    }

    return cell;
    
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
