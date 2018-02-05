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
    _userName = @"用户名";
    _dateStr = @"2018-01-05";
    
    _title = @"标题1111111111111";
    _content = @"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容v";
    
    _lookNum = 999;
    _replyNum = 300;
    _attentionNum = 5000;
    
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
