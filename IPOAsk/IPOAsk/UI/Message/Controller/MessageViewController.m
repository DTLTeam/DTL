//
//  MessageViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MessageViewController.h"

#import "AnswerOrLikeTableViewCell.h" 

@interface MessageViewController ()

@end

static NSString * CellIdentifier = @"AOrLikeCell";

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *img = [[UIImage imageNamed:@"消息-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.title = @"消息";
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    self.haveRefresh = YES;
    
    [self setUpData];
    
    __weak MessageViewController *weakSlef = self;
    self.headerRefresh = ^(BOOL headerR) {
        
        [weakSlef endHeaderRefresh:RefreshType_all];
        NSLog(@"点击背景图刷新消息");
    };
    
 
    [self setUpViews];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"AnswerOrLikeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AnswerOrLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    AnswerOrLikeModel *model = self.sourceData[indexPath.row];
    if (model) {
        [cell updateWithModel:model];
    }
    
    
    return cell;
}

- (void)setUpViews{
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

- (void)setUpData{
    // test******************  测试数据
    
    NSArray *Arr = @[@{@"question":@"这是问题是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"这是回答哈哈哈哈",
                       @"like":@"2"
                       },
                     @{@"question":@"哈哈哈哈哈是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这",
                       @"like":@"1"
                       },
                     @{@"question":@"问题哈哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈",
                       @"like":@"2"
                       },
                     @{@"question":@"题哈哈哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"是",
                       @"like":@"1"
                       },
                     @{@"question":@"这哈哈哈哈是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈",
                       @"name":@"我是专家",
                       @"time":@"2018/01/20",
                       @"answer":@"是这是回答哈哈哈哈",
                       @"like":@"1"
                       },
                     @{@"question":@"这是哈这",
                       @"name":@"我是专家",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这",
                       @"like":@"0"
                       }
                     ];
    
    [Arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AnswerOrLikeModel *model = [[AnswerOrLikeModel alloc]init];
        
        model.AorL_questionTitle = [obj valueForKey:@"question"];
        model.AorL_Nick = [obj valueForKey:@"name"];
        model.AorL_AnswerDate = [obj valueForKey:@"time"];
        model.AorL_AnswerContent = [obj valueForKey:@"answer"];
        model.AorL_Type = [[obj valueForKey:@"like"]intValue];
        
        [self.sourceData addObject:model];
    }];
    
    // test****************** 测试数据
    
    self.haveData = self.sourceData.count > 0 ? YES : NO;
}

@end
