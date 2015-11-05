//
//  BaseModel.h
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@interface BaseModel : NSObject
//单例模式，返回唯一的数据库对象
+ (FMDatabase *)defaultDatabase;

@end












