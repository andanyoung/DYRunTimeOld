//
//  DYLocationManager.h
//  DYRunTime
//
//  Created by tarena on 15/10/28.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYLocationManager,CLLocation,BMKLocationService,BMKUserLocation;

@protocol DYLocationManagerDelegate <NSObject>
/**
 *  当位置发生变化时调用
 */
- (void)locationManage:(DYLocationManager *)manager didUpdateLocations:(NSArray <BMKUserLocation *>*)locations;

@end
@interface DYLocationManager : NSObject
/**
 *  用于保存总表
 */
@property (nonatomic,strong) NSMutableArray *locations;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong)id<DYLocationManagerDelegate> delegate;
@property (nonatomic) NSInteger timerNumber;
@property (nonatomic) double totalDistanc;

+ (DYLocationManager *)shareLocationManager;
/**
 * 开始定位
 */
- (void)startUpdatingLocation;
@end
