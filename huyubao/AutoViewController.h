//
//  AutoViewController.h
//  pet
//
//  Created by mao ke on 2017/5/4.
//  Copyright © 2017年 江苏科茂. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AutoViewController : UIViewController
@property NSString *name;
@property NSString *mac;
@property (weak, nonatomic) IBOutlet UISwitch *switchOff;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UIButton *btnselect;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *lable4;
@property (weak, nonatomic) IBOutlet UILabel *lable5;
@property (weak, nonatomic) IBOutlet UILabel *lable6;
@property (weak, nonatomic) IBOutlet UILabel *lable7;
@property (weak, nonatomic) IBOutlet UILabel *lable8;

@end
