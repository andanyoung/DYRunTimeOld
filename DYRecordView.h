//
//  DYRecordView.h
//  DYRunTime
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 ady. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYRecordView : UIView
@property (nonatomic,strong) UILabel *distanceLB;
@property (nonatomic,strong) UILabel *timeLB;
@property (nonatomic,strong) UILabel *speedLB;

/**
 *  开启计时器，更新界面的定时器
 */
- (void)startTimer;
/**
 *  停止计时器
 */
- (void)stopTimer;
@end