//
//  BaseTableViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "BaseTableViewController.h"

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UtilsCommon createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UtilsCommon createImageWithColor:[UIColor whiteColor]]];
    self.navigationController.navigationBar.shadowImage = [UtilsCommon createImageWithColor:[UIColor whiteColor]];
    
    
    //无数据背景图
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImageView];
    
    UIControl *control = [[UIControl alloc]initWithFrame:_bgImageView.frame];
    [control addTarget:self action:@selector(baseRelodata) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgImageView addSubview:control];
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.backgroundColor = HEX_RGB_COLOR(0xF1F1F1);
    [self.view addSubview:_myTableView];
    
    _sourceData = [NSMutableArray array];
  
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    [AskProgressHUD AskShowTitleInView:self.view Title:@"正在加载" viewtag:100];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //    [AskProgressHUD AskHideAnimatedInView:self.view viewtag:100 AfterDelay:5];
}


#pragma mark - 是否有刷新
-(void)setHaveRefresh:(BOOL)haveRefresh{
    _haveRefresh = haveRefresh;
    
    __weak BaseTableViewController *weakSelf = self;
    
    //实现刷新方法
    if (_haveRefresh) {
        //上拉加载
        MyRefreshAutoGifFooter *footer = [MyRefreshAutoGifFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage ++;
            
            if (weakSelf.headerRefresh) {
                weakSelf.headerRefresh(NO);
            }
            
        }];
        self.myTableView.mj_footer = footer;
        
        //下拉刷新
        MyRefreshAutoGifHeader *header = [MyRefreshAutoGifHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            if (weakSelf.headerRefresh) {
                weakSelf.headerRefresh(YES);
            }
        }];
        self.myTableView.mj_header = header;
         
    }else{
        
        //移除刷新
        if (_myTableView.mj_footer) {
            [_myTableView.mj_footer removeFromSuperview];
        }
        if (_myTableView.mj_header) {
            [_myTableView.mj_header removeFromSuperview];
        }
        
    }
    
}

/**
 停止刷新

 @param Type 停止头部或尾部或全部
 */

#pragma mark - 停止刷新
-(void)endHeaderRefresh:(RefreshType)Type{
    
    if (Type == RefreshType_header) {
        
        [self.myTableView.mj_header endRefreshing];
        
    }else if (Type == RefreshType_foot){
       
        [self.myTableView.mj_footer endRefreshingWithCompletionBlock:^{
            [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            self.myTableView.mj_footer.hidden = YES;
        }];
        
    }else{
        
        [self.myTableView.mj_header endRefreshing];
       
        [self.myTableView.mj_footer endRefreshingWithCompletionBlock:^{
            [self.myTableView.mj_footer endRefreshingWithNoMoreData];
//            self.myTableView.mj_footer.hidden = YES;
        }];
    }
    
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
        
        if (![self.bgImageView viewWithTag:2000]) {
         
            UILabel *label = [[UILabel alloc]init];
            label.tag = 2000;
            [self.bgImageView addSubview:label];
            label.text = _BgTitle;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(self.bgImageView.mas_centerX);
                make.centerY.mas_equalTo(self.bgImageView.mas_centerY).offset(30);
            }];
            
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_BgImage]];
            [self.bgImageView addSubview:img];
            
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(label.mas_centerX).offset(30);
                make.bottom.mas_equalTo(label.mas_top).offset(-30);
            }];
            
        }
    }
    [self.myTableView reloadData];
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

