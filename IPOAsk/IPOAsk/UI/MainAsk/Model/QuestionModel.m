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
        
        _headImgUrlStr = @"";
        _userName = @"";
        
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
    
    //test
    _isAttention = (arc4random() % 2 == 0);
    
    _headImgUrlStr = @"";
    _userName = infoDic[@"userName"];
    _dateStr = infoDic[@"date"];
    
    _title = infoDic[@"title"];
    _content = infoDic[@"content"];
    
    _lookNum = [infoDic[@"lookNum"] intValue];
    _replyNum = [infoDic[@"replyNum"] intValue];
    _attentionNum = [infoDic[@"attentionNum"] intValue];
    
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
