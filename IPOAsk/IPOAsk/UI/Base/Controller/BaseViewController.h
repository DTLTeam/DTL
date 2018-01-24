//
//  BaseViewController.h
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

@interface BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)void (^headerRefresh)(BOOL headerR);



@property (nonatomic,assign)BOOL haveRefresh;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,strong)NSMutableArray *sourceData;









- (void)endHeaderRefresh:(RefreshType)Type;

@end
