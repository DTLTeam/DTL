//
//  AnswerOrLikeModel.h
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ContentType_Comm = 1,       //新回复
    ContentType_Like,           //新点赞
    ContentType_Follow,         //新关注
    ContentType_FollowComm      //关注的问题有新回复
} ContentType;

@interface AnswerOrLikeModel : NSObject

@property (strong, nonatomic) NSString *messageID;      //消息ID
@property (assign, nonatomic) NSInteger messageTime;    //消息时间戳
@property (strong, nonatomic) NSString *messageDate;    //消息日期

@property (strong, nonatomic) NSString *headImgUrl;     //头像路径
@property (strong, nonatomic) NSString *nick;           //昵称

@property (strong, nonatomic) NSString *questionID;     //问题ID
@property (strong, nonatomic) NSString *questionTitle;  //问题标题

@property (strong, nonatomic) NSString *answerID;       //回复ID

@property (assign, nonatomic) ContentType infoType;    //信息类型

- (void)refreshModel:(NSDictionary *)dic;

@end
