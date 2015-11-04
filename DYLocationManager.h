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

@property (nonatomic,strong) NSMutableArray *locations;
//@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong)id<DYLocationManagerDelegate> delegate;

/*  用于保存总表
 */
@property (nonatomic) NSInteger timerNumber;
@property (nonatomic) double totalDistanc;
@property (nonatomic,weak) NSDate *timestamp;

+ (DYLocationManager *)shareLocationManager;
/**
 * 开始定位
 */
- (void)startUpdatingLocation;

/**
 * 结束定位
 */
- (void)stopUpdatingLocation;
@end
