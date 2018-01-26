//
//  AnswerOrLikeModel.h
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

typedef enum : NSUInteger {
    ContentType_Comm,
    ContentType_Like,
    ContentType_FollowComm,
} ContentType;

#import <Foundation/Foundation.h>

@interface AnswerOrLikeModel : NSObject

/**
 问题
 */
@property (nonatomic,strong)NSString *AorL_questionTitle;


/**
 回复人／点赞人 昵称
 */
@property (nonatomic,strong)NSString *AorL_Nick;

/**
 回复人／点赞人 头像
 */
@property (nonatomic,strong)NSString *AorL_Head;

/**
 回复人／点赞人 回复内容
 */
@property (nonatomic,strong)NSString *AorL_AnswerContent;

/**
 回复日期
 */
@property (nonatomic,strong)NSString *AorL_AnswerDate;

/**
  模型：回复／点赞
 */
@property (nonatomic,assign)ContentType AorL_Type;


/**
 模型：个人／企业
 */
@property (nonatomic,assign)BOOL AorL_isPerson;


@end
