//
//  AskHttpLink.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#define CONTECTTIME  30  // 联网时间
#define UploadImageBoundary @"KhTmLbOuNdArY0001"

#import "AskHttpLink.h"


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

#pragma MARK-- GET

- (void)get:(NSString *)urlString param:(NSDictionary *)param backData:(NetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock{
    
    NSURL *url;
    
    
    NSString *string = [NSString string];
    if (param) {//带字典参数
        string = [self nsdictionaryToNSStting:param];
        
        //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
        url = [NSURL URLWithString:[self urlConversionFromOriginalURL:[NSString stringWithFormat:@"%@&%@",urlString,string]]];
    }else{
        //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
        url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    }
    
    //2. 创建请求对象内部默认了已经包含了请求头和请求方法(GET）的对象
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONTECTTIME];
    
    
    /*   设置请求头  */
    //    [request setValue:@"92b5787ecd17417b718a2aaedc7e6ce8" forHTTPHeaderField:@"apix-key"];
    
    //4. 根据会话对象创建一个task任务(发送请求）
    
    [self startNSURLSessionDataTask:request responType:backData success:successBlock headfiles:requestHeadBlock fail:faileBlock];
    
}




#pragma MARK-- POST

-(void)post:(NSString *)urlString bodyparam:(NSDictionary *)param backData:(NetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock{
    
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    
    
    //1.url
    NSURL *url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONTECTTIME];
    
    
    /*   设置请求头  */
    //    [request setValue:@"92b5787ecd17417b718a2aaedc7e6ce8" forHTTPHeaderField:@"apix-key"];
    
    
    
    //4.修改请求方法为POST
    request.HTTPMethod =@"POST";
    
    
    //有参数请求题
    if (param) {
        
        //5.设置请求体
        NSString *string = [self nsdictionaryToNSStting:param];
        request.HTTPBody = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    //6.根据会话对象创建一个Task(发送请求）
    [self startNSURLSessionDataTask:request responType:backData success:successBlock headfiles:requestHeadBlock fail:faileBlock];
    
    
}




#pragma MARK-- 根据会话对象创建一个Task(发送请求）

- (void)startNSURLSessionDataTask:(NSMutableURLRequest *)request responType:(NetSessionResponseType)responType success:(SuccessBlock)respone headfiles:(RequestHeadBlock)headfiles fail:(FaileBlock)fail{
     
    
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error) {
        
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (result.length == 0) {
            if (fail) {
                fail(error);
            }
            
            DLog(@"数据异常");
            return ;
        }
        
        // 解析服务器返回的数据(返回的数据为JSON格式，因此使用NSJNOSerialization进行反序列化)
        id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"response%@",response);
        NSHTTPURLResponse * da =(NSHTTPURLResponse *)response;
        NSDictionary *allheadsFiles = da.allHeaderFields;
//        NSLog(@"allheadsFiles:%@",allheadsFiles[@"Content-Type"]);
        
        //8.解析数据
        if (!error) {
            if (responType ==NetSessionResponseTypeJSON) {//返回JSON
                respone(dict);
            }else{
                respone(data);//返回二进制
            }
            
            
        }else{
            fail(error);
            DLog(@"网络请求失败");
        }
        
        if (response && headfiles) {
            headfiles(allheadsFiles);
        }
        
    }];
    
    //7.执行任务
    [dataTask resume];
}



#pragma MARK -- 把字典拼成字符串

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



#pragma mark NSURLSession Delegate
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
        completionHandler(NSURLSessionAuthChallengeUseCredential , card);
        
    }
    
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

    
@end
