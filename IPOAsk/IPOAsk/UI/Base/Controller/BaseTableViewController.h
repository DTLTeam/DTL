//
//  BaseTableViewController.h
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

typedef enum : NSUInteger {
    RefreshType_header,
    RefreshType_foot,
} RefreshType;

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UITableView *myTableView;

/**
 控制器的刷新数据实现
 */
@property (nonatomic,strong)void (^headerRefresh)(BOOL headerR);



/**
 控制器是否带上下拉刷新功能
 YES OR NO
 */
@property (nonatomic,assign)BOOL haveRefresh;

/**
 根据haveData是否显示背景图
  YES OR NO
 */
@property (nonatomic,assign)BOOL haveData;

@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,strong)NSMutableArray *sourceData;









- (void)endHeaderRefresh:(RefreshType)Type;


@end
