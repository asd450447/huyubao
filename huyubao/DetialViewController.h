//
//  DetialViewController.h
//  huyubao
//
//  Created by 蒋磊 on 2017/9/18.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *waterTemp;
@property (weak, nonatomic) IBOutlet UILabel *rongyang;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (weak, nonatomic) IBOutlet UILabel *weaterLable;
@property (weak, nonatomic) IBOutlet UISwitch *switchZYJ;
@property NSString *mac;
@property NSString *judge;
@property NSString *name;
@end
