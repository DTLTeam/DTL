//
//  EnterpriseViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseViewController.h" 
#import "ApplicationEnterpriseViewController.h"

#import "TipsViews.h"
#import "EnterpriseTableViewCell.h"


@interface EnterpriseViewController ()

@end

static NSString * CellIdentifier = @"EnterpriseCell";


@implementation EnterpriseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"企业+";
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bgImageView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.backgroundColor = HEX_RGB_COLOR(0xF2F2F2);
    
    self.haveRefresh = NO;
    
    
    [self setUpViews];
    
    
    self.headerRefresh = ^(BOOL headerR) {
        
        NSLog(@"点击背景图刷新消息");
    };
    
}


- (void)setUpViews{
    
#if 1
    [self setUpdata];
    
    // test****************** 已经是专家
    if (!self.haveData) {
        //没有数据
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 10, SCREEN_WIDTH / 2, 30)];
        label.text = @"还没有向专家提出问题";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [self.bgImageView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(Consultation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"马上咨询专家" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.frame = CGRectMake(SCREEN_WIDTH / 4, CGRectGetMaxY(label.frame) , SCREEN_WIDTH / 2, 30);
        [self.bgImageView addSubview:btn];
        
    }else{
        //有数据
    }
    // test****************** 已经是专家
#else
    
    // test****************** 个人用户
    
    TipsViews *tips = [[TipsViews alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tips.tag = 10000;
    [[UIApplication sharedApplication].keyWindow addSubview:tips];
    
    __weak EnterpriseViewController *weakSelf = self;
    __weak TipsViews *weakTips = tips;
    
    [tips showWithContent:@"申请成为企业用户与专家团队一对一交流" tipsImage:nil LeftTitle:@"以后再说" RightTitle:@"申请成为企业账户" block:^(UIButton *btn) {
        NSLog(@"稍后再说");
    } rightblock:^(UIButton *btn) {
        
        [weakTips dissmiss];
        
        //申请
        UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        if (storyboayd) {
            
            UIStoryboard *storyboayd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ApplicationEnterpriseViewController *tabVC = [storyboayd instantiateViewControllerWithIdentifier:@"ApplicationEnterprise"];
            
            weakSelf.navigationController.tabBarController.tabBar.hidden = YES;
            [weakSelf.navigationController pushViewController:tabVC animated:YES];
        }
    }]; 
    
    // test****************** 个人用户
    
#endif
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"EnterpriseTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];

}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EnterpriseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row < self.sourceData.count) {
        
        EnterpriseModel *model = self.sourceData[indexPath.row];
        
        __weak EnterpriseTableViewCell *weakCell = cell;
        
        [cell updateWithModel:model WithLikeClick:^(BOOL like) {
      
            // test**********点赞请求成功
            if (1) {
                [weakCell likeClickSuccess];
                
                model.Exper_haveLike = !model.Exper_haveLike;
                
            }else{
                NSLog(@"点赞失败");
            }
            
        }];
    }
    
    
    return cell;
}

#pragma mark - 马上咨询专家
- (void)Consultation{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)setUpdata{
    
    // test******************  测试数据
    
    NSArray *Arr = @[@{@"question":@"这是问题哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈"
                       },
                     @{@"question":@"这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈"
                       },
                     @{@"question":@"这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈"
                       },
                     @{@"question":@"这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈",
                       @"name":@"？？？",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈"
                       },
                     @{@"question":@"这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈",
                       @"name":@"我是专家",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈"
                       },
                     @{@"question":@"这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈这是问题哈哈哈哈哈哈",
                       @"name":@"我是专家",
                       @"time":@"2018/01/20",
                       @"answer":@"是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈哈这是回答哈哈哈哈"
                       }
                     ];
    
    [Arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EnterpriseModel *model = [[EnterpriseModel alloc]init];
        model.Exper_questionTitle = [obj valueForKey:@"question"];
        model.Exper_expertNick = [obj valueForKey:@"name"];
        model.Exper_recoveryDate = [obj valueForKey:@"time"];
        model.Exper_AnswerContent = [obj valueForKey:@"answer"];
        
        [self.sourceData addObject:model];
    }];
    
    // test****************** 测试数据
    
    self.haveData = self.sourceData.count > 0 ? YES : NO;
}
 

@end

