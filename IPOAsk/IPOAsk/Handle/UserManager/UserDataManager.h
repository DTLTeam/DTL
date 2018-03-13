//
//  UserDataManager.h
//  IPOAsk
//
//  Created by lzw on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户数据模型
 */
@interface UserDataModel : NSObject

@property (strong, nonatomic) NSString *userID;
@property (nonatomic, strong) NSString *phone;
@property (strong, nonatomic) NSString *headIcon;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *realName;
@property (assign, nonatomic) int userType;
@property (strong, nonatomic) NSString *company;
@property (assign, nonatomic) int isAnswerer;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *Password;
@property (nonatomic, assign) int forbidden;
@property (nonatomic, assign) BOOL isPushMessage;

@end

/**
 关注数据模型
 */
@interface FollowDataModel : NSObject

@property (strong, nonatomic) NSString *askId;
@property (nonatomic, strong) NSString *nickName;
@property (strong, nonatomic) NSString *headIcon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *addTime;
@property (assign, nonatomic) int view;
@property (assign, nonatomic) int follow;
@property (assign, nonatomic) int answer;
@property (assign, nonatomic) int isAnonymous;
@property (assign, nonatomic) int isCompany;
@property (assign, nonatomic) int isFollow;

@end

/**
 回答数据模型
 */
@interface AnswerDataModel : NSObject

@property (strong, nonatomic) NSString *askId;
@property (nonatomic, strong) NSString *nickName;
@property (strong, nonatomic) NSString *headIcon;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *addTime;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) int LookNum;
@property (assign, nonatomic) int Answer;
@property (assign, nonatomic) int IsAnonymous;
@property (assign, nonatomic) int IsCompany;
@property (assign, nonatomic) int IsFollow;
@property (nonatomic, assign) int Follow;
 

#pragma mark - 功能
- (void)refreshModel:(NSDictionary *)infoDic;


- (void)changeAttentionStatus:(BOOL)status count:(NSInteger)count;

@end

/**
 回答数据模型
 */
@interface LikeDataModel : NSObject

@property (strong, nonatomic) NSString *askId;
@property (nonatomic, strong) NSString *realName;
@property (strong, nonatomic) NSString *headIcon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *addTime;
@property (strong, nonatomic) NSString *likeTime;
@end

/**
 问题数据模型
 */
@interface AskDataModel : NSObject

@property (strong, nonatomic) NSString *askId;
@property (nonatomic, strong) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *addTime;
@property (assign, nonatomic) int View;
@property (assign, nonatomic) int createUID;
@property (assign, nonatomic) int Answer;
@property (assign, nonatomic) int isAnonymous;
@property (assign, nonatomic) int IsAttention;
@property (assign, nonatomic) int isCompany;
@property (assign, nonatomic) int Follow;


#pragma mark - 功能

- (void)refreshModel:(NSDictionary *)infoDic;

- (void)changeAttentionStatus:(BOOL)status count:(NSInteger)count;

@end

@interface UserDataManager : NSObject

@property (nonatomic,strong, readonly) UserDataModel *userModel;

@property (nonatomic,strong, readonly) NSArray *AskArr;
@property (nonatomic,strong, readonly) NSArray *AnswerArr;
@property (nonatomic,strong, readonly) NSArray *LikeArr;
@property (nonatomic,strong, readonly) NSArray *FollowArr;

/**
 单例初始化
 
 @return 单例对象
 */
+ (instancetype)shareInstance;

- (void)loginSetUpModel:(UserDataModel *)model;

/**
 登录
 
 @param account 账户
 @param password 密码
 @param complatedBlock 登录结果回调
 @param networkErrorBlock 网络错误回调
 */
- (void)signInWithAccount:(NSString *)account password:(NSString *)password complated:(void (^)(BOOL isSignInSuccess, NSString *message))complatedBlock networkError:(void (^)(NSError *error))networkErrorBlock;


typedef void (^BindPushTokenComplatedBlock)(BOOL isSuccess);    //绑定用户推送结果回调
typedef void (^UnbindPushTokenComplatedBlock)(BOOL isSuccess);  //解除绑定用户推送结果回调

/**
 绑定用户推送

 @param complatedBlock 结果回调
 */
- (void)bindPushToken:(BindPushTokenComplatedBlock)complatedBlock;

/**
 解除绑定用户推送

 @param complatedBlock 结果回调
 */
- (void)unbindPushToken:(UnbindPushTokenComplatedBlock)complatedBlock;

/**
 获取我的提问列表

 @param page 当前要获取的页数
 @param finishBlock 获取结果回调
 @param failBlock 网络错误回调
 */
- (void )getAskWithpage:(NSInteger)page finish:(void(^)(NSArray *dataArr, BOOL isEnd))finishBlock fail:(void (^)(NSError *error))failBlock;

/**
 获取我的回答列表
 
 @param page 当前要获取的页数
 @param finishBlock 获取结果回调
 @param failBlock 网络错误回调
 */
- (void )getAnswerWithpage:(NSInteger)page finish:(void(^)(NSArray *dataArr, BOOL isEnd))finishBlock fail:(void (^)(NSError *error))failBlock;

/**
 获取我的关注列表
 
 @param page 当前要获取的页数
 @param finishBlock 获取结果回调
 @param failBlock 网络错误回调
 */
- (void )getFollowWithpage:(NSInteger)page finish:(void(^)(NSArray *dataArr, BOOL isEnd))finishBlock fail:(void (^)(NSError *error))failBlock;

/**
 获取我的成就列表
 
 @param page 当前要获取的页数
 @param finishBlock 获取结果回调
 @param failBlock 网络错误回调
 */
- (void )getLikeWithpage:(NSInteger)page finish:(void(^)(NSArray *dataArr, BOOL isEnd))finishBlock fail:(void (^)(NSError *error))failBlock;

@end
