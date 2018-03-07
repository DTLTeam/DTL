//
//  QuestionModel.m
//  IPOAsk
//
//  问题模型
//

#import "QuestionModel.h"

@implementation QuestionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _isAttention = NO;
        _isAnonymous = NO;
        _isFromMyself = NO;
        
        _questionID = @"";
        
        _headImgUrlStr = @"";
        _userName = @"";
        _dateTime = 0;
        _dateStr = @"";
        
        _title = @"";
        _content = @"";
        
        _lookNum = 0;
        _replyNum = 0;
        _attentionNum = 0;
        
    }
    return self;
}


#pragma mark - 功能

- (void)refreshModel:(NSDictionary *)infoDic {
    
    if (!infoDic) {
        return;
    }
    
    id content;
    
    content = infoDic[@"isAnonymous"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _isAnonymous = [content boolValue];
    }
    content = infoDic[@"isFollow"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _isAttention = [content boolValue];
    }
    content = infoDic[@"isFromMySelf"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _isFromMyself = [content boolValue];
    }
    
    content = infoDic[@"qid"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        if ([content isKindOfClass:[NSNumber class]]) {
            content = [content stringValue];
        }
        _questionID = content;
    } else {
        content = infoDic[@"id"];
        if (content && ![content isKindOfClass:[NSNull class]]) {
            if ([content isKindOfClass:[NSNumber class]]) {
                content = [content stringValue];
            }
            _questionID = content;
        }
    }
    
    content = infoDic[@"headIcon"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _headImgUrlStr = content;
    }
    content = infoDic[@"nickName"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _userName = content;
    }
    
    content = infoDic[@"addTime"];
    if (content && [content isKindOfClass:[NSNull class]]) {
        
        _dateTime = [content integerValue];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_dateTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _dateStr = [formatter stringFromDate:date];
        
    }
    
    content = infoDic[@"title"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _title = content;
    }
    content = infoDic[@"content"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _content = content;
    }
    
    content = infoDic[@"view"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _lookNum = [content integerValue];
    }
    content = infoDic[@"answer"];
    if (content && ![content isKindOfClass:[NSNull class]] && [content isKindOfClass:[NSNumber class]]) {
        _replyNum = [content integerValue];
    }
    content = infoDic[@"follow"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _attentionNum = [content integerValue];
    }
    
}

- (void)changeAttentionStatus:(BOOL)status count:(NSInteger)count {
    
    _isAttention = status;
    _attentionNum = count;
    
}

@end
