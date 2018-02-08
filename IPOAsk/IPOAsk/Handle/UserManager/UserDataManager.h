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
@property (nonatomic, assign) int forbidden;

@end

/**
 关注数据模型
 */
@interface FollowDataModel : NSObject

@property (strong, nonatomic) NSString *askId;
@property (nonatomic, strong) NSString *nickName;
@property (strong, nonatomic) NSString *headIcon;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *addTime;
@property (assign, nonatomic) int view;
@property (assign, nonatomic) int like;
@property (assign, nonatomic) int answer;
@property (assign, nonatomic) int isAnswerer;
@property (assign, nonatomic) int isCompany;
@property (assign, nonatomic) int isFollow;
@property (nonatomic, assign) int isLike;

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
@property (assign, nonatomic) int view;
@property (assign, nonatomic) int like;
@property (assign, nonatomic) int answer;
@property (assign, nonatomic) int isAnswerer;
@property (assign, nonatomic) int isCompany;
@property (assign, nonatomic) int isFollow;
@property (nonatomic, assign) int isLike;

@end

/**
 回答数据模型
 */
@interface LikeDataModel : NSObject

@property (strong, nonatomic) NSString *askId;
@property (nonatomic, strong) NSString *nickName;
@property (strong, nonatomic) NSString *headIcon;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *addTime;
@property (assign, nonatomic) int view;
@property (assign, nonatomic) int like;
@property (assign, nonatomic) int answer;
@property (assign, nonatomic) int isAnswerer;
@property (assign, nonatomic) int isCompany;
@property (assign, nonatomic) int isFollow;
@property (nonatomic, assign) int isLike;

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

@end
