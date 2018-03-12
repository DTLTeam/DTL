//
//  AskHttpLink.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#define CONTECTTIME  20  // 联网时间
#define UploadImageBoundary @"KhTmLbOuNdArY0001"

#import "AskHttpLink.h"

#import "GTMBase64.h"
#import "NSData+CommonFeatures.h"

static unsigned char kRequestKey[] = {0x31, 0x32, 0x33, 0x26, 0x26, 0x40, 0x23, 0x21, 0x31, 0x32, 0x33, 0x31, 0x32, 0x33, 0x34, 0x30};

@interface AskHttpLink() <NSURLSessionDelegate>

@property (nonatomic,assign)int maskCount;

@end

@implementation AskHttpLink


static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}


#pragma mark - 数据加解密

#pragma mark 加密请求内容
+ (NSData *)requestInfoEncryption:(NSDictionary *)infoDic {
    
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic options:NSJSONWritingPrettyPrinted error:&err];
    
    if (err) {
        return [NSData data];
    } else {
        
        NSMutableString *jsonString = [NSMutableString stringWithString:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        jsonString = [NSMutableString stringWithString:[jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        jsonString = [NSMutableString stringWithString:[jsonString stringByReplacingOccurrencesOfString:@" " withString:@""]];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        //返回加密后的字符串
        jsonData = [jsonData AES128EncryptWithKey:[NSString stringWithFormat:@"%s", kRequestKey]];
        jsonData = [GTMBase64 encodeData:jsonData]; //base64加密
        
        return jsonData;
        
    }
    
}

#pragma mark 解密请求结果
+ (NSDictionary *)requestInfoDecryption:(NSData *)data {
    
    NSData *responseData = [GTMBase64 decodeData:data]; //base64解密
    NSString *jsonString = (NSString *)[responseData AES128DecryptWithKey:[NSString stringWithFormat:@"%s", kRequestKey]];
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        return nil;
    }
    
    return dic;
    
}


#pragma mark - 网络请求

#pragma mark GET请求
- (NSURLSessionDataTask *)get:(NSString *)urlString
                        param:(NSDictionary *)param
                     backData:(NetSessionResponseType)backData
                      success:(SuccessBlock)successBlock
                  requestHead:(RequestHeadBlock)requestHeadBlock
                        faile:(FaileBlock)faileBlock {
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONTECTTIME];
    
    request.HTTPMethod = @"GET";
    
    NSData *infoData = [AskHttpLink requestInfoEncryption:param];
    [request setValue:[NSString stringWithFormat:@"%lu", [infoData length]] forHTTPHeaderField:@"Content-Length"]; //设置数据长度
    [request setHTTPBody:infoData];
    
    //根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [self startNSURLSessionDataTask:request responType:backData success:successBlock headfiles:requestHeadBlock fail:faileBlock];
    
    return dataTask;
    
}

#pragma mark POST请求
- (NSURLSessionDataTask *)post:(NSString *)urlString bodyparam:(NSDictionary *)param backData:(NetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONTECTTIME];
    
    request.HTTPMethod = @"POST";
    
    NSData *infoData = [AskHttpLink requestInfoEncryption:param];
    [request setValue:[NSString stringWithFormat:@"%lu", [infoData length]] forHTTPHeaderField:@"Content-Length"]; //设置数据长度
    [request setHTTPBody:infoData];
    
    //6.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [self startNSURLSessionDataTask:request responType:backData success:successBlock headfiles:requestHeadBlock fail:faileBlock];
    
    return dataTask;
    
}

#pragma mark 根据会话对象发送请求
- (NSURLSessionDataTask *)startNSURLSessionDataTask:(NSMutableURLRequest *)request responType:(NetSessionResponseType)responType success:(SuccessBlock)respone headfiles:(RequestHeadBlock)headfiles fail:(FaileBlock)fail{
    
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error) {
        
        NSDictionary *responseDic = [AskHttpLink requestInfoDecryption:data];
        
        if (data.length == 0 || !responseDic) {
            if (fail) {
                fail(error);
            }
            return;
        }
        
        NSHTTPURLResponse * da = (NSHTTPURLResponse *)response;
        NSDictionary *allheadsFiles = da.allHeaderFields;
        
        //解析数据
        if (!error) { //请求成功
            
            if (responType == NetSessionResponseTypeJSON) { //返回字典
                
                if (response) {
                    respone(responseDic);
                }
                
            } else { //返回二进制
                
                if (response) {
                    respone(data);
                }
                
            }
            
        } else { //请求失败
            
            if (fail) {
                fail(error);
            }
            
        }
        
        if (response && headfiles) {
            headfiles(allheadsFiles);
        }
        
    }];
    
    //7.执行任务
    [dataTask resume];
    
    return dataTask;
    
}



