//
//  BaseViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImageView];
    
    UIControl *control = [[UIControl alloc]initWithFrame:_bgImageView.frame];
    [control addTarget:self action:@selector(baseRelodata) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgImageView addSubview:control];
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    _sourceData = [NSMutableArray array];
    
//    [AskProgressHUD AskShowTitleInView:self.view Title:@"正在加载" viewtag:100];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     
//    [AskProgressHUD AskHideAnimatedInView:self.view viewtag:100 AfterDelay:5];
}


#pragma mark - 是否有刷新
-(void)setHaveRefresh:(BOOL)haveRefresh{
    _haveRefresh = haveRefresh; 
    
    __weak BaseViewController *weakSelf = self;
    
    //实现刷新方法
    if (_haveRefresh) {
        // 上拉加载
        _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            weakSelf.currentPage ++;
            if (weakSelf.headerRefresh) {
                weakSelf.headerRefresh(NO);
            }
        }];
        
        //下拉刷新
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            weakSelf.currentPage = 1;
            if (weakSelf.headerRefresh) {
                weakSelf.headerRefresh(YES);
            }
        }];
    }
      
}

#pragma mark - 停止刷新
-(void)endHeaderRefresh:(RefreshType)Type{
    
    if (Type == RefreshType_header) {
        
        [self.myTableView.mj_header endRefreshing];
        
    }else [self.myTableView.mj_footer endRefreshing];
    
}


#pragma mark - 点击背景刷新数据
-(void)baseRelodata{
    
    //刷新
    self.currentPage = 1;
    if (self.headerRefresh) {
        self.headerRefresh(YES);
    }
    
}
-(void)setHaveData:(BOOL)haveData{
    _haveData = haveData;
    
    if (self.sourceData.count > 0) {
        self.bgImageView.hidden = YES;
        self.myTableView.hidden = NO;
    }else{
        self.bgImageView.hidden = NO;
        self.myTableView.hidden = YES;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    } 
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
