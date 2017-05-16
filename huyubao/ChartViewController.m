//
//  ChartViewController.m
//  huyubao
//
//  Created by mao ke on 2017/4/22.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "ChartViewController.h"
#import "AppDelegate.h"

@interface ChartViewController ()


@end

@implementation ChartViewController
@synthesize selectedDate = _selectedDate;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedDate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    [self setUp];
    
    NSString *date = [dateformatter stringFromDate:_selectedDate];
    NSDate *tstart = [dateformatter dateFromString:date];
    //起始时间戳
    NSTimeInterval interval = [tstart timeIntervalSince1970] * 1000;
    NSString *timeStart =[NSString stringWithFormat:@"%lf\n",interval];
    timeStart = [timeStart substringToIndex:10];
    NSInteger endTime = [timeStart integerValue];
    endTime = endTime+86400;
    NSString *timeEnd = [NSString stringWithFormat:@"%ld", (long)endTime];
    NSString *post = [NSString stringWithFormat:@"%@%@%@%@",@"Body=select,select * from huyubao where time between ",timeStart,@" and ",timeEnd];
    NSLog(@"post:%@", post);
//    [[AppDelegate instance]postToData:post];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectDate:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate
                                                          minimumDate:minDate
                                                          maximumDate:maxDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)oneWeek:(id)sender {
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformate stringFromDate:_selectedDate];
    NSDate *tend = [dateformate dateFromString:date];
    NSTimeInterval interval = [tend timeIntervalSince1970] * 1000;
    NSString *timeEnd =[NSString stringWithFormat:@"%lf\n",interval];
    timeEnd = [timeEnd substringToIndex:10];
    NSInteger time = [timeEnd integerValue];
    NSInteger startTime = time-86400*6;
    NSInteger endtime = time+86400;
    NSString *timeStart = [NSString stringWithFormat:@"%ld", (long)startTime];
    timeEnd = [NSString stringWithFormat:@"%ld", (long)endtime];
    NSLog(@"%@,%@",timeStart,timeEnd);
}

- (IBAction)yesterday:(id)sender {
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformate stringFromDate:_selectedDate];
    NSDate *tend = [dateformate dateFromString:date];
    NSTimeInterval interval = [tend timeIntervalSince1970] * 1000;
    NSString *timeEnd =[NSString stringWithFormat:@"%lf\n",interval];
    timeEnd = [timeEnd substringToIndex:10];
    NSInteger startTime = [timeEnd integerValue];
    startTime = startTime-86400;
    NSString *timeStart = [NSString stringWithFormat:@"%ld", (long)startTime];
    NSLog(@"%@,%@",timeStart,timeEnd);
}

- (IBAction)checkDev:(id)sender {
}


/**
 初始化chart
 */
- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, _height/2-20)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.topicLabel.text = @"温度折线图";
    self.lineChart.unit = @"°C";
    self.lineChart.topicLabel.textColor = ZFBlack;
        self.lineChart.isShowXLineSeparate = YES;
    self.lineChart.isShowYLineSeparate = YES;
    //    self.lineChart.isAnimated = NO;
    self.lineChart.isResetAxisLineMinValue = YES;
    //    self.lineChart.isShowAxisLineValue = NO;
    //    self.lineChart.isShadowForValueLabel = NO;
//    self.lineChart.isShadow = NO;
    //    self.lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    //    self.lineChart.valueCenterToCircleCenterPadding = 0;
    //    self.lineChart.separateColor = ZFYellow;
    //    self.lineChart.linePatternType = kLinePatternTypeForCurve;
    self.lineChart.unitColor = ZFBlack;
//    self.lineChart.backgroundColor = ZFPurple;
    self.lineChart.xAxisColor = ZFBlack;
    self.lineChart.yAxisColor = ZFBlack;
    self.lineChart.axisLineNameColor = ZFBlack;
    self.lineChart.axisLineValueColor = ZFBlack;
    self.lineChart.xLineNameLabelToXAxisLinePadding = 0;
    [self.view addSubview:self.lineChart];
    [self.lineChart strokePath];
    
    self.lineChart2 = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, _height/2+40, SCREEN_WIDTH, _height/2-20)];
    self.lineChart2.dataSource = self;
    self.lineChart2.delegate = self;
    self.lineChart2.topicLabel.text = @"溶解氧曲线图";
    //    self.lineChart2.unit = @"人";
    self.lineChart2.topicLabel.textColor = ZFBlack;
    self.lineChart2.isResetAxisLineMinValue = YES;
    //    self.lineChart2.isAnimated = NO;
    //    self.lineChart2.valueLabelPattern = kPopoverLabelPatternBlank;
    self.lineChart2.isShowYLineSeparate = YES;
    self.lineChart2.isShowXLineSeparate = YES;
//    self.lineChart2.linePatternType = kLinePatternTypeForCurve;
    //    self.lineChart.isShowAxisLineValue = NO;
    //    lineChart.valueCenterToCircleCenterPadding = 0;
    self.lineChart2.isShadow = NO;
    self.lineChart2.unitColor = ZFBlack;
//    self.lineChart2.backgroundColor = ZFWhite;
    self.lineChart2.xAxisColor = ZFBlack;
    self.lineChart2.yAxisColor = ZFBlack;
    self.lineChart2.axisLineNameColor = ZFBlack;
    self.lineChart2.axisLineValueColor = ZFBlack;
    self.lineChart2.xLineNameLabelToXAxisLinePadding = 0;
    [self.view addSubview:self.lineChart2];
    [self.lineChart2 strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@[@"-52", @"300", @"490", @"380", @"167", @"451",@"380", @"200", @"326", @"240", @"-258", @"137",@"256", @"300", @"-89", @"430", @"256", @"256",@"256", @"300", @"-89", @"430", @"256", @"256"]
//             @[@"380", @"200", @"326", @"240", @"-258", @"137"],
//             @[@"256", @"300", @"-89", @"430", @"256", @"256"]
             ];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue,ZFOrange,ZFMagenta];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return -200;
//}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld个", (long)circleIndex);
    
    //可在此处进行circle被点击后的自身部分属性设置,可修改的属性查看ZFCircle.h
    //    circle.circleColor = ZFRed;
    //    circle.isAnimated = YES;
    //    circle.opacity = 0.5;
    //    [circle strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld个" ,(long)circleIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    //    popoverLabel.textColor = ZFGold;
    //    [popoverLabel strokePath];
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0){
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
    }else{
        self.lineChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
    }
    
    [self.lineChart strokePath];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    [self.dataSelect setTitle:[dateformate stringFromDate:_selectedDate] forState:UIControlStateNormal];
    
    NSString *date = [dateformate stringFromDate:_selectedDate];
    NSDate *tstart = [dateformate dateFromString:date];
    NSTimeInterval interval = [tstart timeIntervalSince1970] * 1000;
    NSString *timeStart =[NSString stringWithFormat:@"%lf\n",interval];
    timeStart = [timeStart substringToIndex:10];
    NSInteger endTime = [timeStart integerValue];
    endTime = endTime+86400;
    NSString *timeEnd = [NSString stringWithFormat:@"%ld", (long)endTime];
    NSLog(@"%@,%@",timeStart,timeEnd);
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