#pragma mark - 把字典拼成字符串

- (NSString *) nsdictionaryToNSStting:(NSDictionary *)param{
    
    NSMutableString *string = [NSMutableString string];
    
    //便利字典把键值平起来
    [param enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        [string appendFormat:@"%@:",key];
        [string appendFormat:@"%@",obj];
        [string appendFormat:@"%@",@"&"];
    }];
    // 去掉最后一个&
    NSRange rangeLast = [string rangeOfString:@"&"options:NSBackwardsSearch];
    if (rangeLast.length !=0) {
        [string deleteCharactersInRange:rangeLast];
    }
//    NSLog(@"string:%@",string);
    NSRange range =NSMakeRange(0, [string length]);
    [string replaceOccurrencesOfString:@":"withString:@"="options:NSCaseInsensitiveSearch range:range];
//    NSLog(@"string:%@",string);
    
    return string;
}


// 如果URL有中文，转换成百分号
- (NSString *)urlConversionFromOriginalURL:(NSString *)originalURL {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        return [originalURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];// iOS 9.0以下
    }
    return [originalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSURLRequest *)POSTImage:(NSString *)URLString data:(NSData *)imageData name:(NSString*)name finish:(SuccessBlock)finish{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:30];
    
    NSString* headerString = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@",UploadImageBoundary];
    [request setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* requestMutableData = [NSMutableData data];
    NSMutableString* myString = [NSMutableString stringWithFormat:@"--%@\r\n",UploadImageBoundary];
    [myString appendString:@"Content-Disposition: form-data; name=\"cmd\"\r\n\r\n"];/*这里要打两个回车*/
    [myString appendString:@"uploadHeadicon"];
    [myString appendString:[NSString stringWithFormat:@"\r\n--%@\r\n",UploadImageBoundary]];
    [myString appendString:@"Content-Disposition: form-data; name=\"userID\"\r\n\r\n"];
    
    UserDataManager *userManagser = [UserDataManager shareInstance];
    [myString appendString:userManagser.userModel.userID];
    [myString appendString:[NSString stringWithFormat:@"\r\n--%@\r\n",UploadImageBoundary]];
    [myString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"headPic\"; filename=\"%@\"\r\n",name]];
    [myString appendString:@"Content-Type: image/jpeg\r\n\r\n"];
    /*转化为二进制数据*/
    [requestMutableData appendData:[myString dataUsingEncoding:NSUTF8StringEncoding]];
    /*文件数据部分，也是二进制*/
    [requestMutableData appendData:imageData];
    /*已--boundary结尾表明结束*/
    [requestMutableData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",UploadImageBoundary] dataUsingEncoding:NSUTF8StringEncoding] ];
    
    request.HTTPBody = requestMutableData;
    
    
    /*开始上传*/
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 30;
    NSURLSession* session  = [NSURLSession sessionWithConfiguration:sessionConfig
                                                           delegate:self
                                                      delegateQueue:nil];
    
    NSURLSessionDataTask * uploadtask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (finish) {
            finish(dictionary);
        }
    }];
    [uploadtask resume];
    return request;
}


#pragma mark - NSURLSessionDelegate

/* 收到身份验证 ssl */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition,NSURLCredential * _Nullable))completionHandler {
    
    // 1.判断服务器返回的证书类型,是否是服务器信任
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        /*  NSURLSessionAuthChallengeUseCredential = 0,                    使用证书
         NSURLSessionAuthChallengePerformDefaultHandling = 1,           忽略证书(默认的处理方式)
         NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,     忽略书证,并取消这次请求
         NSURLSessionAuthChallengeRejectProtectionSpace = 3,           拒绝当前这一次,下一次再询问
         */
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
        
    }
    
}
    
@end
