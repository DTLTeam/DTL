//
//  EnterpriseModel.h
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterpriseModel : NSObject


/**
 问题
 */
@property (nonatomic,strong)NSString *Exper_questionTitle;


/**
 专家昵称
 */
@property (nonatomic,strong)NSString *Exper_expertNick;

/**
 专家头像
 */
@property (nonatomic,strong)NSString *Exper_expertHead;

/**
 专家回复
 */
@property (nonatomic,strong)NSString *Exper_AnswerContent;

/**
 回复时间
 */
@property (nonatomic,strong)NSString *Exper_recoveryDate;

/**
 是否点赞
 */
@property (nonatomic,assign)BOOL Exper_haveLike;

@end
