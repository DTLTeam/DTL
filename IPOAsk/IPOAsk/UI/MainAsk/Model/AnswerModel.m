//
//  AnswerModel.m
//  IPOAsk
//
//  答案模型
//

#import "AnswerModel.h"

@implementation AnswerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _isAnonymous = NO;
        _isLike = NO;
        
        _questionID = @"";
        _answerID = @"";
        
        _headImgUrlStr = @"";
        _userName = @"";
        _dateStr = @"";
        
        _title = @"";
        _content = @"";
        
        _lookNum = 0;
        _likeNum = 0;
        
    }
    return self;
}


#pragma mark - 功能

#pragma mark 刷新模型数据
- (void)refreshModel:(NSDictionary *)infoDic {
    
    if (!infoDic) {
        return;
    }
    
    id content;
    
    content = infoDic[@"isAnonymous"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _isAnonymous = [content boolValue];
    }
    content = infoDic[@"isLike"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _isLike = [content boolValue];
    }
    
    content = infoDic[@"id"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _questionID = content;
    }
    content = infoDic[@"answerUID"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _answerID = content;
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
    if (content && ![content isKindOfClass:[NSNull class]]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[content integerValue]];
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
    content = infoDic[@"like"];
    if (content && ![content isKindOfClass:[NSNull class]]) {
        _likeNum = [content integerValue];
    }
    
}

#pragma mark 更改点赞状态
- (void)changeLikeStatus:(BOOL)status {
    
    if (_isLike != status) {
        
        if (status) {
            _likeNum++;
        } else {
            _likeNum--;
        }
        
        _isLike = status;
        
    }
    
}

@end
