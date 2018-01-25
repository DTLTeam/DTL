//
//  MainAskViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainAskViewController.h"


#import "SearchView.h"

@interface MainAskViewController ()

@end

@implementation MainAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    __weak MainAskViewController *weakSelf = self;
    
    self.haveRefresh = YES;
    self.haveData = weakSelf.sourceData.count > 0 ? YES : NO;
    
    self.bgImageView.backgroundColor = [UIColor lightGrayColor];
    
    NSArray *arr = @[@"呵呵",@"hhehehhe",@"哈哈哈",@"???"];
    
    self.headerRefresh = ^(BOOL headerR) {
        if (headerR) {
            
            NSLog(@"下拉刷新:%ld",weakSelf.currentPage);
            
             //test**********
            [weakSelf.sourceData removeAllObjects];
            [weakSelf.sourceData addObjectsFromArray:arr];
            weakSelf.haveData = weakSelf.sourceData.count > 0 ? YES : NO;
            
            [weakSelf endHeaderRefresh:RefreshType_header]; 
            
            
            [weakSelf.myTableView reloadData];
            //test**********
            
        }else{
            
            NSLog(@"上拉加载更多:%ld",weakSelf.currentPage);
            
            //test**********
            [weakSelf.sourceData addObjectsFromArray:arr];
            weakSelf.haveData = weakSelf.sourceData.count > 0 ? YES : NO;
            
            [weakSelf endHeaderRefresh:RefreshType_foot];
            
            [weakSelf.myTableView reloadData];
            //test**********
        }
    };
    

    
}
- (void)viewDidAppear:(BOOL)animated{
   
    [super viewDidAppear:animated];
    
    //test**********
    NSString *baiduUrlStr = @"http://api.map.baidu.com/geocoder/v2/?location=65.682895,-17.548928&output=json&pois=1&ak=oIu1ZLCZnUykB1xnFFfUXUIEvCushs4p";
    
    
    [[AskHttpLink shareInstance]get:baiduUrlStr param:nil backData:NetSessionResponseTypeJSON success:^(id response) {
        NSLog(@"成功%@",response);
        
    } requestHead:^(id response) {
        NSLog(@"%@",response);
        
    } faile:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    //test**********
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.sourceData[indexPath.row];
    return cell;
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
