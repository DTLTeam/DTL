//
//  BaseNavViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "BaseNavViewController.h"

#import "SearchView.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //自定义导航
    UIViewController *vc = self.viewControllers[self.viewControllers.count - 1];
    
    if (vc && ([vc isKindOfClass:[MainAskViewController class]])) {
        self.navigationController.navigationBarHidden = YES;
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        
        
        SearchView *view = [[SearchView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44) SearchClick:^(NSString * searchtext) {
            
            NSLog(@"%@",searchtext);
        } WithAnswerClick:^(BOOL answer) {
            NSLog(@"点击发表");
        }];
       
        [self.view addSubview:view];
    }
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
