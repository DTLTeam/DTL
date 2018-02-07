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
    
    _isAnonymous = [infoDic[@"isAnonymous"] boolValue];
//    _isLike = [infoDic[@"like"] boolValue];
    
    _questionID = infoDic[@"id"];
    _answerID = infoDic[@"answerUID"];
    
    _headImgUrlStr = infoDic[@"headIcon"];
    _userName = infoDic[@"nickName"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[infoDic[@"addTime"] integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateStr = [formatter stringFromDate:date];
    
    _title = infoDic[@"title"];
    _content = infoDic[@"content"];
    
    _lookNum = [infoDic[@"isFollow"] integerValue];
    _likeNum = [infoDic[@"isLike"] integerValue];
    
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
