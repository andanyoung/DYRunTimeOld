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

//#import "DYRecordView.h"


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
  //  [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    

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
       
        DDLogError(@"manager start failed!");
    }
    
 
    
    
    
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
        [[DYLocationManager shareLocationManager] startUpdatingLocation];
         }
}

@end
