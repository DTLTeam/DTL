//
//  BaseTabBarViewController.m
//  IPOAsk
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()<UITabBarDelegate>{
    
    //最近一次选择的Index
    NSUInteger _lastSelectedIndex;
}

@end

@implementation BaseTabBarViewController

@synthesize lastSelectedIndex = _lastSelectedIndex;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex

{
    //调用父类的setSelectedIndex
    [super setSelectedIndex:selectedIndex];
    _lastSelectedIndex = self.selectedIndex;
    
    if (selectedIndex == 1) {
        self.selectedIndex = _lastSelectedIndex;
    }
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item

{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];

    if (tabIndex != self.selectedIndex) {
        _lastSelectedIndex = self.selectedIndex;
    }
    
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
