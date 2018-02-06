//
//  EnterpriseViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseViewController.h" 
#import "ApplicationEnterpriseViewController.h"
#import "EditQuestionViewController.h"

#import "NotEnterpriseView.h"
#import "EnterpriseNotQuestionView.h"

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
    
    UIImage *img = [[UIImage imageNamed:@"企业-pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.tabBarItem setSelectedImage:img];
    [self.navigationController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEX_RGB_COLOR(0x0b98f2),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.title = @"企业+";
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bgImageView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.backgroundColor = HEX_RGB_COLOR(0xF2F2F2);
    
    self.haveRefresh = YES;
    
    
    [self setUpViews];
    
    
    self.headerRefresh = ^(BOOL headerR) {
        
        NSLog(@"点击背景图刷新消息");
    };
    
}


- (void)setUpViews{
    
    __weak EnterpriseViewController *WeakSelf = self;
    
#if 1 //是否是专家
//    [self setUpdata];
    
    // ****************** 已经是专家
    if (!self.haveData) {
        
        EnterpriseNotQuestionView *view  = [[NSBundle mainBundle] loadNibNamed:@"EnterpriseNotQuestionView" owner:self options:nil][0];
        [self.bgImageView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.and.bottom.mas_equalTo(self.bgImageView);
        }];
        self.myTableView.hidden = YES;
        
        
        //点击发布问题
        view.addQuestionClickBlock = ^(UIButton *sender) {
            [WeakSelf Consultation];
        };
        
    }else{
        //有数据
    }
    // ****************** 已经是专家
    
#else
    
    // ****************** 个人用户
    
    NotEnterpriseView *view  = [[NSBundle mainBundle] loadNibNamed:@"NotEnterpriseView" owner:self options:nil][0];
    [self.bgImageView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.mas_equalTo(self.bgImageView);
    }];
    self.myTableView.hidden = YES;
    
    // ****************** 个人用户
    
#endif
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"EnterpriseTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
}


#pragma mark -  UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
 
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
    EditQuestionViewController *VC = [[NSBundle mainBundle] loadNibNamed:@"EditQuestionViewController" owner:self options:nil][0];
    [VC UserType:AnswerType_AskQuestionEnterprise NavTitle:@"企业+"];
    [self.navigationController pushViewController:VC animated:YES];
    
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

