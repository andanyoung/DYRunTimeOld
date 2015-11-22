//
//  WYRunNewsListNetWork.m
//  DYRunTime
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "WYRunNewsListNetWork.h"
#import <AFNetworking.h>

@implementation WYRunNewsListNetWork


+ (id)Get:(NSString *)path completeHandle:(void (^)(id , NSError *))complete{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        complete([WYRunNewsListModel runNewsListModelWithArray:responseObject[@"T1411113472760"]],nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        DDLogError(@"%@",error);
    }];
    return nil;
}

    
    
//+ (id)Get:(NSString *)path completeHandle:(void (^)(id , NSError *))complete{
//
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
//        if (error) {
//            complete(nil,error);
//        }else{
//            NSError *error1 = nil;
//            id responseObj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error1];
//            if (error1) {
//                complete(nil,error1);
//            }else{
//                complete([WYRunNewsListModel runNewsListModelWithArray:responseObj[@"T1411113472760"]],error1);
//            }
//        }
//    }];
//    [task resume];
//    return task;
//}
@end
