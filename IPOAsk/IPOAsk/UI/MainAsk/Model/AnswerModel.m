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
     
    
    _headImgUrlStr = @"";
    _userName = @"用户名";
    _dateStr = @"2018-01-05";
    
    _title = @"标题1111111111111";
    _content = @"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容v";
    
    _lookNum = 999;
    _likeNum = 22;
    
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
