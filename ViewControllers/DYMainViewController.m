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

@interface DYMainViewController ()<DYLocationManagerDelegate>


@property (nonatomic,strong) DYRecordView *tableHeaderView;
@property (nonatomic,weak) NSArray<CLLocation *> *locations;
@end

@implementation DYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableHeaderView = [[DYRecordView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [_tableHeaderView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.79]];
    self.tableView.tableHeaderView = _tableHeaderView;

    
    self.title = @"RunTime";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"activity_location"] style:0 target:self action:@selector(clickLocation)];
   // item.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickLocation{
    MapViewController *mapVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];
    mapVc.locations = [NSMutableArray arrayWithArray:_locations];
    [self presentViewController:mapVc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [DYLocationManager shareLocationManager].delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DYLocationManager shareLocationManager].delegate = nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DYLocationManagerDelegate
- (void)locationManage:(DYLocationManager *)manager didUpdateLocations:(NSArray <CLLocation *>*)locations{
    _tableHeaderView.distanceLB.text = [NSString stringWithFormat:@"%05.2lf", manager.totalDistanc/1000.0];
    _tableHeaderView.speedLB.text = [NSString stringWithFormat:@"%05.2lf",manager.speed];
    _locations = locations;
}

- (void)locationManage:(DYLocationManager *)manager didChangeUpdateLocationState:(BOOL)running{
    if (running) {
        [self.tableHeaderView startTimer];
       
    }else{
        [self.tableHeaderView stopTimer];
        if( [DYFMDBManager saveLocations]){
            [manager.locations removeAllObjects];
            [self showSuccessMsg:@"保存成功"];
        }else{
            [self showErrorMsg:@"保存失败"];
        }
        [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
            [self hideProgress];
        } repeats:NO];
      
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%ld",section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row ];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
