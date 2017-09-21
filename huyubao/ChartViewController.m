//
//  ChartViewController.m
//  huyubao
//
//  Created by mao ke on 2017/4/22.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "ChartViewController.h"
#import "AppDelegate.h"
#import "DKProgressHUD.h"


@interface ChartViewController ()


@end

@implementation ChartViewController
@synthesize selectedDate = _selectedDate;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_dataSelect.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_dataSelect.layer setBorderWidth:1];
    [_dataSelect.layer setMasksToBounds:YES];
    [_timeStart.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_timeStart.layer setBorderWidth:1];
    [_timeStart.layer setMasksToBounds:YES];
    [_timeEnd.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_timeEnd.layer setBorderWidth:1];
    [_timeEnd.layer setMasksToBounds:YES];
    [_yesterdaySearch.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_yesterdaySearch.layer setBorderWidth:1];
    [_yesterdaySearch.layer setMasksToBounds:YES];
    [_yesterdaySearch setTitle:@"今天" forState:UIControlStateNormal];

    self.selectedDate = [NSDate date];
    _startTime = @"";
    _ryArr = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
    _valueArr2 = [[NSMutableArray alloc]init];
    [_valueArr2 addObjectsFromArray:_ryArr];
    NSLog(@"%@", _valueArr2);
//    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *date = [dateformatter stringFromDate:_selectedDate];
    
    [DKProgressHUD showLoading];
    
    NSString *post = [NSString stringWithFormat:@"%@",@"Body=select;SELECT AVG(data_temp) FROM huyubao WHERE DAY(time) = DAY(NOW()) AND MONTH(time) = MONTH(NOW()) AND YEAR(time) = YEAR(NOW()) GROUP BY HOUR(time)"];
    NSLog(@"%@", post);
    _judgeTitle = @"温度折线图";
    [[AppDelegate instance]postToData:post postToDate:@"today"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(arrDoing:) name:@"today" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:@"today"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setup:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"参数配置" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"溶氧上限";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"溶氧下限";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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

- (IBAction)startDate:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate
                                                          minimumDate:minDate
                                                          maximumDate:maxDate
                                                               target:self action:@selector(startSelected:element:) origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)endDate:(id)sender {
    if ([_startTime isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择起始日期" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        [minimumDateComponents setYear:2000];
        NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
        NSDate *maxDate = [NSDate date];
        
        
        _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate
                                                              minimumDate:minDate
                                                              maximumDate:maxDate
                                                                   target:self action:@selector(endSelected:element:) origin:sender];
        
        [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
        self.actionSheetPicker.hideCancel = YES;
        [self.actionSheetPicker showActionSheetPicker];
    }
}

- (IBAction)yesterday:(id)sender {
    [self showAlert:nil type:@"today"];
}


-(void)arrDoing:(NSNotification *)noti{
    NSLog(@"一天数据");
//    NSLog(@"%@", [noti.userInfo valueForKeyPath:@"dataTemp"]);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![noti.userInfo isEqual:@""]) {
            NSString *str = [NSString stringWithFormat:@"%@",[noti.userInfo valueForKeyPath:@"data"]];
            [self arrToStr:str whichType:nil];
            if ([_valueJudge isEqualToString:@"value"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"value" object:self];
                _valueJudge = @"";
            }
//            NSLog(@"%@", _valueArr);
            [self setUp];
        }
        [DKProgressHUD dismiss];
    });
}


-(void)arrToStr:(NSString *)str whichType:(NSString *)type{
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str substringFromIndex:1];
    str = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    _tempArr = [str componentsSeparatedByString:@","];
    _valueArr = [[NSMutableArray alloc]init];
    [_valueArr addObjectsFromArray:_tempArr];
    for (int i= 0; i<_valueArr.count; i++) {
        @try {
            _valueArr[i] = [_valueArr[i] substringToIndex:4];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    }
    NSLog(@"arr:%@",_valueArr);
}


/**
 初始化温度折线图
 */
- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, _height/3*2)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.topicLabel.text = _judgeTitle;
    self.lineChart.unit = nil;
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
    
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
//    if ([_judge isEqualToString:@"oneweek"]) {
//        _judge = @"";
//        return @[_valueArr,_valueArr2,_valueArr3,_valueArr4,_valueArr5];
//    }else{
        return @[_valueArr];
//    }
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return _valueArr2;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue,ZFOrange,ZFMagenta,ZFBlack,ZFLightGray,ZFRed,ZFGreen];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 50;
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
    
    [self showAlert:[dateformate stringFromDate:_selectedDate] type:@"select"];
}

- (void)startSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    [self.timeStart setTitle:[dateformate stringFromDate:_selectedDate] forState:UIControlStateNormal];
    _startTime = [dateformate stringFromDate:_selectedDate];
}

- (void)endSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    [self.timeEnd setTitle:[dateformate stringFromDate:_selectedDate] forState:UIControlStateNormal];
    [self showAlert:[dateformate stringFromDate:_selectedDate] type:@"between"];
}

