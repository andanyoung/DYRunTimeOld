//
//  MapViewController.m
//  DYRunTime
//
//  Created by tarena on 15/10/15.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "DYLocationManager.h"

#define polylineWith 10.0
#define polylineColor [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:0.7]
#define mapViewZoomLevel 20



#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件//只引入所需的单个头文件
#import <BaiduMapAPI_Utils/BMKGeometry.h>



@interface MapViewController ()<BMKMapViewDelegate,DYLocationManagerDelegate>{
  //  BMKLocationService *_locaService;//由于系统原因，iOS不允许使用第三方定位，因此地图SDK中的定位方法，本质上是对原生定位的二次封装。
}

//百度地图View
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic)NSMutableArray *locations;
@property (nonatomic, strong) BMKPolyline *polyLine;
@property (nonatomic, strong) DYLocationManager *locationManager;

@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.locationManager.delegate = self;
    self.locationManager = appDelegate.locationManager;
    
    //初始化定位
    [self initLocation];
    
//    if (_locations.count>1) {
//        [self drawWalkPolyline:];
//    }
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _mapView.delegate = self;
    
    
    [self startLocation];
    [_mapView viewWillAppear];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _mapView.delegate = nil;//不用时，值nil。释放内存
    //_locaService.delegate = nil;  //后台定位不能为nil 要去数组中添加数组
}

#pragma mark -- 初始化定位
- (void)initLocation{
    
    //配置_mapView 去除蓝色精度框
    BMKLocationViewDisplayParam *displayParam = [BMKLocationViewDisplayParam new];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    //displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    _mapView.zoomLevel = 20;
    _mapView.showMapScaleBar = YES;

}

/** 开始定位 */
- (void)startLocation{
    
    //[_mapView setShowsUserLocation:YES];//开始定位
    [_locationManager startUpdatingLocation];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;// 定位罗盘模式
    _mapView.showsUserLocation = YES;//显示定位图层,开始定位
}



#pragma mark -- DYLocationManagerDelegate

- (void)locationManage:(DYLocationManager *)manager didUpdateLocations:(NSArray <CLLocation *>*)locations{
   // NSLog(@"delegate");
    CLLocation *location = [locations lastObject];
    
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    
    
    BMKUserLocation *userLocation = [BMKUserLocation new];
    [userLocation setValue:location forKey:@"location"];
    [userLocation setValue:@"YES" forKey:@"updating"];
    [_mapView updateLocationData:userLocation];
    
    [self drawWalkPolyline:locations];
    
    
}



#pragma mark -- 路径配置
/**
 *  绘制轨迹路线
 */
- (void)drawWalkPolyline:(NSArray *)locations{
    // 轨迹点数组个数
    NSUInteger count = locations.count;
    // 动态分配存储空间
    // BMKMapPoint是个结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
    BMKMapPoint *tempPoints = malloc(sizeof(CLLocationCoordinate2D) * count);
    // 遍历数组 ,将coordinate 转化为 BMKMapPoint
    [locations enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL * _Nonnull stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
    }];
    
    //移除原有的绘图，避免在原来轨迹上重画
    if (self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
    }
    
    //通过points构建BMKPolyline
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    //添加路线，绘图
    if(self.polyLine){
        [self.mapView addOverlay:self.polyLine];
    }
    // 清空 tempPoints 临时数组
    free(tempPoints);
    
    // 根据polyline设置地图范围
    //[self mapViewFitPolyLine:self.polyLine];
}


/**
 *  根据polyline设置地图范围
 *
 *  @param polyLine
 */
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self.mapView setVisibleMapRect:rect];
    self.mapView.zoomLevel = self.mapView.zoomLevel - 0.3;
}


// Override
#pragma mark - BMKMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:0.7];
        polylineView.lineWidth = polylineWith;
      
        return polylineView;
    }
    return nil;
}
- (void)didFailToLocateUserWithError:(NSError *)error{
    WCLog(@"error");
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    WCLog(@"start locate");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"内存警告" message:@"😢😢😢😢😢😢" delegate:self cancelButtonTitle:@"cancle" otherButtonTitles: nil];
    [alert show];
}
@end
