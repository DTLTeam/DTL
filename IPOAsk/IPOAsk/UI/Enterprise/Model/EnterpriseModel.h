//
//  EnterpriseModel.h
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

//Model
#import "QuestionModel.h"
#import "AnswerModel.h"

@interface EnterpriseModel : NSObject

@property (strong, nonatomic) NSString *enterpriseID;               
@property (strong, nonatomic) QuestionModel *questionMod;           //问题信息模型
@property (strong, nonatomic) NSArray<AnswerModel *> *answerItems;  //回复信息模型数组

- (void)refreshModel:(NSDictionary *)dic;

@end
