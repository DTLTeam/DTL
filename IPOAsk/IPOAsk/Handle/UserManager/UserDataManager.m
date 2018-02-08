//
//  UserDataManager.m
//  IPOAsk
//
//  Created by lzw on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import "UserDataManager.h"

/**
 用户数据类型
 */
@implementation UserDataModel

@end


@interface UserDataManager ()

@end

@implementation UserDataManager

static UserDataManager *manager; //单例对象


- (instancetype)init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserDataManager alloc] init];
    });
    
    return manager;
    
}


- (void)loginSetUpModel:(UserDataModel *)model
{
    _userModel = model;
}

- (void )getAskWithpage:(NSInteger)page finish:(void(^)(NSArray *dataArr))block;
{
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyAskLists",@"userID":@"9093a3325caeb5b33eb08f172fe59e7c",@"pageSize":@"30",@"page":@"1"} backData:NetSessionResponseTypeJSON success:^(id response) {
        
    } requestHead:nil faile:nil];
}






@end
