//
//  MapViewController.h
//  DYRunTime
//
//  Created by tarena on 15/10/15.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /** 用于定位 */
    MapViewTypeLocation,
    /** 用于运动轨迹 */
    MapViewTypeRunning,
    /** 用于回放轨迹细节 */
    MapViewTypeQueryDetail 
} MapViewType;

@interface MapViewController : UIViewController
@property (strong, nonatomic)NSMutableArray *locations;
/** 判断是定位还是，运动 */
@property (nonatomic) MapViewType type;

@end
