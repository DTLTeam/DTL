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
@property (strong, nonatomic) NSString *headIcon;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *isAnswerer;

@end



@interface UserDataManager : NSObject

@end
