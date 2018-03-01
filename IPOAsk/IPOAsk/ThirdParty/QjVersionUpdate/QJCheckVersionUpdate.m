//
//  QJCheckVersionUpdate.m
//  QJVersionUpdateView
//
//  Created by Justin on 16/3/8.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "QJCheckVersionUpdate.h"
#import "QJVersionUpdateVIew.h"

#define GetUserDefaut [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionUpdateNotice"]
#define OLDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APPID  @"1221870806"


@implementation QJCheckVersionUpdate{
    
    QJVersionUpdateVIew *versionUpdateView;
}

/**
 *  demo
 */
//+ (void)CheckVerion:(UpdateBlock)updateblock
//{
//    NSString *currentAppStoreVersion = @"5.0.0";
//    if ([QJCheckVersionUpdate versionlessthan:[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut : OLDVERSION Newer:currentAppStoreVersion])
//    {
//        NSLog(@"暂不更新");
//    }else{
//        NSLog(@"请到appstore更新%@版本",currentAppStoreVersion);
//         NSString *describeStr = @"1.修正了部分单词页面空白的问题修正了部分单词页面空白的问题\n2.修正了部分单词页面空白的问题去够呛够呛\n3.修正了部分单词页面空白的问题";
//        NSLog(@"修复问题描述:%@",describeStr);
//        NSArray *dataArr = [QJCheckVersionUpdate separateToRow:describeStr];
//        if (updateblock) {
//            updateblock(currentAppStoreVersion,dataArr);
//        }
//    }
//}

/**
 *  正式
 */

+ (void)CheckVerion:(UpdateBlock)updateblock
{
    //************      test    ****************
    if (0) {
        if (updateblock) {
            updateblock(@"1.0.0",@[@"已经更新至xxx版本"]);
            return;
        }
    }else{
        return;
    }

    
    
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APPID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:storeURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ( [data length] > 0 && !error ) {
            // Success
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                /**
                 *  以上网络请求可以改成自己封装的类
                 */
                if(![versionsInAppStore count]) {
                    DLog(@"No versions of app in AppStore");
                    return;
                } else {
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0]; 
                    DLog(@"%@",OLDVERSION);
                    if ([QJCheckVersionUpdate versionlessthan:[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut : OLDVERSION Newer:currentAppStoreVersion]){
                        
                        DLog(@"暂不更新");
                    }else{
                        DLog(@"请到appstore更新%@版本",currentAppStoreVersion);
                        /**
                         *  修复问题描述
                         */
                        NSString *describeStr = [[[appData valueForKey:@"results"] valueForKey:@"releaseNotes"] objectAtIndex:0];
                        NSLog(@"修复问题描述:%@",describeStr);
                        NSArray *dataArr = [QJCheckVersionUpdate separateToRow:describeStr];
                        if (updateblock) {
                            updateblock(currentAppStoreVersion,dataArr);
                        }
                    }
                }
                
            });
        }

    }];
    [dataTask resume];
}


+ (BOOL)versionlessthan:(NSString *)oldOne Newer:(NSString *)newver
{
    if ([oldOne isEqualToString:newver]) {
        return YES;
    }else
    {
        if ([oldOne compare:newver options:NSWidthInsensitiveSearch] == NSOrderedDescending || [oldOne compare:newver options:NSWidthInsensitiveSearch] == NSOrderedSame)
        {
            return YES;
        }else{
            return NO;
        }
    }
        
    return NO;
}


+ (NSArray *)separateToRow:(NSString *)describe
{
    NSArray *array= [describe componentsSeparatedByString:@"\n"];
    return array;
}

- (void)showAlertView
{
   // __weak typeof(self) weakself = self;
    __block typeof(self) weakself = self;
    [QJCheckVersionUpdate CheckVerion:^(NSString *str, NSArray *DataArr) {
        if (!versionUpdateView) {
            versionUpdateView = [[QJVersionUpdateVIew alloc] initWith:[NSString stringWithFormat:@"版本:%@",str] Describe:DataArr];
            versionUpdateView.GoTOAppstoreBlock = ^{
                [weakself goToAppStore];
            };
            versionUpdateView.removeUpdateViewBlock = ^{
                [weakself removeVersionUpdateView];
            };
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"VersionUpdateNotice"];
        }
    }];
}

- (void)removeVersionUpdateView
{
    [versionUpdateView removeFromSuperview];
    versionUpdateView = nil;
}

- (void)goToAppStore
{
    NSString *urlStr = [self getAppStroeUrlForiPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

-(NSString *)getAppStroeUrlForiPhone{
    return [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@",APPID];
}

@end
