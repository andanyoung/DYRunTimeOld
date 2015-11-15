//
//  DYMainViewController.m
//  DYRunTime
//
//  Created by tarena on 15/11/2.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "DYMainViewController.h"
#import "DYRecordView.h"
#import "DYLocationManager.h"
#import "MapViewController.h"
#import "DYFMDBManager.h"
#import "DYRunRecord.h"
#import "DYRunRecordCell.h"

@interface DYMainViewController ()<DYLocationManagerDelegate,UIViewControllerPreviewingDelegate,UIViewControllerPreviewing>


@property (nonatomic,strong) DYRecordView *tableHeaderView;
//@property (nonatomic,weak) NSArray <CLLocation *> *locations;
@property (nonatomic,strong) DYLocationManager *locationManager;
@property (nonatomic, strong) NSArray *allDates;
@end

@implementation DYMainViewController

- (NSArray *)allDates{
    if (!_allDates) {
        _allDates = [DYFMDBManager getAllListLocations];
    }
    return _allDates;
}


- (DYLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager = [DYLocationManager shareLocationManager];
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableHeaderView = [[DYRecordView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [_tableHeaderView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.79]];
    self.tableView.tableHeaderView = _tableHeaderView;

    
    self.title = @"RunTime";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed:@"activity_location"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 28, 40);
    [button bk_addEventHandler:^(id sender) {
        MapViewController *mapVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];

            mapVc.locations = [NSMutableArray arrayWithArray:self.locationManager.locations];
            mapVc.type = self.locationManager.running;
        [self presentViewController:mapVc animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
    
   
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [DYLocationManager shareLocationManager].delegate = self;
    
    [self continueTimer];

}

- (void)viewWillDisappear:(BOOL)animated{
    [DYLocationManager shareLocationManager].delegate = nil;
    [super viewWillDisappear:animated];
    DDLogInfo(@"viewWillDisappear");
    [self stopTimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DYLocationManagerDelegate
- (void)locationManage:(DYLocationManager *)manager didUpdateLocations:(NSArray <CLLocation *>*)locations{
    _tableHeaderView.distanceLB.text = [NSString stringWithFormat:@"%05.2lf", manager.totalDistanc/1000.0];
    _tableHeaderView.speedLB.text = [NSString stringWithFormat:@"%05.2lf",manager.speed>0?manager.speed:0];
    //_locations = locations;
}

- (void)locationManage:(DYLocationManager *)manager didChangeUpdateLocationState:(BOOL)running{
    if (running) {
        [self.tableHeaderView startTimer];
        UIApplication *app = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(continueTimer)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:app];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTimer)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:app];
    }else{
        [self.tableHeaderView stopTimer];
        
        if( [DYFMDBManager saveLocations]){
            [manager.locations removeAllObjects];
            [self showSuccessMsg:@"保存成功"];
        }else{
            [self showErrorMsg:@"保存失败"];
        }
        self.allDates = [DYFMDBManager getAllListLocations];
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

/** 当返回这个页面时，继续计时器 */
- (void)continueTimer{
    [_tableHeaderView.timer setFireDate:[NSDate distantPast]];//开启定时器
    
    NSArray<CLLocation *> *array = _locationManager.locations;
    if (array.count<2||array == nil) return ;
    NSTimeInterval timeInterval = [[array lastObject].timestamp timeIntervalSinceDate:[array firstObject].timestamp];
    _tableHeaderView.timerNumber = (NSInteger)timeInterval;

}
/** 当退出这个页面时，停止计时器 */
- (void)stopTimer{
    [_tableHeaderView.timer setFireDate:[NSDate distantFuture]];//关闭定时器,invalidate会让timer，退出loop，取消timer
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.allDates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.allDates[section];
    return arr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *arr = self.allDates[section];
    DYRunRecord *record = arr[0];
    return record.date;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYRunRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Configure the cell...
    NSArray *arr = self.allDates[indexPath.section];
    DYRunRecord *record = arr[arr.count - indexPath.row - 1];
    cell.accessoryType = 1;
    cell.totalDistancLb.text = [NSString stringWithFormat:@"%@公里",record.totalDistanc];
    cell.totalTimeLb.text = [NSString stringWithFormat:@"%@s",record.totalTime];
    cell.timeLb.text = [NSString stringWithFormat:@"%@ ~ %@",record.startTime,record.endTime];
    
    return cell;
}

kRemoveCellSeparator

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.locationManager.running){
        [self showErrorMsg:@"正在计时，不能进入详情页面"];
        return;//当正在计时跑步时，不该进入
    }
    NSArray *arr = self.allDates[indexPath.section];
    DYRunRecord *record = arr[indexPath.row];
    MapViewController * mapVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];
    mapVC.type = MapViewTypeQueryDetail;
    mapVC.locations = [DYFMDBManager getLocationsWithDate:record.date andStartTime:record.startTime ];
    if (mapVC.locations == nil || mapVC.locations.count == 0) {
//        [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"找不到相关信息" cancelButtonTitle:@"OK!" otherButtonTitles:nil handler:nil] show];
        [self showErrorMsg:@"找不到相关信息"];
        return;
    }
    [self presentViewController:mapVC animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

//某行是否支持编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark - tableViewEdit

// Allows customization of the editingStyle for a particular（详细的） cell located at 'indexPath'. If not implemented（执行）, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
//某行的编辑状态
- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除此记录";
}

//当编辑操作出触发后，做什么
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle== UITableViewCellEditingStyleDelete) {
        if (editingStyle==UITableViewCellEditingStyleDelete) {
            
            [[UIAlertView bk_showAlertViewWithTitle:@"删除记录？" message:@"确定要删除此纪录吗？" cancelButtonTitle:@"点错了" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    NSArray *arr = self.allDates[indexPath.section];
                    DYRunRecord *record = arr[indexPath.row];
                    if([DYFMDBManager deleteRecordsWithDate:record.date andStartTime:record.startTime]){
                        _allDates = [DYFMDBManager getAllListLocations];
                        [tableView beginUpdates];
                        
                        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
                            
                            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                        } else {
                            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                        
                        [tableView endUpdates];

                    }
                }
            }] show];
            
        }
    }
}


#pragma mark - previewing Delegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    //转化坐标
    // CGPoint point = [_tableView convertPoint:location fromView:self.view];
    //通过当前坐标得到当前cell和indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
   //DYRunRecordCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *arr = self.allDates[indexPath.section];
    DYRunRecord *record = arr[indexPath.row];
    MapViewController * mapVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];
    mapVC.type = MapViewTypeQueryDetail;
    mapVC.locations = [DYFMDBManager getLocationsWithDate:record.date andStartTime:record.startTime ];
    if (mapVC.locations == nil || mapVC.locations.count == 0) {
        //        [[UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"找不到相关信息" cancelButtonTitle:@"OK!" otherButtonTitles:nil handler:nil] show];
        [self showErrorMsg:@"找不到相关信息"];
        
    }
     //dvc.preferredContentSize = CGSizeMake(200.0f,300.0f);
    
    //    CGRect rect = CGRectMake(10, location.y - 10, self.view.frame.size.width - 20,20);
    //    previewingContext.sourceRect = rect;
    return mapVC;
}


- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self showDetailViewController:viewControllerToCommit sender:self];
}

@end
