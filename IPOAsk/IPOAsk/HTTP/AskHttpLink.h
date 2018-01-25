//
//  AskHttpLink.h
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SuccessBlock)(id response);                                 // 成功返回的数据
typedef void(^RequestHeadBlock)(id response);                            // 请求头返回的数据
typedef void(^FaileBlock)(NSError * error);                             // 请求错误返回的数据



typedef NS_ENUM(NSUInteger,NetSessionResponseType){
    NetSessionResponseTypeDATA    =  0,                // 返回后台是什么就是什么DATA
    NetSessionResponseTypeJSON    =  1                // 返会序列化后的JSON数据
};



@interface AskHttpLink : NSObject

//单利
+ (instancetype) shareInstance; 


/**GET短数据请求
 * urlString          网址
 * param              参数
 * backData           返回的数据是NSDATA还是JSON
 * successBlock       成功数据的block
 * faileBlock         失败的block
 * requestHeadBlock   请求头的数据的block
 */
- (void)get:(NSString *)urlString param:(NSDictionary *)param backData:(NetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock;


/**POST短数据请求
 * urlString           网址
 * param               参数
 * backData            返回的数据是NSDATA还是JSON
 * successBlock        成功数据的block
 * faileBlock          失败的block
 * requestHeadBlock    请求头的数据的block
 */

-(void)post:(NSString *)urlString bodyparam:(NSDictionary *)param backData:(NetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock;
 
//

@end
