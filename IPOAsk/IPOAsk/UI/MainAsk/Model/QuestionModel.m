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
