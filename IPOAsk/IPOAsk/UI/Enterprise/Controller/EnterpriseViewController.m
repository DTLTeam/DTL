//
//  EnterpriseViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseViewController.h"

#import "UserDataManager.h"

//Controller
#import "BaseTabBarViewController.h"
#import "ApplicationEnterpriseViewController.h"
#import "EditQuestionViewController.h"

//View
#import "NotEnterpriseView.h"
#import "EnterpriseNotQuestionView.h"
#import "EnterpriseTableViewCell.h"

static NSString * CellIdentifier = @"EnterpriseCell";

@interface EnterpriseViewController ()

@property (strong, nonatomic) EnterpriseNotQuestionView *notQusetionView;
@property (strong, nonatomic) NotEnterpriseView *notEnterpriseView;

@end

@implementation EnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [[UIImage imageNamed:@"企业-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.title = @"企业+";
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bgImageView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.backgroundColor = HEX_RGB_COLOR(0xF2F2F2);
    
    self.haveRefresh = YES;
    
    
    [self setUpViews];
    
    __weak EnterpriseViewController *weakSlef = self; 
    self.headerRefresh = ^(BOOL headerR) {
        if (headerR) {
            //下拉刷新
            [weakSlef endHeaderRefresh:RefreshType_header];
        }else{
            //上拉加载
            [weakSlef endHeaderRefresh:RefreshType_foot];
        }
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
    UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
    if (userMod && (userMod.userType == loginType_Enterprise)) { //企业用户
        
        if (self.haveData) { //有提问数据
            _notEnterpriseView.hidden = YES;
            _notQusetionView.hidden = YES;
            self.myTableView.hidden = NO;
        } else { //无提问数据
            _notEnterpriseView.hidden = YES;
            _notQusetionView.hidden = NO;
            self.myTableView.hidden = YES;
        }
        
    } else { //非企业用户
        
        _notEnterpriseView.hidden = NO;
        _notQusetionView.hidden = YES;
        self.myTableView.hidden = YES;
        
    }
    
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        
        GCD_MAIN(^{
            BaseTabBarViewController *base = (BaseTabBarViewController *)self.tabBarController;
            base.selectedIndex = base.lastSelectedIndex;
        });
    }
    
}


#pragma mark - 界面

- (void)setUpViews {
    
    __weak typeof(self) WeakSelf = self;
    
    _notQusetionView  = [[NSBundle mainBundle] loadNibNamed:@"EnterpriseNotQuestionView" owner:self options:nil][0];
    [self.bgImageView addSubview:_notQusetionView];
    
    [_notQusetionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.bgImageView);
    }];
    
    //点击发布问题
    _notQusetionView.addQuestionClickBlock = ^(UIButton *sender) {
        [WeakSelf Consultation];
    };
    
    
    _notEnterpriseView = [[NSBundle mainBundle] loadNibNamed:@"NotEnterpriseView" owner:self options:nil][0];
    [self.bgImageView addSubview:_notEnterpriseView];
    
    [_notEnterpriseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.bgImageView);
    }];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"EnterpriseTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
}


#pragma mark - 事件响应

#pragma mark 马上咨询专家
- (void)Consultation {
    //未登录
    if ([UtilsCommon ShowLoginHud:self.view Tag:200]) {
        return;
    }
    
    self.tabBarController.tabBar.hidden = YES;
    EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
    [VC UserType:AnswerType_AskQuestionEnterprise NavTitle:@"企业+"];
    [self.navigationController pushViewController:VC animated:YES];
    
}


#pragma mark - 功能

- (void)requestInfo {
    
    self.haveData = self.sourceData.count > 0 ? YES : NO;
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EnterpriseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row < self.sourceData.count) {
        
        __weak EnterpriseTableViewCell *weakCell = cell;
        EnterpriseModel *model = self.sourceData[indexPath.row];
        
        [cell updateWithModel:model WithLikeClick:^(BOOL like) {
            
            UserDataModel *userMod = [UserDataManager shareInstance].userModel;
            NSDictionary *infoDic = @{@"cmd":@"addFollow",
                                      @"userID":(userMod ? userMod.userID : @""),
                                      @"qID":model.Exper_AnswerID
                                      };
            [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
                
                GCD_MAIN(^{
                    
                    if (response && ([response[@"status"] intValue] == 1)) {
                        
                        NSDictionary *dic = response[@"data"];
                        
//                        if (dic[@""]) {
//                            model.Exper_haveLike = !model.Exper_haveLike;
//                            [weakCell likeClickSuccess];
//                        }
                        
                    }
                    
                });
                
            } requestHead:^(id response) {
                
            } faile:^(NSError *error) {
                
            }];
            
        }];
    }
    
    
    return cell;
}

@end

