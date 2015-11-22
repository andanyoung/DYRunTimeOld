//
//  DYMainViewController.h
//  DYRunTime
//
//  Created by tarena on 15/11/2.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYMainViewController : UITableViewController
//- (void) refreshDataForTableViewWith:(id)object withSection:(NSInteger)section;
/** 根据indexPath删除cell */
- (void)tableView:(UITableView *)tableView deleteCellAtIndexPath:(NSIndexPath *)indexPath;
@end
