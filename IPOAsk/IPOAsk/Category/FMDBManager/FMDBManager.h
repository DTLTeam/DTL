//
//  FMDBManager.h
//  IPOAsk
//
//  Created by adminMac on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftsModel.h"
 

typedef void(^getAllData)(NSArray *dataArr);

@interface FMDBManager : NSObject

+(instancetype)sharedInstance;

-(void)insertCOLUMNdocumentPathStringByAppendingPathComponent:(NSString *)Component DBName:(NSString *)dbName columnExists:(NSString *)columnExists Type:(NSString *)type InClass:(__unsafe_unretained Class)modelClass WithClassName:(NSString *)className;

-(BOOL)creatTableWithName:(NSString *)dbName path:(NSArray *)arr;

- (BOOL)insertToDB:(id )model;

- (BOOL)UpdateToDB:(id)model Where:(NSString *)where;

-(BOOL)DeleteWithSqlDB:(Class )model Where:(NSString *)where;


-(NSArray *)ArrWithSqlDB:(Class )model Where:(NSString *)where orderBy:(NSString *)orderBy offset:(int)offset;


@end
