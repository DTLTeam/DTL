//
//  DraftsModel.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraftsModel : NSObject

@property (strong, nonatomic) NSString *title;    //标题
@property (strong, nonatomic) NSString *content;  //内容
@property (assign, nonatomic) NSInteger Type;     //草稿类型 个人回答 个人提问 企业提问
@property(nonatomic,strong)   NSString *Id;
@property(nonatomic,strong)   NSString *anonymous; //匿名

@property(nonatomic,strong)   NSString *UserId;     //

@end
