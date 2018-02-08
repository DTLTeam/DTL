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

#import "AnswerModel.h"
#import "AnswerTableViewCell.h"
#import "MainAskDetailHeadViewCellTableViewCell.h"

@interface MainAskDetailViewController ()<UITableViewDelegate, UITableViewDataSource,AnswerTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSMutableArray *CommArr;
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
    
    self.tabBarController.tabBar.hidden = YES;
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
   
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *infoDic = @{@"cmd":@"getQuestionByQID",
                              @"userID":@"90b333b92b630b472467b9b4ccbe42a4",
                              @"qID":_model.questionID
                              };
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            
            if (page == 0) {
                weakSelf.currentPage = 0;
                [weakSelf.CommArr removeAllObjects];
            }
            weakSelf.currentPage++;
            
            /* test */
            for (int i = 0; i < 15; i++) {
                
                AnswerModel *model = [[AnswerModel alloc] init];
                
                int j = arc4random() % 4;
                switch (j) {
                    case 0:
                    {
                        [model refreshModel:@{@"title":@"《黑暗之魂3》进阶解读：魔法、教义与血脉的起源",
                                              @"content":@"在这里首先要感谢一下姆罗和葉舞灵两位大大，姆罗在B站的黑魂系列视频使我入门黑魂3的剧情解读，并且在群内、YY各种讨论中也在脑洞方面给予很多启发。而葉舞灵大大的考据帖子我表示五体投地，其考证手段，严谨之程度，理论推理方面无一不是上佳的考据文，让我可以从另外一个视角进行魂3的剧情解读。此文在很大程度上也是对以上两位大大，以及诸多魂3剧情解读者的一个小结，文中也会用到很多剧情解读者的素材和推理。夸张一点说，站在两位巨人的肩膀上，我才能看得更远~ (以下描述中，如有魂1魂2与魂3发生冲突，均以魂3为最终解释。)",
                                              @"nickName":@"机核",
                                              @"headIcon":@"https://pic3.zhimg.com/50/f82d2dc42_s.jpg",
                                              @"addTime":@"1517664976",
                                              @"view":@(arc4random() % 50000),
                                              @"like":@(arc4random() % 3500),
                                              @"isLike":@(arc4random() & 2),
                                              @"isAnonymous":@(arc4random() & 2)
                                              }];
                    }
                        break;
                    case 1:
                    {
                        [model refreshModel:@{@"title":@"假期回家如何向长辈解释你玩的游戏内容？",
                                              @"content":@"“你这玩的什么啊”“战地1，就是第一次世界大战那个打枪的游戏”“哦”“儿子我问你一个问题啊，这游戏里面为啥人都拿机枪冲锋枪啊，一战的枪不是打一下拉一下的那种吗？”“.......”“怎么跟你解释呢，就是说，这个游戏比较魔幻吧......”“哦我懂了，就跟电视上拿着机枪突突鬼子一样”“...差不多吧”",
                                              @"nickName":@"王兆洋",
                                              @"headIcon":@"https://pic3.zhimg.com/50/b82923ad93d08d56f4b6c570c7d25c8e_s.jpg",
                                              @"addTime":@"1517564864",
                                              @"view":@(arc4random() % 50000),
                                              @"like":@(arc4random() % 3500),
                                              @"isLike":@(arc4random() & 2),
                                              @"isAnonymous":@(arc4random() & 2)
                                              }];
                    }
                        break;
                    case 2:
                    {
                        [model refreshModel:@{@"title":@"正义必胜",
                                              @"content":@"简单来说，这件事情就是我用我自己的实力，战胜了外挂，同时痛击了污蔑我是外挂的人，取得了一场来之不易的胜利。对抗外挂，我们人人有责，刻不容缓，同时，比外挂要更可恨的，是那些别有用心的玩家和坑爹的游戏机制。",
                                              @"nickName":@"郝艺益",
                                              @"headIcon":@"https://pic3.zhimg.com/50/f82d2dc42_s.jpg",
                                              @"addTime":@"1517533541",
                                              @"view":@(arc4random() % 50000),
                                              @"like":@(arc4random() % 3500),
                                              @"isLike":@(arc4random() & 2),
                                              @"isAnonymous":@(arc4random() & 2)
                                              }];
                    }
                        break;
                    case 3:
                    {
                        [model refreshModel:@{@"title":@"如何看待育碧商城 2 月 2 日游戏一折出售 bug？",
                                              @"content":@"这种事情怎么感觉这么眼熟呢？ <图>",
                                              @"nickName":@"干拌面",
                                              @"headIcon":@"https://pic2.zhimg.com/50/v2-bc4b14216b5c903942b42d3f1a74920d_s.jpg",
                                              @"addTime":@"1517461658",
                                              @"view":@(arc4random() % 50000),
                                              @"like":@(arc4random() % 3500),
                                              @"isLike":@(arc4random() & 2),
                                              @"isAnonymous":@(arc4random() & 2)
                                              }];
                    }
                        break;
                    default:
                        break;
                }
                
                [weakSelf.CommArr addObject:model];
            }
            
//            if (response) {
//
//                if (response[@"data"][@"question"]) {
//                    QuestionModel *model = [[QuestionModel alloc] init];
//                    [model refreshModel:response[@"data"][@"question"]];
//                    weakSelf.model = model;
//                }
//
//                for (NSDictionary *dic in response[@"data"][@"answer"]) {
//                    AnswerModel *model = [[AnswerModel alloc] init];
//                    [model refreshModel:dic];
//                    [weakSelf.CommArr addObject:model];
//                }
//
//            }
            
            [_contentTableView reloadData];
            
            if (weakSelf.contentTableView.mj_header.isRefreshing) {
                [weakSelf.contentTableView.mj_header endRefreshing];
            }
            if (weakSelf.contentTableView.mj_footer.isRefreshing) {
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
        self.navigationController.navigationBarHidden = NO;
        if (indexPath.section < _CommArr.count) {
            
            AnswerModel *model = _CommArr[indexPath.section + 1];
            
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
        __weak QuestionModel *WeakModel = _model;
        
        [head UpdateContent:_model WithFollowClick:^(UIButton *btn) {
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
    
    static NSString *identifier = @"AnswerTableViewCell";
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    if (indexPath.section < _CommArr.count) {
        [cell refreshWithModel:_CommArr[indexPath.section]];
    }

    return cell;
    
}

#pragma mark - 喜欢 点击事件
-(void)likeWithCell:(AnswerTableViewCell *)cell{
    NSIndexPath *indexpath = [_contentTableView indexPathForCell:cell];
    
    AnswerModel *model = [_CommArr objectAtIndex:indexpath.section];
    
    //点击事件请求成功
    [model changeLikeStatus:!model.isLike];
    [_contentTableView reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationNone];
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
