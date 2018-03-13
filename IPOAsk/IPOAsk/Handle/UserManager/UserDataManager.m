//
//  UserDataManager.m
//  IPOAsk
//
//  Created by lzw on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import "UserDataManager.h"

#import <XGPush.h>

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


@interface UserDataManager () <XGPushTokenManagerDelegate>

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

#pragma mark 登录
- (void)signInWithAccount:(NSString *)account password:(NSString *)password complated:(void (^)(BOOL, NSString *))complatedBlock networkError:(void (^)(NSError *))networkErrorBlock {
    
    if (![NSThread currentThread].isMainThread) {
        GCD_MAIN(^{
            [self signInWithAccount:account password:password complated:complatedBlock networkError:networkErrorBlock];
        });
        return;
    }
    
    XGPushTokenManager *tokenManger = [XGPushTokenManager defaultTokenManager];
    [tokenManger unbindWithIdentifer:tokenManger.deviceTokenString type:XGPushTokenBindTypeNone];
    
    NSString *tempAccount = (account ? account : @"");
    NSString *tempPassword = (password ? password : @"");
    
    NSDictionary *infoDic = @{@"cmd":@"login",
                              @"phone":tempAccount,
                              @"password":[UtilsCommon md5WithString:tempPassword]};
    
    __weak typeof(self) weakSelf = self;
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
        
            NSDictionary *dic = (NSDictionary *)response;
            int result = [dic[@"status"] intValue];
            NSDictionary *dataDic = dic[@"data"];
            
            BOOL isSuccess = NO;
            if (result == 1 && dataDic) {
                
                //缓存登录数据
                UserDataModel *model = [[UserDataModel alloc] init];
                model.userID = dataDic[@"userID"];
                model.headIcon = dataDic[@"headIcon"];
                model.phone = dataDic[@"phone"];
                model.realName = dataDic[@"realName"];
                model.nickName = dataDic[@"nickName"];
                model.company = dataDic[@"company"];
                model.details = dataDic[@"details"];
                model.email = dataDic[@"email"];
                model.forbidden = [dataDic[@"forbidden"] intValue];
                model.isAnswerer = [dataDic[@"isAnswerer"] intValue];
                model.userType = [dataDic[@"userType"] intValue];
                model.Password = tempPassword;
                model.isPushMessage = [dataDic[@"receiveNotice"] boolValue];
                [weakSelf loginSetUpModel:model];
                
                NSDictionary *userDic = @{@"User":dataDic,
                                          @"Pwd":model.Password};
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:userDic forKey:@"UserInfo_only"];
                [defaults synchronize];
                
                if (model.isPushMessage) { //判断是否开启消息推送
                    [weakSelf bindPushToken:nil];
                }
                
                isSuccess = YES;
                
            } else {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"UserInfo_only"];
                [defaults synchronize];
                
                isSuccess = NO;
                
            }
            
            if (complatedBlock) {
                complatedBlock(isSuccess, (dic[@"msg"] ? dic[@"msg"] : @""));
            }
            
        }));
     
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            
            if (networkErrorBlock) {
                networkErrorBlock(error);
            }
            
        });
        
    }];
    
}

#pragma mark 绑定推送token
- (void)bindPushToken:(BindPushTokenComplatedBlock)complatedBlock {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    __weak NSString *token = [userDefaults objectForKey:@"device_token"];
    
    XGPushTokenManager *tokenManger = [XGPushTokenManager defaultTokenManager];
    tokenManger.delegatge = self;
    [tokenManger bindWithIdentifier:token type:XGPushTokenBindTypeNone];
    
    NSDictionary *infoDic = @{@"cmd":@"setToken",
                              @"reviceNotice":@(1),
                              @"userID":(_userModel ? _userModel.userID : @""),
                              @"token":(token ? token : @"")
                              };
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN(^{
            
            NSDictionary *dic = response;
            
            if ([dic[@"status"] intValue] == 1) {
                
                DLog(@"------  绑定信鸽用户指定推送成功  userID : %@ | token : %@", (_userModel ? _userModel.userID : @""), (token ? token : @""));
                
                if (complatedBlock) {
                    complatedBlock(YES);
                }
                
            } else {
                
                if (complatedBlock) {
                    complatedBlock(NO);
                }
                
            }
            
        });
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            if (complatedBlock) {
                complatedBlock(NO);
            }
        });
        
    }];
    
}

#pragma mark 退出登录
- (void)unbindPushToken:(UnbindPushTokenComplatedBlock)complatedBlock {
    
    NSDictionary *infoDic = @{@"cmd":@"setToken",
                              @"reviceNotice":@(0),
                              @"userID":(_userModel ? _userModel.userID : @""),
                              @"token":@(0)
                              };
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN(^{
            
            NSDictionary *dic = response;
            
            if ([dic[@"status"] intValue] == 1) {
                
                DLog(@"------  解除绑定信鸽用户指定推送成功  userID : %@", (_userModel ? _userModel.userID : @""));
                
                if (complatedBlock) {
                    complatedBlock(YES);
                }
                
            } else {
                
                if (complatedBlock) {
                    complatedBlock(NO);
                }
                
            }
            
        });
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            if (complatedBlock) {
                complatedBlock(NO);
            }
        });
        
    }];
    
}

