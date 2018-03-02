//
//  FMDBManager.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/5.
//  Copyright © 2018年 law. All rights reserved.
//

#import "FMDBManager.h"

static FMDBManager *MyManager = nil;

@interface FMDBManager()
@property (strong, nonatomic)NSString *FileName;
@property (strong, nonatomic)FMDatabase *DataBase;
@property(strong,nonatomic)NSRecursiveLock* threadLock;
@property(unsafe_unretained,nonatomic)FMDatabase* usingdb;
@property(strong,nonatomic)FMDatabaseQueue* bindingQueue;

@end

@implementation FMDBManager

+(instancetype)sharedInstance{
    
    if (!MyManager) {
        
        MyManager = [[FMDBManager alloc] init];
        MyManager.threadLock = [[NSRecursiveLock alloc]init];
        
    }
  
    [MyManager.bindingQueue close];
    MyManager.bindingQueue = [[FMDatabaseQueue alloc]initWithPath:[UtilsCommon getPathForDocuments:MyManager.FileName inDir:@""]];
    
    return MyManager;
}

-(BOOL)creatTableWithName:(NSString *)dbName path:(NSArray *)arr{
    if (dbName.length > 0) {
        if ([dbName hasSuffix:@".sqlite"]) {
            self.FileName = dbName;
        }else{
            self.FileName = [dbName stringByAppendingString:@".sqlite"];
        }
    }
    
    if ([self openOrCreateDB]) {
        // 初始化数据表
        
        __block NSString *Sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' integer PRIMARY KEY AUTOINCREMENT ",dbName];
        
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                Sql = [Sql stringByAppendingString:[NSString stringWithFormat:@",%@ text NOT NULL",obj]];
            }
        }];
         Sql = [Sql stringByAppendingString:@")"];
        
        
        [_DataBase executeUpdate:Sql];
        return YES;
       
    }else return NO;
  
}

-(void)insertCOLUMNdocumentPathStringByAppendingPathComponent:(NSString *)Component DBName:(NSString *)dbName columnExists:(NSString *)columnExists Type:(NSString *)type InClass:(__unsafe_unretained Class)modelClass WithClassName:(NSString *)className{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dbpath = [[documentPath stringByAppendingPathComponent:Component] stringByAppendingPathComponent:dbName];
    FMDatabase * db = [FMDatabase databaseWithPath:dbpath];
    
    if ([db open]) {
        //判断字段是否存在
        if (![db columnExists:columnExists inTableWithName:[modelClass getTableName]]) {
            
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",className,columnExists,type];
            //例如 [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ text",@"newRecordThing",@"EventMange"];
            BOOL ret = [db executeUpdate:sql];
            if (ret  != YES) {
                NSLog(@"add albumName fail");
            }
        }
        [db close];
    }
    
}

#pragma mark - 插入
- (BOOL)insertToDB:(id)model
{
    if ([model isKindOfClass:[DraftsModel class]]) {
        //草稿
        DraftsModel *modal = (DraftsModel *)model;
        
        if ([self openOrCreateDB]) {
            //不存在数据库中，执行插入操作
            BOOL result = [self.DataBase executeUpdateWithFormat:@"insert into Drafts(title,content,Type,anonymous,UserId) values(%@,%@,%ld,%@,%@)",modal.title,modal.content,modal.Type,modal.anonymous,modal.UserId];
            
            return result;
        }
        return NO;
    }else return NO;
}

#pragma mark - 更新
- (BOOL)UpdateToDB:(id)model Where:(NSString *)where{
    NSLog(@"%s", __func__);
    
    
    if ([self openOrCreateDB]) {
        if ([model isKindOfClass:[DraftsModel class]]) {
            DraftsModel *modal = model;
            
            NSString* updateString = [NSString stringWithFormat:@"update Drafts set title = '%@',content = '%@',Type = '%ld',anonymous = '%@',UserId = '%@' %@",modal.title,modal.content,modal.Type,modal.anonymous,modal.UserId,where];
            BOOL res = [self.DataBase executeUpdate:updateString];
            
            if (!res) {
                NSLog(@"error to UPDATE data");
            } else {
                NSLog(@"success to UPDATE data"); 
            }
            [self.DataBase close];
        }
        
        return YES;
    }
    return NO;
}



-(NSString *)DBPath{
    if (self.FileName) {
        NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                               lastObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.FileName]];
        return savePath;
    }else{
        return @"";
    }
}

-(FMDatabase *)DataBase{
    if (!_DataBase) {
        _DataBase = [FMDatabase databaseWithPath:[self DBPath]];
    }return _DataBase;
}

-(BOOL)openOrCreateDB{
    if ([self.DataBase open]) {
        NSLog(@"数据库打开成功");
        return YES;
    }else{
        NSLog(@"打开数据库失败");
        return NO;
    }
}

-(void)closeDB{
    BOOL isClose = [self.DataBase close];
    if (isClose) {
        NSLog(@"关闭成功");
    }else{
        NSLog(@"关闭失败");
    }
}


-(NSArray *)ArrWithSqlDB:(Class)model Where:(NSString *)where orderBy:(NSString *)orderBy offset:(int)offset{
    
    BOOL isOpen = [self openOrCreateDB];
    if (isOpen) {
        NSLog(@"打开数据库成功");
        
        
        NSMutableString* st = [NSMutableString stringWithFormat:@"select rowid,* from %@ where %@ %@",[model getTableName],where,orderBy];
        
        FMResultSet *resulut = [self.DataBase executeQuery:st];
        NSMutableArray *Arr = [NSMutableArray array];
        
        while ([resulut next]) {
            
            NSDictionary *dic =[resulut resultDictionary];
            
            if ([[model class]isEqual:[DraftsModel class]]) {
                
                DraftsModel *modal = [[DraftsModel alloc]init];
                modal.Type = [[dic valueForKey:@"Type"]integerValue];
                modal.content = [dic valueForKey:@"content"];
                modal.title = [dic valueForKey:@"title"];
                modal.Id = [dic valueForKey:@"id"];
                modal.anonymous = [dic valueForKey:@"anonymous"];
                [Arr addObject:modal];
                
            }else [Arr addObject:dic];
        }
        
        [resulut close];
        [self closeDB];
        return Arr;
        
    }else{
        NSLog(@"打开数据库失败");
        return nil;
    }
}

-(BOOL)DeleteWithSqlDB:(Class)model Where:(NSString *)where{
    
    NSMutableString* deleteSQL = [NSMutableString stringWithFormat:@"delete from %@ %@",[model getTableName],where];
    
    BOOL isOpen = [self openOrCreateDB];
    if (isOpen) {
        BOOL res = [self.DataBase executeUpdate:deleteSQL];
        if (!res) {
            NSLog(@"error to delete db data");
        } else {
            NSLog(@"success to delete db data");
            
        }
        
        [self closeDB]; 
        return res;
        
    }return NO;
   
}

#pragma mark Tabel Structure Function 表结构
+(NSString *)getTableName
{
    return nil;
}

 

#pragma mark- core
-(void)executeDB:(void (^)(FMDatabase *db))block
{
    [_threadLock lock];
    if(self.usingdb != nil)
    {
        block(self.usingdb);
    }
    else
    {
        [_bindingQueue inDatabase:^(FMDatabase *db) {
            self.usingdb = db;
            block(db);
            self.usingdb = nil;
        }];
    }
    [_threadLock unlock];
}
#pragma mark- dealloc
-(void)dealloc
{
    
    [self.bindingQueue close];
    self.usingdb = nil;
    self.bindingQueue = nil;
    self.FileName = nil;
    self.threadLock = nil;
}
@end
