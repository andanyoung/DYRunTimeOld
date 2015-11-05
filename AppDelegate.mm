//
//  AppDelegate.m
//  DYRunTime
//
//  Created by tarena on 15/10/15.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "AppDelegate.h"
#import "DYLocationManager.h"

#define Key @"sy1uzDm5FzsX0yXW6CkUZarj"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import "CYLTabBarController.h"
#import "DYMainViewController.h"
#import "DYNewsViewController.h"


BMKMapManager* _mapManager;

@interface AppDelegate ()
//{
//    UIBackgroundTaskIdentifier bgtask;
//}

@end

@implementation AppDelegate

//- (DYLocationManager *)locationManager{
//    if (!_locationManager) {
//        _locationManager = [DYLocationManager shareLocationManager];
//    }
//    return _locationManager;
//}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置主窗口,并设置跟控制器
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self setupViewControllers];
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    [self customizeInterface];
    
    //先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    //key
    BOOL ret = [_mapManager start:Key generalDelegate:nil];
    if (!ret) {
        WCLog(@"manager start failed!");
    }
    
    //_locationManager = [DYLocationManager shareLocationManager];
    //self.locationManager.locationService.activityType = CLActivityTypeFitness;
    //    _locationManager.locationService.desiredAccuracy = kCLLocationAccuracyBest;
    //    _locationManager.locationService.distanceFilter = 5.0;
    //    _locationManager.locationService.pausesLocationUpdatesAutomatically = NO;
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
    //         _locationManager.locationService.allowsBackgroundLocationUpdates = YES;
    //    }
    
    
    return YES;
}

/**
 *  配置vc
 */
- (void)setupViewControllers{
    DYMainViewController *mianViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"main"];
    UINavigationController *firstNavigationController = [[UINavigationController alloc]initWithRootViewController:mianViewController];
    
    DYNewsViewController *newsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"news"];
    UIViewController *secondNavigationController = [[UINavigationController alloc]initWithRootViewController:newsViewController];
    
    
    CYLTabBarController *tabBarController = [CYLTabBarController new];
    
    [self customizeTabBarForController:tabBarController];
    
    [tabBarController setViewControllers:@[
                                           firstNavigationController,
                                           secondNavigationController
                                           ]];
    self.tabBarController = tabBarController;
}




/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"home_normal",
                            CYLTabBarItemSelectedImage : @"home_highlight",
                            };
//    NSDictionary *dict2 = @{
//                            CYLTabBarItemTitle : @"同城",
//                            CYLTabBarItemImage : @"mycity_normal",
//                            CYLTabBarItemSelectedImage : @"mycity_highlight",
//                            };
//    NSDictionary *dict3 = @{
//                            CYLTabBarItemTitle : @"消息",
//                            CYLTabBarItemImage : @"message_normal",
//                            CYLTabBarItemSelectedImage : @"message_highlight",
//                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"account_normal",
                            CYLTabBarItemSelectedImage : @"account_highlight"
                            };
    NSArray *tabBarItemsAttributes = @[ dict1,
                                        dict4
                                        ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

- (void)customizeInterface {
    [self setUpNavigationBarAppearance];
    [self setUpTabBarItemTextAttributes];
}
/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //[navigationBarAppearance setBackgroundColor:[UIColor lightGrayColor]];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateHighlighted];
    
    // 设置背景图片
   // UITabBar *tabBarAppearance = [UITabBar appearance];
    
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background_os7"]];
  
}

#pragma mark - UIApplicationDelegate
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
//     bgtask = [application beginBackgroundTaskWithExpirationHandler:^{
//        // 当申请的后台运行时间已经结束（过期），就会调用这个block
//        
//        // 赶紧结束任务
//        [application endBackgroundTask:bgtask];
//        bgtask = UIBackgroundTaskInvalid;
//    }];
//    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
