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

/**
 单例

 @return 单例对象
 */
+ (instancetype) shareInstance;

/**
 GET短数据请求

 @param urlString           网址
 @param param               参数
 @param backData            返回的数据是NSDATA还是JSON
 @param successBlock        成功数据的block
 @param requestHeadBlock    请求头的数据的block
 @param faileBlock          失败的block
 @return                    请求管理器
 */
- (NSURLSessionDataTask *)get:(NSString *)urlString
                        param:(NSDictionary *)param
                     backData:(NetSessionResponseType)backData
                      success:(SuccessBlock)successBlock
                  requestHead:(RequestHeadBlock)requestHeadBlock
                        faile:(FaileBlock)faileBlock;

/**
 POST短数据请求
 
 @param urlString           网址
 @param param               参数
 @param backData            返回的数据是NSDATA还是JSON
 @param successBlock        成功数据的block
 @param requestHeadBlock    请求头的数据的block
 @param faileBlock          失败的block
 @return                    请求管理器
 */
- (NSURLSessionDataTask *)post:(NSString *)urlString
                     bodyparam:(NSDictionary *)param
                      backData:(NetSessionResponseType)backData
                       success:(SuccessBlock)successBlock
                   requestHead:(RequestHeadBlock)requestHeadBlock
                         faile:(FaileBlock)faileBlock;
 
//
- (NSURLRequest *)POSTImage:(NSString *)URLString data:(NSData *)imageData name:(NSString*)name finish:(SuccessBlock)finish;

@end
