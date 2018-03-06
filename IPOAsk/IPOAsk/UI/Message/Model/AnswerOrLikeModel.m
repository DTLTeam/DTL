//
//  AnswerOrLikeModel.m
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "AnswerOrLikeModel.h"

@implementation AnswerOrLikeModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.messageID = @"";
        self.messageTime = 0;
        self.messageDate = @"";
        
        self.headImgUrl = @"";
        self.nick = @"";
        
        self.questionID = @"";
        self.questionTitle = @"";
        
        self.answerID = @"";
        
        self.infoType = 0;
        
    }
    return self;
}


#pragma mark - 功能

- (void)refreshModel:(NSDictionary *)dic {
    
    _messageID = dic[@"id"] ? [dic[@"id"] stringValue] : @"";
    _messageTime = [dic[@"addTime"] integerValue];
    
    if (_messageTime > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _messageDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_messageTime]];
    } else {
        _messageDate = @"";
    }
    
    _headImgUrl = dic[@"headIcon"] ? dic[@"headIcon"] : @"";
    _nick = dic[@"nickName"] ? dic[@"nickName"] : @"";
    
    _questionID = dic[@"questionID"] ? [dic[@"questionID"] stringValue] : @"";
    _questionTitle = dic[@"question"] ? dic[@"question"] : @"";
    
    _answerID = dic[@"answerID"] ? [dic[@"answerID"] stringValue] : @"";
    
    _infoType = dic[@"type"] ? [dic[@"type"] intValue] : 0;
    
}

@end
