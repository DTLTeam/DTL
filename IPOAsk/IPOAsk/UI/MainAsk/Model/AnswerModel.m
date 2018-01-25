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
        
        _isLike = NO;
        
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
