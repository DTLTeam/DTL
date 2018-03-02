//
//  AppDelegate.m
//  IPOAsk
//
//  Created by lzw on 2018/1/23.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AppDelegate.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import <XGPush.h>

@interface AppDelegate () <XGPushDelegate, XGPushTokenManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[FMDBManager sharedInstance]creatTableWithName:@"Drafts" path:@[@"title",@"content",@"Type",@"anonymous",@"UserId"]];
 
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
    
    //插入字段－－用户ID
    [[FMDBManager sharedInstance] insertCOLUMNdocumentPathStringByAppendingPathComponent:@"" DBName:@"Drafts.sqlite" columnExists:@"UserId" Type:@"text" InClass:[DraftsModel class] WithClassName:@"Drafts"];
    
    XGPush *push = [XGPush defaultManager];
    [push startXGWithAppID:2200277581 appKey:@"I5194W3DNBUS" delegate:self];
    [push reportXGNotificationInfo:launchOptions]; //统计信鸽推送消息抵达的情况
    
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


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //注册推送设备token，使服务端识别设备
    XGPushTokenManager *tokenManager = [XGPushTokenManager defaultTokenManager];
    [tokenManager registerDeviceToken:deviceToken];
    
    //注册成功，可将该token和用户ID一起上传给服务器，让服务器进行指定推送
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:tokenManager.deviceTokenString forKey:@"push_device_token"];
    [userDefaults synchronize];
    
    UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
    if (userMod) {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_device_token"];
        
        NSDictionary *infoDic = @{@"cmd":@"setToken",
                                  @"userID":(userMod ? userMod.userID : @""),
                                  @"token":(token ? token : @"")
                                  };
        [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
            
            NSDictionary *dic = response[@"data"];
            
            if ([dic[@"status"] intValue] == 1) {
                
            }
            
        } requestHead:nil faile:^(NSError *error) {
            
        }];
        
    }
    
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //统计信鸽推送消息被点击的数据 (iOS 10.0之前的版本)
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
}

#endif


#pragma mark - XGPushDelegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    //统计信鸽推送消息被点击的数据 (iOS 10.0及以后的版本)
    [[XGPush defaultManager] reportXGNotificationInfo:response.notification.request.content.userInfo];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    completionHandler();
}

- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler { //App在前台弹通知需要调用这个接口
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

#endif

- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    DLog(@"----- 信鸽推送服务启动操作结果 : %@%@", isSuccess ? @"YES" : @"NO", (error ? [NSString stringWithFormat:@" | 启动错误内容 : %@", error] : @""));
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
    DLog(@"----- 信鸽推送服务终止操作结果 : %@%@", isSuccess ? @"YES" : @"NO", (error ? [NSString stringWithFormat:@" | 终止错误内容 : %@", error] : @""));
}

@end
