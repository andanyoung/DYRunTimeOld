//
//  CYLPlusButton.m
//  CYLCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButton.h"
#import "CYLTabBarController.h"

UIButton<CYLPlusButtonSubclassing> *CYLExternPushlishButton = nil;
@interface CYLPlusButton ()

@end

@implementation CYLPlusButton

#pragma mark -
#pragma mark - Private Methods

+ (void)registerSubclass {
    
    /**
     1，实例方法里面的self，是对象的首地址。
     2，类方法里面的self，是Class.
     */
    
    if ([self conformsToProtocol:@protocol(CYLPlusButtonSubclassing)]) {
        Class<CYLPlusButtonSubclassing> class = self;
        CYLExternPushlishButton = [class plusButton];// 初始化子类 CYLPlusButtonSubclass
    }
    
    /**
     子类 CYLPlusButtonSubclass 在load的时候就替换了 父类
     +(void)load {
     [super registerSubclass];
     }
     */
}

@end
