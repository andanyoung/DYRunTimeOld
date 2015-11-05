//
//  DYLocationManager.m
//  DYRunTime
//
//  Created by tarena on 15/10/28.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "DYLocationManager.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件


static BMKLocationService *locationService;
@interface DYLocationManager ()<BMKLocationServiceDelegate>

@end

@implementation DYLocationManager
- (NSMutableArray *)locations{
    if (!_locations) {
        _locations = [NSMutableArray new];
    }
    return _locations;
}


+(DYLocationManager *)shareLocationManager{
//    //单例
    static DYLocationManager *manager = nil;
    static dispatch_once_t oneToke;
    dispatch_once(&oneToke, ^{
        manager = [DYLocationManager new];
    });
    return manager;
}

#pragma mark - BMKLocationServiceDelegate

- (void)didFailToLocateUserWithError:(NSError *)error{
    DDLogWarn(@" 定位失败 error %@",error);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation  {
   // NSLog(@"开始定位：");
    CLLocation *location = userLocation.location;
    
    // 如果此时位置更新的水平精准度大于10米，直接返回该方法
    // 可以用来简单判断GPS的信号强度
    //horizontalAccuracy:半径不确定性的中心点，以米为单位。 该地点的纬度和经度确定的圆的圆心，该值表示在该圆的半径。负值表示位置的经度和纬度是无效的。
 //   if (location.horizontalAccuracy<0||location.horizontalAccuracy>20.0) {
        
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//             [[[UIAlertView alloc]initWithTitle:@"提示,定位误差较大" message:@"亲，请再室外使用，并尽量避免高大的建筑物。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//        });
       
        
 //       return;
//    }
#warning test
    DDLogInfo(@"dingwei");
    
    if(self.locations.count>1){
        
        
        //计算本次定位数据与上一次定位之间的距离
        CGFloat distance = [location distanceFromLocation:[self.locations lastObject]];
        // (5.0米门限值，存储数组画线) 如果距离少于 5.0 米，则忽略本次数据直接返回方法
        if (distance < 5.0) {
            return;
        }
        _totalDistanc += distance;
        _timestamp = location.timestamp;
        _speed = location.speed;
    }
    [self.locations addObject:location];
    
    
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        //程序处于前台
        [self.delegate locationManage:self didUpdateLocations:self.locations];
    }
}

- (void)startUpdatingLocation{
    
#warning 先试着用全局变量保存，看是不是可以在后台一值运行
    if (locationService == nil) {
        locationService = [BMKLocationService new];
        locationService.delegate = self;
    }
    
    _timerNumber = 0;
    _totalDistanc = 0;
    _running = true;
    
    [locationService startUserLocationService];
    [self.delegate locationManage:self didChangeUpdateLocationState:_running];
}

- (void)stopUpdatingLocation{
    [locationService stopUserLocationService];
    locationService = nil;
    _running = false;
    [self.delegate locationManage:self didChangeUpdateLocationState:_running];
}

@end