-(void)showAlert:(NSString *)time type:(NSString *)type{
    _valueArr2 = [[NSMutableArray alloc]init];
    [_valueArr2 addObjectsFromArray:_ryArr];
    NSLog(@"%@", _valueArr2);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择溶氧或者温度" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"溶氧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([type isEqualToString:@"select"]) {
            NSString *post = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"Body=select;SELECT AVG(data_ry) FROM huyubao WHERE DAY(time) = DAY('",time,@"') AND MONTH(time) = MONTH('",time,@"') AND YEAR(time) = YEAR('",time,@"') GROUP BY HOUR(time)"];
            NSLog(@"post:%@", post);
            _judgeTitle = @"溶氧折线图";
            [[AppDelegate instance]postToData:post postToDate:@"select"];
            [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(arrDoing:) name:@"select" object:nil];
        }
        if ([type isEqualToString:@"today"]) {
            NSString *post = [NSString stringWithFormat:@"%@",@"Body=select;SELECT AVG(data_ry) FROM huyubao WHERE DAY(time) = DAY(NOW()) AND MONTH(time) = MONTH(NOW()) AND YEAR(time) = YEAR(NOW()) GROUP BY HOUR(time)"];
            _judgeTitle = @"溶氧折线图";
            [[AppDelegate instance]postToData:post postToDate:@"today"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(arrDoing:) name:@"today" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:@"today"];
        }
        if ([type isEqualToString:@"between"]) {
            NSString *post = [NSString stringWithFormat:@"%@%@%@%@%@",@"Body=select;SELECT AVG(data_ry) FROM huyubao WHERE time BETWEEN \"",_startTime,@" 00:00:00\" AND \"",time,@" 23:59:59\" GROUP BY DAY(time)"];
            _judgeTitle = @"溶氧折线图";
            NSLog(@"%@", post);
            [[AppDelegate instance]postToData:post postToDate:@"week"];
            _valueJudge = @"value";
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(arrDoing:) name:@"week" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:@"week"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xValue) name:@"value" object:nil];
            
        }

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"温度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([type isEqualToString:@"select"]) {
            NSString *post = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"Body=select;SELECT AVG(data_temp) FROM huyubao WHERE DAY(time) = DAY('",time,@"') AND MONTH(time) = MONTH('",time,@"') AND YEAR(time) = YEAR('",time,@"') GROUP BY HOUR(time)"];
            NSLog(@"post:%@", post);
            _judgeTitle = @"温度折线图";
            [[AppDelegate instance]postToData:post postToDate:@"select"];
            [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(arrDoing:) name:@"select" object:nil];
        }
        if ([type isEqualToString:@"today"]) {
            NSString *post = [NSString stringWithFormat:@"%@",@"Body=select;SELECT AVG(data_temp) FROM huyubao WHERE DAY(time) = DAY(NOW()) AND MONTH(time) = MONTH(NOW()) AND YEAR(time) = YEAR(NOW()) GROUP BY HOUR(time)"];
            _judgeTitle = @"温度折线图";
            [[AppDelegate instance]postToData:post postToDate:@"today"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(arrDoing:) name:@"today" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:@"today"];
        }
        if ([type isEqualToString:@"between"]) {
            NSString *post = [NSString stringWithFormat:@"%@%@%@%@%@",@"Body=select;SELECT AVG(data_temp) FROM huyubao WHERE time BETWEEN \"",_startTime,@" 00:00:00\" AND \"",time,@" 23:59:59\" GROUP BY DAY(time)"];
            _judgeTitle = @"温度折线图";
            NSLog(@"%@", post);
            
            [[AppDelegate instance]postToData:post postToDate:@"week"];
            _valueJudge = @"value";
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(arrDoing:) name:@"week" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:@"week"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xValue) name:@"value" object:nil];
            [[NSNotificationCenter defaultCenter]removeObserver:@"value"];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)xValue{
    _valueArr2 = [[NSMutableArray alloc]init];
    NSLog(@"xValue");
    if (_valueArr.count<8) {
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *tstart = [dateformatter dateFromString:_startTime];
        [_valueArr2 addObject:_startTime];
        //起始时间戳
        NSTimeInterval interval = [tstart timeIntervalSince1970] * 1000;
        NSString *timeStart =[NSString stringWithFormat:@"%lf\n",interval];
        timeStart = [timeStart substringToIndex:10];
        NSInteger endTime = [timeStart integerValue];
        for (int i=0; i<6; i++) {
            endTime = endTime+86400;
            NSString *timeEnd = [NSString stringWithFormat:@"%ld", (long)endTime];
            double time = [timeEnd doubleValue];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *dateEnd = [dateformatter stringFromDate:confromTimesp];
            [_valueArr2 addObject:dateEnd];
//            NSLog(@"%@", _valueArr2);
        }
    }else{
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *tstart = [dateformatter dateFromString:_startTime];
        [_valueArr2 addObject:_startTime];
        //起始时间戳
        NSTimeInterval interval = [tstart timeIntervalSince1970] * 1000;
        NSString *timeStart =[NSString stringWithFormat:@"%lf\n",interval];
        timeStart = [timeStart substringToIndex:10];
        NSInteger endTime = [timeStart integerValue];
        for (int i=0; i<_valueArr.count; i++) {
            endTime = endTime+86400;
            NSString *timeEnd = [NSString stringWithFormat:@"%ld", (long)endTime];
            double time = [timeEnd doubleValue];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *dateEnd = [dateformatter stringFromDate:confromTimesp];
            [_valueArr2 addObject:dateEnd];
            //            NSLog(@"%@", _valueArr2);
        }
    }
    [[NSNotificationCenter defaultCenter]removeObserver:@"value"];
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
