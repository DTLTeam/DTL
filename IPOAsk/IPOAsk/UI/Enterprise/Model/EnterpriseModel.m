//
//  EnterpriseModel.m
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseModel.h"

@implementation EnterpriseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _questionMod = [[QuestionModel alloc] init];
        _answerItems = [NSArray array];
    }
    return self;
}


#pragma mark - 功能

- (void)refreshModel:(NSDictionary *)dic {
    
    [_questionMod refreshModel:dic];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *answerDic in dic[@"answer"]) {
        
        AnswerModel *answerMod = [[AnswerModel alloc] init];
        [answerMod refreshModel:answerDic];
        
        [items addObject:answerMod];
        
    }
    _answerItems = items;
    
}

@end
