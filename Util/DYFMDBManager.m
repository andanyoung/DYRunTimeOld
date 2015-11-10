//
//  DYFMDBManager.m
//  DYRunTime
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "DYFMDBManager.h"
#import <FMDB/FMDB.h>
#import <CoreLocation/CoreLocation.h>
#import "DYLocationManager.h"
#import "DYRunRecord.h"

@implementation DYFMDBManager
+ (FMDatabase *)defaultDatabase{
    static FMDatabase *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //数据库对象初始化，需要数据库路径
        NSString *docPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        docPath=[docPath stringByAppendingPathComponent:@"sqlite.db"];
        /**
         *      1、当数据库文件不存在时，fmdb会自己创建一个。
         *      2、 如果你传入的参数是空串：@"" ，则fmdb会在临时文件目录下创建这个数据库，数据库断开连接时，数据库文件被删除。
         *      3、如果你传入的参数是 NULL，则它会建立一个在内存中的数据库，数据库断开连接时，数据库文件被删除。
         */
        db = [FMDatabase databaseWithPath:docPath];
        
        
        /**@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID,NAME,AGE,ADDRESS];
         */
        if([db open]){
            NSString *sqlCreateTable =  @"CREATE TABLE IF NOT EXISTS RecordTable (date TEXT, startTime text, endTime TEXT,totalDistanc TEXT,totalTime Text)";
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                DDLogError(@"error when creating db table");
            } else {
                DDLogInfo(@"success to creating db table");
            }
            [db close];
        }
        
    });
 
    return db;
}

+ (BOOL)executeUpdateWithSql:(NSString *)sql{
    FMDatabase *db = [self defaultDatabase];
    if ([db open]) {
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            DDLogError(@"error when executeUpdate db table with sql: %@",sql);
        } else {
            DDLogInfo(@"success to executeUpdate db table with sql: %@",sql);
        }
        [db close];
        return res;
    }
    
    return NO;
}

//+ (NSArray *)executeQueryWithSql:(NSString *)sql{
//    FMDatabase *db = [self defaultDatabase];
//    if ([db open]) {
//        FMResultSet *rs = [db executeQuery:sql];
//       // NSArray *arr = [self resToList:rs];
//        [db close];
//        return arr;
//    }
//    
//    return nil;
//}

+ (NSArray *)resToList:(FMResultSet *)rs{
    NSMutableArray *arr = [NSMutableArray new];

    NSString *date = nil;
    while ([rs next]) {
        DYRunRecord *record = [DYRunRecord new];
        record.date = [rs stringForColumn:@"date"];
        record.startTime = [rs stringForColumn:@"startTime"];
        record.endTime = [rs stringForColumn:@"endTime"];
        record.totalDistanc = [rs stringForColumn:@"totalDistanc"];
        record.totalTime = [rs stringForColumn:@"totalTime"];
        
        if ([record.date isEqualToString:date]) {
            NSMutableArray *dataArr = [arr lastObject];
            [dataArr addObject:record];
        }else{

            [arr addObject: [[NSMutableArray alloc]initWithObjects:record, nil]];
        }
        date = record.date;
  
    }
    
    return [arr copy];
}

+ (NSArray *)getAllListLocations{
    FMDatabase *db = [self defaultDatabase];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"select * from RecordTable ORDER BY date DESC"];
        NSArray *arr = [self resToList:rs];
        [db closeOpenResultSets];
        [db close];
        return arr;
    }
    
    return nil;
}

+ (BOOL)saveLocations{

    DYLocationManager *locationManage = [DYLocationManager shareLocationManager];
    NSArray<CLLocation *> *array = locationManage.locations;
    NSTimeInterval timeInterval = [[array lastObject].timestamp timeIntervalSinceDate:[array firstObject].timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    DYRunRecord *record = [DYRunRecord new];
    record.startTime = [dateFormatter stringFromDate: [array firstObject].timestamp];
    record.endTime = [dateFormatter stringFromDate: [array lastObject].timestamp];
    record.totalDistanc = [NSString stringWithFormat:@"%.2lf" ,locationManage.totalDistanc ];
    record.totalTime = [NSString stringWithFormat:@"%ld:%ld",(NSInteger)timeInterval/60,(NSInteger)timeInterval%60];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    record.date = [dateFormatter stringFromDate:[array firstObject].timestamp];
   
    if (record.date == nil) return false;
    return [DYFMDBManager executeUpdateWithSql: [NSString stringWithFormat: @"insert into RecordTable (date ,startTime ,endTime ,totalDistanc ,totalTime) values ('%@','%@','%@','%@','%@')",record.date,record.startTime,record.endTime,record.totalDistanc,record.totalTime]];
    
  
    
}


@end
