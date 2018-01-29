//
//  AnswerModel.h
//  IPOAsk
//
//  答案模型
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject

@property (nonatomic, readonly) BOOL isLike;    //是否已经点赞

@property (strong, nonatomic, readonly) NSString *headImgUrlStr; //用户头像图片加载路径
@property (strong, nonatomic, readonly) NSString *userName;      //用户名
@property (strong, nonatomic, readonly) NSString *dateStr;       //创建时间

@property (strong, nonatomic, readonly) NSString *title;    //标题
@property (strong, nonatomic, readonly) NSString *content;  //内容

@property (nonatomic, readonly) NSInteger lookNum;  //查看数量
@property (nonatomic, readonly) NSInteger likeNum;  //点赞数量

/**
 刷新模型数据
 
 @param infoDic 数据字典
 */
- (void)refreshModel:(NSDictionary *)infoDic;

/**
 更改点赞状态
 
 @param status 点赞状态
 */
- (void)changeLikeStatus:(BOOL)status;

@end
