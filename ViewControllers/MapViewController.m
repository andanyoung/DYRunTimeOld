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
#import "DYRunRecord.h"
#import "DYFMDBManager.h"
#import "DYMainViewController.h"
#import "MobClick.h"

#define polylineWidth 10.0
#define polylineColor [[UIColor greenColor] colorWithAlphaComponent:1]
#define mapViewZoomLevel 20
#define removeObjectsLen 20


#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件//只引入所需的单个头文件
#import <BaiduMapAPI_Utils/BMKGeometry.h>



@interface MapViewController ()<BMKMapViewDelegate,DYLocationManagerDelegate,UIPreviewActionItem>{
  //  BMKLocationService *_locaService;//由于系统原因，iOS不允许使用第三方定位，因此地图SDK中的定位方法，本质上是对原生定位的二次封装。
}

//百度地图View
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic, strong) BMKPolyline *polyLine;
@property (nonatomic, strong) DYLocationManager *locationManager;
@property (nonatomic, strong) BMKPointAnnotation *startPoint;

@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showProgress];
    if (_type != MapViewTypeQueryDetail) {
        //初始化定位
        [self initLocation];
        
        [self startLocation];
    }
   
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _mapView.delegate = self;
    
    [_mapView viewWillAppear];
   
    _locationManager.delegate = self;
    //peek 、Pop多会调用此方法，所以初始化轨迹应放这
    if (  _type != MapViewTypeLocation && _locations.count>1 ) {
        CLLocation *location = [_locations lastObject];
        
        //[_mapView setCenterCoordinate:location.coordinate animated:YES];
        //下行：设置默认的地图中心。按上行设置时，当直接改变zoomLevel，是中心会改变
        _mapView.centerCoordinate = location.coordinate;
        BMKUserLocation *userLocation = [BMKUserLocation new];
        [userLocation setValue:location forKey:@"location"];
        [userLocation setValue:@"YES" forKey:@"updating"];
        [_mapView updateLocationData:userLocation];
        [self drawWalkPolyline:_locations];
        
        [self mapViewFitPolyLine:_polyLine];
        
        if (_type == MapViewTypeQueryDetail){
            [self creatPointWithLocaiton:location title:@"终点"];
        }
    }

    [MobClick beginLogPageView:[NSString stringWithFormat:@"MapView_type_%ld",_type]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _mapView.delegate = nil;//不用时，值nil。释放内存
    
     [MobClick endLogPageView:[NSString stringWithFormat:@"MapView_type_%ld",_type]];
}



#pragma mark -- 初始化地图
- (void)initLocation{
    
    //配置_mapView 去除蓝色精度框
    if (_type != MapViewTypeLocation) {
        BMKLocationViewDisplayParam *displayParam = [BMKLocationViewDisplayParam new];
        displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
        displayParam.isAccuracyCircleShow = false;//精度圈是否显示
        displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
        displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
        displayParam.locationViewImgName = @"walk";//定位图标名称
        [_mapView updateLocationViewWithParam:displayParam];
    }
    
    _mapView.showMapScaleBar = YES;
    _mapView.zoomLevel = 3;
    _mapView.delegate = self;
    
    
}

/** 开始定位 */
- (void)startLocation{
    
     _locationManager = [DYLocationManager shareLocationManager];
    _locationManager.delegate = self;
    if (_type == MapViewTypeLocation) {
        _locationManager.locationing = YES;
        
    }else{
        _locationManager.locationing = NO;
    }
    [_locationManager startUpdatingLocation];

    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;// 定位罗盘模式
    _mapView.showsUserLocation = YES;//显示定位图层,开始定位
}


#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    _mapView.zoomLevel = mapViewZoomLevel;
    [self hideProgress];
}

#pragma mark -- DYLocationManagerDelegate

- (void)locationManage:(DYLocationManager *)manager didUpdateLocations:(NSArray <CLLocation *>*)locations{
    CLLocation *location = [locations lastObject];
   // _mapView.zoomLevel = mapViewZoomLevel;
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    BMKUserLocation *userLocation = [BMKUserLocation new];
    [userLocation setValue:location forKey:@"location"];
    [userLocation setValue:@"YES" forKey:@"updating"];
    [_mapView updateLocationData:userLocation];
    
    if(_type != MapViewTypeLocation){
        [self drawWalkPolyline:locations];
    }
   
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
    BMKMapPoint *tempPoints = malloc(sizeof(BMKMapPoint) * count);
    // 遍历数组 ,将coordinate 转化为 BMKMapPoint
    [locations enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL * _Nonnull stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
        
        // 放置起点旗帜
        if (0 == idx  && self.startPoint == nil && _type != MapViewTypeLocation ) {
            self.startPoint = [self creatPointWithLocaiton:location title:@"起点"];
        }
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
    //一个矩形的四边
    /** ltx: top left x */
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
    [self.mapView setVisibleMapRect:rect animated:YES];
    
    self.mapView.zoomLevel = mapViewZoomLevel -3;
    //[self.mapView setCenterCoordinate:[_locations firstObject].coordinate animated:YES];
    
}


// Override
#pragma mark - BMKMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = polylineColor;
        polylineView.lineWidth = polylineWidth;
       // polylineView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
        return polylineView;
    }
    return nil;
}
- (void)didFailToLocateUserWithError:(NSError *)error{
    DDLogError(@"error:%@",error);
}

/**
 *  添加一个大头针
 *
 *  @param location
 */
- (BMKPointAnnotation *)creatPointWithLocaiton:(CLLocation *)location title:(NSString *)title;
{
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapView addAnnotation:point];
    
    return point;
}

/**
 *  只有在添加大头针的时候会调用，直接在viewDidload中不会调用
 *  根据anntation生成对应的View
 *  @param mapView 地图View
 *  @param annotation 指定的标注
 *  @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if([[annotation title] isEqualToString:@"起点"]){ // 有起点旗帜代表应该放置终点旗帜（程序一个循环只放两张旗帜：起点与终点）
            annotationView.pinColor = BMKPinAnnotationColorGreen; // 替换资源包内的图片，作为起点
           
        }else if([[annotation title] isEqualToString:@"终点"]){
            annotationView.pinColor = BMKPinAnnotationColorRed;//终点的图标
        }else { // 没有起点旗帜，应放置起点旗帜
            annotationView.pinColor = BMKPinAnnotationColorPurple;

        }
        
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        
        // 不可拖拽
        annotationView.draggable = NO;
        
        return annotationView;
    }
    return nil;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    DDLogInfo(@"start locate");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //内存警告时，移除内存大的
    NSRange range = NSMakeRange(0, removeObjectsLen);
    [_locationManager.locations removeObjectsInRange:range];
}


- (IBAction)quitMap:(id)sender {
//    if (!self.isRunning) {//不是run
//        [_locationManager stopUpdatingLocation];
//    }
    
    [self dismissModalViewControllerAnimated:YES];
    if ( _type == MapViewTypeRunning) return;
    [_locationManager stopUpdatingLocation];
    
}

//底部预览界面选项
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems{
//    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"查看" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action,UIViewController  * _Nonnull previewViewController) {
//    //previewViewController 为当前视图(self)
//        [_mainVC presentViewController:previewViewController animated:YES completion:nil];
//    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [[UIAlertView bk_showAlertViewWithTitle:@"删除记录？" message:@"确定要删除此纪录吗？" cancelButtonTitle:@"点错了" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
               
                [_mainVC tableView:_mainVC.tableView deleteCellAtIndexPath:_indexParh];
            }
        }] show];
    }];


    return @[action2];
}


@end
