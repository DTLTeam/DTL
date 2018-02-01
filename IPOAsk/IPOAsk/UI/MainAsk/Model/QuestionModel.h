//
//  QuestionModel.h
//  IPOAsk
//
//  问题模型
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (nonatomic, readonly) BOOL isAttention;   //是否已经关注

@property (strong, nonatomic, readonly) NSString *headImgUrlStr; //用户头像图片加载路径
@property (strong, nonatomic, readonly) NSString *userName;      //用户名
@property (strong, nonatomic, readonly) NSString *dateStr;       //创建时间

@property (strong, nonatomic, readonly) NSString *title;    //标题
@property (strong, nonatomic, readonly) NSString *content;  //内容

@property (nonatomic, readonly) NSInteger lookNum;      //查看数量
@property (nonatomic, readonly) NSInteger replyNum;     //回复数量
@property (nonatomic, readonly) NSInteger attentionNum; //关注数量

/**
 刷新模型数据

 @param infoDic 数据字典
 */
- (void)refreshModel:(NSDictionary *)infoDic;

/**
 更改关注状态

 @param status 关注状态
 */
- (void)changeAttentionStatus:(BOOL)status;

@end