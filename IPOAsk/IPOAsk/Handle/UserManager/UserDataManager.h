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



@interface UserDataManager : NSObject

@property (nonatomic,strong, readonly) UserDataModel *userModel;

/**
 单例初始化
 
 @return 单例对象
 */
+ (instancetype)shareInstance;


- (void)loginSetUpModel:(UserDataModel *)model;

@end
