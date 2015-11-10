//
//  DYLocationManager.h
//  DYRunTime
//
//  Created by tarena on 15/10/28.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DYLocationManager,BMKLocationService,BMKUserLocation;

@protocol DYLocationManagerDelegate <NSObject>
/**
 *  当位置发生变化时调用
 */
- (void)locationManage:(DYLocationManager *)manager didUpdateLocations:(NSArray <CLLocation *>*)locations;

@optional
/**
 *  当定位状态发生变化时调用
 */
- (void)locationManage:(DYLocationManager *)manager didChangeUpdateLocationState:(BOOL)running;
@end


@interface DYLocationManager : NSObject

@property (nonatomic,strong) NSMutableArray<CLLocation *> *locations;
//@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, weak)id<DYLocationManagerDelegate> delegate;

/*  用于保存总记录
 */
//@property (nonatomic) NSInteger timerNumber;
@property (nonatomic) double totalDistanc;
//@property (nonatomic,weak) NSDate *timestamp;
@property (nonatomic) double speed;

@property (nonatomic) BOOL running;
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
