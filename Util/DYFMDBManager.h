//
//  DYFMDBManager.h
//  DYRunTime
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface DYFMDBManager : NSObject
/**
 *  单例：一个单一的SQLite数据库，用于执行SQL语句
 */
+ (FMDatabase *)defaultDatabase;
/**
 *  执行创建表;增删改 sql语句
 *
 *  @param sql sql语句
 *
 *  @return 是否执行成功
 */
+ (BOOL)executeUpdateWithSql:(NSString *)sql;
/**
 *  执行查询操作，具体实现在子类+ (NSArray *)resToList:(FMResultSet *)rs 方法中实现
 *
 *  @param sql sql查询语句
 *
 *  @return 查询结果
 */
//+ (NSArray *)executeQueryWithSql:(NSString *)sql;

+ (BOOL)saveLocations;

/**
 *  返回所有的数据
 */
+ (NSArray *)getAllListLocations;
@end
