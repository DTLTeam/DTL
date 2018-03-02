//
//  AppDelegate.m
//  IPOAsk
//
//  Created by lzw on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AppDelegate.h"

#import <XGPush.h>

@interface AppDelegate () <XGPushDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[FMDBManager sharedInstance]creatTableWithName:@"Drafts" path:@[@"title",@"content",@"Type",@"anonymous",@"UserId"]];
 
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
    
    //插入字段－－用户ID
    [[FMDBManager sharedInstance] insertCOLUMNdocumentPathStringByAppendingPathComponent:@"" DBName:@"Drafts.sqlite" columnExists:@"UserId" Type:@"text" InClass:[DraftsModel class] WithClassName:@"Drafts"];
    
    [[XGPush defaultManager] startXGWithAppID:2200277581 appKey:@"I5194W3DNBUS" delegate:self];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - XGPushDelegate

- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    DLog(@"信鸽推送服务启动操作结果 : %@%@", isSuccess ? @"YES" : @"NO", (error ? [NSString stringWithFormat:@" | 启动错误内容 : %@", error] : @""));
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
    DLog(@"信鸽推送服务终止操作结果 : %@%@", isSuccess ? @"YES" : @"NO", (error ? [NSString stringWithFormat:@" | 终止错误内容 : %@", error] : @""));
}

@end
