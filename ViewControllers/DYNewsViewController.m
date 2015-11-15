//
//  DYNewsViewController.m
//  DYRunTime
//
//  Created by tarena on 15/10/31.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "DYNewsViewController.h"
#import <Masonry.h>

@interface DYNewsViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"google_fit_dialog_background"]];
    _imageView.contentMode = 2;
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    self.title = @"News";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
