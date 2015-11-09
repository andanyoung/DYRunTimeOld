//
//  DYRunRecord.h
//  DYRunTime
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYRunRecord : NSObject
//date TEXT, startTime text, endTime TEXT,totalDistanc TEXT,totalTime Text
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *totalDistanc;
@property (nonatomic, strong) NSString *totalTime;

@end
