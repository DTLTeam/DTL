//
//  DraftsModel.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import "DraftsModel.h"

@implementation DraftsModel

#pragma mark 表名
+ (NSString *)getTableName
{
    return @"Drafts";
}

#pragma makr 主键
+ (NSString *)getPrimaryKey
{
    return @"id";
}

@end
