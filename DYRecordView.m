//
//  DYRecordView.m
//  DYRunTime
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 ady. All rights reserved.
//

#import "DYRecordView.h"
#import <Masonry.h>

@interface DYRecordView ()
@property (nonatomic,strong) UILabel *distanceLB;
@property (nonatomic,strong) UILabel *timeLB;
@property (nonatomic,strong) UILabel *speedLB;
@end

@implementation DYRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _distanceLB = [[UILabel alloc]init];
        _distanceLB.text = @"00.00";
        _distanceLB.font =  [UIFont fontWithName:@"AmericanTypewriter-Bold" size:80];
        _distanceLB.textAlignment = NSTextAlignmentCenter;
        //文本文字自适应大小
      //  _distanceLB.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_distanceLB];
        [_distanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *unitLabel = [[UILabel alloc]init];
        unitLabel.text = @"公里";
        unitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:unitLabel];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_distanceLB.mas_bottom).mas_equalTo(2);
            make.right.mas_equalTo(_distanceLB.mas_right);
        }];
        
        UIView *containerView = [UIView new];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unitLabel.mas_bottom).mas_equalTo(0);
            make.bottom.mas_equalTo(2);
            make.left.right.mas_equalTo(0);
        }];
        
        /* 时间 */
        UIImageView *timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sportdetail_time"]];
        [self addSubview:timeImageView];
        [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(containerView.mas_top).mas_equalTo(10);
            make.centerX.mas_equalTo(100);
        }];
        
        UILabel *unit4Time =[UILabel new];
        unit4Time.text = @"时间(s)";
        unit4Time.font = [UIFont systemFontOfSize:12];
        [self addSubview:unit4Time];
        [unit4Time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeImageView.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(timeImageView.mas_centerX).mas_equalTo(0);
        }];
        
        _timeLB = [[UILabel alloc]init];
        _timeLB.text = @"00:00";
        [self addSubview:_timeLB];
        [_timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unit4Time.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(unit4Time.mas_centerX).mas_equalTo(0);
        }];
        
        /* 平均速度 */
        UIImageView *speedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sportdetail_speed"]];
        [self addSubview:speedImageView];
        [speedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(containerView.mas_top).mas_equalTo(10);
            make.centerX.mas_equalTo(-100);
        }];
        
        
        UILabel *unit4Speed =[UILabel new];
        unit4Speed.text = @"平均速度(m/s)";
        unit4Speed.font = [UIFont systemFontOfSize:12];
        [self addSubview:unit4Speed];
        [unit4Speed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(speedImageView.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(speedImageView.mas_centerX).mas_equalTo(0);
        }];
        
        _speedLB = [[UILabel alloc]init];
        _speedLB.text = @"00";
        [self addSubview:_speedLB];
        [_speedLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unit4Speed.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(unit4Speed.mas_centerX).mas_equalTo(0);
        }];

        
    }
    
    return self;
}

- (void)setDistance:(NSInteger)distance{
    _distance = distance;
    _distanceLB.text = [NSString stringWithFormat:@"%4ld",_distance];
    
   
}

@end
