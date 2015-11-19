//
//  WYRunNewsListNetWork.h
//  DYRunTime
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYRunNewsListModel.h"

@interface WYRunNewsListNetWork : NSObject
+ (id)Get:(NSString *)path  completeHandle:(void(^)(id model,NSError *error))complete;
@end
