//
//  BaseModel.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseModel.h"
#import <FMDB/FMDB.h>

@implementation BaseModel

//MJCodingImplementation

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
    });
//在使用对象之前，要打开数据库。
    [db open];
    return db;
}
@end












