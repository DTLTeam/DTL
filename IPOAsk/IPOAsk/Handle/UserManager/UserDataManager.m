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

/**
 问题数据类型
 */
@implementation AskDataModel

@end

/**
 关注数据类型
 */
@implementation FollowDataModel

@end

/**
 点赞数据类型
 */
@implementation LikeDataModel

@end

/**
 回答数据类型
 */
@implementation AnswerDataModel

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

- (void )getAskWithpage:(NSString *)page finish:(void(^)(NSArray *dataArr))block
{
    if (!_userModel) {
        block(nil);
        return;
    }
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyAskLists",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            NSMutableArray *dataArr = [NSMutableArray array];
//            NSArray *jsonArr = response[@"data"];
            NSArray *jsonArr = response[@"data"][@"data"];
            for (NSDictionary *dic in jsonArr) {
                AskDataModel *model = [[AskDataModel alloc] init];
                model.askId = [NSString stringWithFormat:@"%@",dic[@"id"]]; 
                model.title = dic[@"title"];
                model.content = dic[@"content"];
                model.view = [dic[@"view"] intValue];
                model.addTime = [NSString stringWithFormat:@"%@",dic[@"addTime"]];
                model.createUID = [dic[@"createUID"] intValue];
                model.isAnonymous = [dic[@"isAnonymous"] intValue];
                model.isCompany = [dic[@"isCompany"] intValue];
                model.follow = [dic[@"follow"] intValue];
                model.answer = [dic[@"answer"] intValue];
                [dataArr addObject:model];
            }
            block(dataArr);
        }else   block(nil);
    }  requestHead:nil faile:^(NSError *error) {
        block(nil);
    }];
}

- (void )getFollowWithpage:(NSString *)page finish:(void(^)(NSArray *dataArr))block
{
    if (!_userModel) {
        block(nil);
        return;
    }
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"myFollowAsk",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *jsonArr = response[@"data"];
            for (NSDictionary *dic in jsonArr) {
                FollowDataModel *model = [[FollowDataModel alloc] init];
                model.askId = dic[@"id"];
                model.nickName = dic[@"nickName"];
                model.content = dic[@"content"];
                model.headIcon = dic[@"headIcon"];
                model.view = [dic[@"view"] intValue];
                model.addTime = dic[@"addTime"];
                model.title = dic[@"title"];
                model.isAnonymous = [dic[@"isAnonymous"] intValue];
                model.isCompany = [dic[@"isCompany"] intValue];
                model.isFollow = [dic[@"isFollow"] intValue];
                model.follow = [dic[@"follow"] intValue];
                model.answer = [dic[@"answer"] intValue];
                [dataArr addObject:model];
            }
            block(dataArr);
        }else   block(nil);
        
    } requestHead:nil faile:^(NSError *error) {
        block(nil);
    }];
}

- (void )getLikeWithpage:(NSString *)page finish:(void(^)(NSArray *dataArr))block
{
    if (!_userModel) {
        block(nil);
        return;
    }
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyAchievement",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            NSMutableArray *dataArr = [NSMutableArray array];
//            NSArray *jsonArr = response[@"data"];
            NSArray *jsonArr = response[@"data"][@"data"];
            for (NSDictionary *dic in jsonArr) {
                LikeDataModel *model = [[LikeDataModel alloc] init];
                model.askId = dic[@"qID"];
                model.realName = dic[@"realName"];
                model.headIcon = dic[@"headIcon"];
                model.likeTime = dic[@"likeTime"];
                model.addTime = dic[@"addTime"];
                model.title = dic[@"title"];
                [dataArr addObject:model];
            }
            block(dataArr);
        }else  block(nil);
    }  requestHead:nil faile:^(NSError *error) {
        block(nil);
    }];
}

- (void )getAnswerWithpage:(NSString *)page finish:(void(^)(NSArray *dataArr))block
{
    if (!_userModel) {
        block(nil);
        return;
    }
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyAnswerLists",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *jsonArr = response[@"data"];
            for (NSDictionary *dic in jsonArr) {
                AnswerDataModel *model = [[AnswerDataModel alloc] init];
                model.askId = dic[@"id"];
                model.nickName = dic[@"nickName"];
                model.content = dic[@"content"];
                model.headIcon = dic[@"headIcon"];
                model.view = [dic[@"view"] intValue];
                model.addTime = dic[@"addTime"];
                model.title = dic[@"title"];
                model.isAnonymous = [dic[@"isAnonymous"] intValue];
                model.isCompany = [dic[@"isCompany"] intValue];
                model.isFollow = [dic[@"isFollow"] intValue];
                model.follow = [dic[@"follow"] intValue];
                model.answer = [dic[@"answer"] intValue];
                [dataArr addObject:model];
            }
            block(dataArr);
        }else   block(nil);
    }  requestHead:nil faile:^(NSError *error) {
        block(nil);
    }];
}


@end
