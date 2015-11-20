//
//  DYNewsViewController.m
//  DYRunTime
//
//  Created by tarena on 15/10/31.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "DYNewsViewController.h"
#import "WYRunNewsListViewModel.h"
#import "DYNewsCell.h"
#import "NewsDetailViewController.h"

#import <Masonry.h>
#import <MJRefresh.h>
#import <UIImageView+AFNetworking.h>



@interface DYNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WYRunNewsListViewModel *newsListVM;
@end

@implementation DYNewsViewController
- (WYRunNewsListViewModel *)newsListVM{
    if (_newsListVM == nil) {
        _newsListVM = [WYRunNewsListViewModel new];
    }
    return _newsListVM;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_newsListVM getRefreshDataCompleteHandle:^(NSError *error) {
                NSLog(@"Refresh- currentThread:%@",[NSThread currentThread]);
                if (error) {
                    DDLogError(@"%@",error);
                }else{
                    
       dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
       });
                    
           
                }
                [_tableView.mj_header endRefreshing];
               
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [_newsListVM getMoreDataCompleteHandle:^(NSError *error) {
                 DDLogInfo(@"mj_footer - currentThread:%@",[NSThread currentThread]);
                if (error) {
                    DDLogError(@"%@",error);
                }else{
           // dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
            //});
                }
                
                [_tableView.mj_footer endRefreshing];
                
            }];
            
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView.mj_header beginRefreshing];

    self.title = @"News";

        [_tableView registerClass:[DYNewsCell class] forCellReuseIdentifier:@"newCell"];

    _tableView.rowHeight = 100;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsListVM.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    [cell.iconIV setImageWithURL:[self.newsListVM imgsrcURLWithIndexPath:indexPath.row] placeholderImage:[UIImage imageNamed:@"loading"]];
    cell.titleLB.text = [self.newsListVM titleWithIndexPath:indexPath.row];
    cell.digestLB.text = [self.newsListVM digestWithIndexPath:indexPath.row];
    
    return cell;
}

kRemoveCellSeparator
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc]initWithURL:[self.newsListVM url_3wWithIndexPath:indexPath.row]];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

@end
