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

#pragma mark - 功能

- (void)refreshModel:(NSDictionary *)infoDic {
    
    if (!infoDic) {
        return;
    }
    
    id content;
    
    content = infoDic[@"isAnonymous"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _isAnonymous = [content boolValue];
    }
    content = infoDic[@"isFollow"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _IsAttention = [content boolValue];
    }
    
    content = infoDic[@"id"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        if ([content isKindOfClass:[NSNumber class]]) {
            content = [content stringValue];
        }
        _askId = content;
    }
    
//    content = infoDic[@"headIcon"];
//    if (content && ![content isKindOfClass:[NSNull class]]) {
//        _headImgUrlStr = [content];
//    }
//    content = infoDic[@"nickName"];
//    if (content && ![content isKindOfClass:[NSNull class]]) {
//        _userName = content;
//    }
    
    content = infoDic[@"addTime"];
    if (content && [content isKindOfClass:[NSNull class]]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[content integerValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _addTime = [formatter stringFromDate:date];
    }
    
    content = infoDic[@"title"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _title = content;
    }
    content = infoDic[@"content"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _content = content;
    }
    
    content = infoDic[@"view"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _View = [content intValue];
    }
    content = infoDic[@"answer"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _Answer = [content intValue];
    }
    content = infoDic[@"follow"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _Follow = [content intValue];
    }
    
}

- (void)changeAttentionStatus:(BOOL)status count:(NSInteger)count {
    
    _IsAttention = status;
    _Follow = count;
    
}

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

#pragma mark - 功能
- (void)refreshModel:(NSDictionary *)infoDic{
    
    if (!infoDic) {
        return;
    }
    
    
    id content;
    
    content = infoDic[@"isAnonymous"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _IsAnonymous = [content boolValue];
    }
    content = infoDic[@"isFollow"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _IsFollow = [content boolValue];
    }
    
}

- (void)changeAttentionStatus:(BOOL)status count:(NSInteger)count {
    
    _IsFollow = status;
    _Follow = count;
    
}

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

- (void )getAskWithpage:(NSString *)page finish:(void(^)(NSArray *dataArr, BOOL isEnd))finishBlock fail:(void (^)(NSError *error))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyAskLists",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *jsonArr = [[response valueForKey:@"data"] valueForKey:@"data"];
            for (NSDictionary *dic in jsonArr) {
                AskDataModel *model = [[AskDataModel alloc] init];
                model.askId = [NSString stringWithFormat:@"%@",dic[@"id"]]; 
                model.title = dic[@"title"];
                model.content = dic[@"content"];
                model.View = [dic[@"view"] intValue];
                model.createUID = [dic[@"createUID"] intValue];
                model.isAnonymous = [dic[@"isAnonymous"] intValue];
                model.isCompany = [dic[@"isCompany"] intValue];
                model.Follow = [dic[@"follow"] intValue];
                model.Answer = [dic[@"answer"] intValue];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                model.addTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"addTime"] intValue]]];
                
                [dataArr addObject:model];
            }
            
            BOOL isEnd = NO;
            if ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue]) {
                isEnd = YES;
            }
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(dataArr, isEnd);
                }
            });
            
        } else {
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(nil, NO);
                }
            });
            
        }
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            if (failBlock) {
                failBlock(error);
            }
        });
        
    }];
}

- (void )getFollowWithpage:(NSString *)page finish:(void (^)(NSArray *, BOOL))finishBlock fail:(void (^)(NSError *))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"myFollowAsk",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *jsonArr = [[response valueForKey:@"data"] valueForKey:@"data"];
            for (NSDictionary *dic in jsonArr) {
                FollowDataModel *model = [[FollowDataModel alloc] init];
                model.askId = dic[@"id"];
                model.nickName = dic[@"nickName"];
                model.content = dic[@"content"];
                model.headIcon = [NSString stringWithFormat:@"%@",[dic valueForKey:@"headIcon"]];
                model.view = [dic[@"view"] intValue];
                model.title = dic[@"title"];
                model.isAnonymous = [dic[@"isAnonymous"] intValue];
                model.isCompany = [dic[@"isCompany"] intValue];
                model.isFollow = [dic[@"isFollow"] intValue];
                model.follow = [dic[@"follow"] intValue];
                model.answer = [dic[@"answer"] intValue];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                model.addTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"addTime"] intValue]]];
                
                [dataArr addObject:model];
            }
            
            BOOL isEnd = NO;
            if ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue]) {
                isEnd = YES;
            }
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(dataArr, isEnd);
                }
            });
            
        } else {
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(nil, NO);
                }
            });
            
        }
        
    } requestHead:nil faile:^(NSError *error) {
        
        if (failBlock) {
            failBlock(error);
        }
        
    }];
}

- (void )getLikeWithpage:(NSString *)page finish:(void (^)(NSArray *, BOOL))finishBlock fail:(void (^)(NSError *))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyAchievement",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *jsonArr = [[response valueForKey:@"data"] valueForKey:@"data"];
            for (NSDictionary *dic in jsonArr) {
                LikeDataModel *model = [[LikeDataModel alloc] init];
                model.askId = dic[@"qID"];
                model.realName = dic[@"realName"];
                model.headIcon = [NSString stringWithFormat:@"%@",[dic valueForKey:@"headIcon"]];
                model.likeTime = [NSString stringWithFormat:@"%@",[dic valueForKey:@"likeTime"]] ;
                model.title = dic[@"title"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                model.addTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"addTime"] intValue]]];
                
                [dataArr addObject:model];
            }
            
            BOOL isEnd = NO;
            if ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue]) {
                isEnd = YES;
            }
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(dataArr, isEnd);
                }
            });
            
        } else {
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(nil, NO);
                }
            });
            
        }
        
    }  requestHead:nil faile:^(NSError *error) {
        
        if (failBlock) {
            failBlock(error);
        }
        
    }];
}

- (void )getAnswerWithpage:(NSString *)page finish:(void (^)(NSArray *, BOOL))finishBlock fail:(void (^)(NSError *))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"getMyAnswerLists",@"userID":_userModel.userID,@"pageSize":@"30",@"page":page} backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *jsonArr = [[response valueForKey:@"data"] valueForKey:@"data"];
            for (NSDictionary *dic in jsonArr) {
                AnswerDataModel *model = [[AnswerDataModel alloc] init];
                model.askId = dic[@"id"];
                model.nickName = dic[@"nickName"];
                model.content = dic[@"content"];
                model.headIcon = [NSString stringWithFormat:@"%@",[dic valueForKey:@"headIcon"]];
                model.LookNum = [dic[@"view"] intValue];
                model.title = dic[@"title"];
                model.IsAnonymous = [dic[@"isAnonymous"] intValue];
                model.IsCompany = [dic[@"isCompany"] intValue];
                model.IsFollow = [dic[@"isFollow"] intValue];
                model.Follow = [dic[@"follow"] intValue];
                model.Answer = [dic[@"answer"] intValue];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                model.addTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"addTime"] intValue]]];
                
                [dataArr addObject:model];
            }
            
            BOOL isEnd = NO;
            if ([response[@"data"][@"current_page"] integerValue] == [response[@"data"][@"last_page"] integerValue]) {
                isEnd = YES;
            }
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(dataArr, isEnd);
                }
            });
            
        } else {
            
            GCD_MAIN(^{
                if (finishBlock) {
                    finishBlock(nil, NO);
                }
            });
            
        }
        
    }  requestHead:nil faile:^(NSError *error) {
        
        if (failBlock) {
            failBlock(error);
        }
        
    }];
}


@end
