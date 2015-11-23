//
//  AppDelegate.m
//  DYRunTime
//
//  Created by tarena on 15/10/15.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "AppDelegate.h"
#import "DYLocationManager.h"
#import "CYLTabBarControllerConfig.h"
#import "MobClick.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件


#define UMengKey @"565169f167e58e49ba005813"
#define BMKMApKey @"sy1uzDm5FzsX0yXW6CkUZarj"
BMKMapManager* _mapManager;

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  //  [DDLog addLogger:[DDASLLogger sharedInstance]];
    

    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    
    DDLogVerbose(@"didFinishLanching");
    // 设置主窗口,并设置跟控制器
    
    // 设置主窗口,并设置跟控制器
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    _tabBarController = tabBarControllerConfig.tabBarController;
   
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    
    [self.window makeKeyAndVisible];
    [self customizeInterface];
    
    //先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    //key
    BOOL ret = [_mapManager start:BMKMApKey generalDelegate:nil];
    if (!ret) {
       
        DDLogError(@"manager start failed!");
    }
    
    //注册友盟统计
    [MobClick startWithAppkey:UMengKey reportPolicy:BATCH channelId:nil];
    
    return YES;
}

/**
 *  配置vc
 */
- (void)customizeInterface {
     [UINavigationBar appearance].barTintColor = [UIColor redColor];
   // [self setUpNavigationBarAppearance];
}

/**
 *  设置navigationBar样式
 */
//- (void)setUpNavigationBarAppearance {
//    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//    
//    UIImage *backgroundImage = nil;
//    NSDictionary *textAttributes = nil;
//    
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
//        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
//        
//        textAttributes = @{
//                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
//                           NSForegroundColorAttributeName: [UIColor blackColor],
//                           };
//    } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
//        
//        textAttributes = @{
//                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
//                           UITextAttributeTextColor: [UIColor blackColor],
//                           UITextAttributeTextShadowColor: [UIColor clearColor],
//                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
//                           };
//#endif
//    }
//    
//    //[navigationBarAppearance setBackgroundImage:backgroundImage
//    //                              forBarMetrics:UIBarMetricsDefault];
//    [navigationBarAppearance setTitleTextAttributes:textAttributes];
//    
//    navigationBarAppearance.barTintColor = [UIColor redColor];
//}

#pragma mark - UIApplicationDelegate
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
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

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    //判断先前我们设置的唯一标识

    if([shortcutItem.type isEqualToString: @"com.ady.Runtime.run"]){
       
        // 设置主窗口,并设置跟控制器
        [self.window setRootViewController:self.tabBarController];
       // [self.window makeKeyAndVisible];
        DYLocationManager *locationManager = [DYLocationManager shareLocationManager];
        self.tabBarController.selectedIndex = 1;
        if (!locationManager.running) {
            locationManager.delegate = ((UINavigationController *)self.tabBarController.selectedViewController).viewControllers[0];
            [locationManager startUpdatingLocation];
        }
     }
}

@end
