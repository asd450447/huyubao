//
//  TimeViewController.h
//  增氧机
//
//  Created by 蒋磊 on 2017/9/4.
//  Copyright © 2017年 蒋磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *dataSelectFirst;
@property (weak, nonatomic) IBOutlet UIButton *dataSelectSecond;
@property (weak, nonatomic) IBOutlet UIButton *dataSelectThird;
@property (weak, nonatomic) IBOutlet UIButton *dataSelectFourth;
@property (weak, nonatomic) IBOutlet UIButton *daySelectFirst;
@property (weak, nonatomic) IBOutlet UIButton *daySelectSecond;
@property (weak, nonatomic) IBOutlet UIButton *daySelectThird;
@property (weak, nonatomic) IBOutlet UIButton *daySelectFourth;
@property (weak, nonatomic) IBOutlet UISwitch *switchFirst;
@property (weak, nonatomic) IBOutlet UISwitch *switchSecond;
@property (weak, nonatomic) IBOutlet UISwitch *switchThird;
@property (weak, nonatomic) IBOutlet UISwitch *switchFourth;
@property (nonatomic) NSInteger first;
@property (nonatomic) NSInteger second;
@property (nonatomic) NSInteger third;
@property (nonatomic) NSInteger fourth;
@end
