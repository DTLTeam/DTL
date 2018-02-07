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
        
        _questionID = @"";
        
        _headImgUrlStr = @"";
        _userName = @"";
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
    
    _isAttention = [infoDic[@"like"] boolValue];
    _isAnonymous = [infoDic[@"isAnonymous"] boolValue];
    
    _questionID = infoDic[@"id"];
    
    _headImgUrlStr = infoDic[@"headIcon"];
    _userName = infoDic[@"nickName"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[infoDic[@"addTime"] integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateStr = [formatter stringFromDate:date];
    
    _title = infoDic[@"title"];
    _content = infoDic[@"content"];
    
    _lookNum = [infoDic[@"isFollow"] integerValue];
    _replyNum = [infoDic[@"answer"] integerValue];
    _attentionNum = [infoDic[@"isLike"] integerValue];
    
}

- (void)changeAttentionStatus:(BOOL)status {
    
    if (_isAttention != status) {
        
        if (status) {
            _attentionNum++;
        } else {
            _attentionNum--;
        }
        
        _isAttention = status;
        
    }
    
}

@end
