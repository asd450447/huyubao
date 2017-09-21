//
//  ChartViewController.h
//  huyubao
//
//  Created by mao ke on 2017/4/22.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFChart.h"
#import "ActionSheetPicker.h"
#import "ActionSheetDatePicker.h"

@interface ChartViewController : UIViewController<ZFGenericChartDataSource, ZFLineChartDelegate>

@property (nonatomic, strong) ZFLineChart * lineChart;
@property (nonatomic, strong) ZFLineChart * lineChart2;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, strong) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *dataSelect;
@property NSArray *tempArr;
@property NSArray *ryArr;
@property NSMutableArray *valueArr;
@property NSMutableArray *valueArr2;
@property NSString *judgeTitle;
@property NSString *startTime;
@property NSString *valueJudge;
@property (weak, nonatomic) IBOutlet UIButton *yesterdaySearch;
@property (weak, nonatomic) IBOutlet UIButton *timeStart;
@property (weak, nonatomic) IBOutlet UIButton *timeEnd;

@end