#pragma mark 获取我的提问列表
- (void )getAskWithpage:(NSInteger)page finish:(void(^)(NSArray *dataArr, BOOL isEnd))finishBlock fail:(void (^)(NSError *error))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    static NSInteger startID;
    if (page == 1) {
        startID = 0;
    }
    
    NSDictionary *infoDic = @{@"cmd":@"getMyAskLists",
                              @"userID":_userModel.userID,
                              @"pageSize":@"20",
                              @"page":@(page),
                              @"maxQID":@(startID)
                              };
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            if (page == 1) {
                NSDictionary *dic = [[[response valueForKey:@"data"] valueForKey:@"data"] firstObject];
                if (dic) {
                    startID = [dic[@"id"] intValue];
                }
            }
            
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

#pragma mark 获取我的回答列表
- (void )getAnswerWithpage:(NSInteger)page finish:(void (^)(NSArray *, BOOL))finishBlock fail:(void (^)(NSError *))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    static NSInteger startID;
    if (page == 1) {
        startID = 0;
    }
    
    NSDictionary *infoDic = @{@"cmd":@"getMyAnswerLists",
                              @"userID":_userModel.userID,
                              @"pageSize":@"20",
                              @"page":@(page),
                              @"maxQID":@(startID)
                              };
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            if (page == 1) {
                NSDictionary *dic = [[[response valueForKey:@"data"] valueForKey:@"data"] firstObject];
                if (dic) {
                    startID = [dic[@"id"] intValue];
                }
            }
            
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
        
        GCD_MAIN(^{
            if (failBlock) {
                failBlock(error);
            }
        });
        
    }];
}

#pragma mark 获取我的关注列表
- (void )getFollowWithpage:(NSInteger)page finish:(void (^)(NSArray *, BOOL))finishBlock fail:(void (^)(NSError *))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    static NSInteger startID;
    if (page == 1) {
        startID = 0;
    }
    
    NSDictionary *infoDic = @{@"cmd":@"myFollowAsk",
                              @"userID":_userModel.userID,
                              @"pageSize":@"20",
                              @"page":@(page),
                              @"maxQID":@(startID)
                              };
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            if (page == 1) {
                NSDictionary *dic = [[[response valueForKey:@"data"] valueForKey:@"data"] firstObject];
                if (dic) {
                    startID = [dic[@"id"] intValue];
                }
            }
            
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
        
        GCD_MAIN(^{
            if (failBlock) {
                failBlock(error);
            }
        });
                 
    }];
}

#pragma mark 获取我的成就列表
- (void )getLikeWithpage:(NSInteger)page finish:(void (^)(NSArray *, BOOL))finishBlock fail:(void (^)(NSError *))failBlock
{
    if (!_userModel) {
        if (finishBlock) {
            finishBlock(nil, NO);
        }
        return;
    }
    
    static NSInteger startID;
    if (page == 1) {
        startID = 0;
    }
    
    NSDictionary *infoDic = @{@"cmd":@"getMyAchievement",
                              @"userID":_userModel.userID,
                              @"pageSize":@"20",
                              @"page":@(page),
                              @"maxQID":@(startID)
                              };
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        if ([response[@"status"] intValue] == 1) {
            
            if (page == 1) {
                NSDictionary *dic = [[[response valueForKey:@"data"] valueForKey:@"data"] firstObject];
                if (dic) {
                    startID = [dic[@"qID"] intValue];
                }
            }
            
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *jsonArr = [[response valueForKey:@"data"] valueForKey:@"data"];
            for (NSDictionary *dic in jsonArr) {
                LikeDataModel *model = [[LikeDataModel alloc] init];
                model.askId = dic[@"qID"];
                model.realName = dic[@"realName"];
                model.headIcon = [NSString stringWithFormat:@"%@",[dic valueForKey:@"headIcon"]];
                model.title = dic[@"title"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                model.likeTime = ![dic[@"likeTime"] isKindOfClass:[NSNull class]] ? [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"likeTime"] intValue]]] : @"";
                model.addTime = ![dic[@"addTime"] isKindOfClass:[NSNull class]] ? [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"addTime"] intValue]]] : @"";
                
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
        
        GCD_MAIN(^{
            if (failBlock) {
                failBlock(error);
            }
        });
        
    }];
}


#pragma mark - XGPushTokenManagerDelegate

- (void)xgPushDidUnbindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    DLog(@"-----  解绑信鸽推送  ID : %@ | error : %@", identifier, error);
}

- (void)xgPushDidBindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    DLog(@"-----  绑定信鸽推送  ID : %@ | error : %@", identifier, error);
}

@end
