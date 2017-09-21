//
//  TimeViewController.m
//  增氧机
//
//  Created by 蒋磊 on 2017/9/4.
//  Copyright © 2017年 蒋磊. All rights reserved.
//

#import "TimeViewController.h"
#import "ActionSheetPicker.h"

@interface TimeViewController ()
@property (nonatomic, strong) NSDate *selectedTime;
@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectDateFirst:(id)sender {
    NSInteger minuteInterval = 5;
    //clamp date
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {/// round up
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
    }
    
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a time" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedTime target:self action:@selector(timeWasSelected:element:) origin:sender];
    datePicker.minuteInterval = minuteInterval;
    [datePicker showActionSheetPicker];
}

- (IBAction)selectDayFirst:(id)sender {
    NSArray *percente = [NSArray arrayWithObjects:@"每天",@"当天",nil ];
    [ActionSheetStringPicker showPickerWithTitle:@"选择重复类型"
                                            rows:percente
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           [self dayWasSelected:selectedValue buttonTag:_daySelectFirst.tag selectedIndex:selectedIndex];
                                          
                                       } cancelBlock:^(ActionSheetStringPicker *picker) {
                                           NSLog(@"取消");
                                       } origin:sender];
}

- (IBAction)daySelectSecond:(id)sender {
    NSArray *percente = [NSArray arrayWithObjects:@"每天",@"当天",nil ];
    [ActionSheetStringPicker showPickerWithTitle:@"选择重复类型"
                                            rows:percente
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           [self dayWasSelected:selectedValue buttonTag:_daySelectSecond.tag selectedIndex:selectedIndex];
                                           
                                       } cancelBlock:^(ActionSheetStringPicker *picker) {
                                           NSLog(@"取消");
                                       } origin:sender];

}

- (IBAction)daySelectThird:(id)sender {
    NSArray *percente = [NSArray arrayWithObjects:@"每天",@"当天",nil ];
    [ActionSheetStringPicker showPickerWithTitle:@"选择重复类型"
                                            rows:percente
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           [self dayWasSelected:selectedValue buttonTag:_daySelectThird.tag selectedIndex:selectedIndex];
                                           
                                       } cancelBlock:^(ActionSheetStringPicker *picker) {
                                           NSLog(@"取消");
                                       } origin:sender];

}

- (IBAction)daySelectFourth:(id)sender {
    NSArray *percente = [NSArray arrayWithObjects:@"每天",@"当天",nil ];
    [ActionSheetStringPicker showPickerWithTitle:@"选择重复类型"
                                            rows:percente
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           [self dayWasSelected:selectedValue buttonTag:_daySelectFourth.tag selectedIndex:selectedIndex];
                                           
                                       } cancelBlock:^(ActionSheetStringPicker *picker) {
                                           NSLog(@"取消");
                                       } origin:sender];

}

- (IBAction)switchFirst:(id)sender {
    if (_switchFirst.on == YES) {
        NSString *pour = [NSString stringWithFormat:@"%@%@%@%ld",@"set#1,",_dataSelectFirst.titleLabel.text,@",",(long)_first];
        NSLog(@"%@",pour);
    }else{
        NSLog(@"关闭");
    }
    
}

- (IBAction)switchSecond:(id)sender {
    if (_switchSecond.on == YES) {
        NSString *pour = [NSString stringWithFormat:@"%@%@%@%ld",@"set#2,",_dataSelectSecond.titleLabel.text,@",",_second];
        NSLog(@"%@",pour);
    }else{
        NSLog(@"关闭");
    }
    
}

- (IBAction)switchThird:(id)sender {
    if (_switchThird.on == YES) {
        NSString *pour = [NSString stringWithFormat:@"%@%@%@%ld",@"set#3,",_dataSelectThird.titleLabel.text,@",",_third];
        NSLog(@"%@",pour);
    }else{
        NSLog(@"关闭");
    }
    
}

- (IBAction)switchFourth:(id)sender {
    if (_switchFourth.on == YES) {
        NSString *pour = [NSString stringWithFormat:@"%@%@%@%ld",@"set#4,",_dataSelectFourth.titleLabel.text,@",",_fourth];
        NSLog(@"%@",pour);
    }else{
        NSLog(@"关闭");
    }
    

}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"%@", [dateFormatter stringFromDate:selectedTime]);
    //    _dataSelect=[dateFormatter stringFromDate:selectedTime];
    [element setTitle:[dateFormatter stringFromDate:selectedTime] forState:UIControlStateNormal];
}

-(void)dayWasSelected:(NSString *)selectedDay buttonTag:(NSInteger)tag selectedIndex:(NSInteger)index{
    switch (tag) {
        case 1:
            _daySelectFirst.titleLabel.text = selectedDay;
            _first = index;
            break;
        case 2:
            _daySelectSecond.titleLabel.text = selectedDay;
            _second = index;
            break;
        case 3:
            _daySelectThird.titleLabel.text = selectedDay;
            _third = index;
            break;
        case 4:
            _daySelectFourth.titleLabel.text = selectedDay;
            _fourth = index;
            break;
        default:
            break;
    }
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
