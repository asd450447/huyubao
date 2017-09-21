//
//  DevTableViewCell.h
//  huyubao
//
//  Created by mao ke on 2017/4/20.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UIImageView *DevImage;
@property (weak, nonatomic) IBOutlet UILabel *tempLable;
@property (weak, nonatomic) IBOutlet UILabel *o2Lable;
@property (weak, nonatomic) IBOutlet UIButton *zyj;
@property (weak, nonatomic) IBOutlet UIButton *autoControl;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *temp;

@property (weak, nonatomic) IBOutlet UILabel *onLine;
@property (weak, nonatomic) IBOutlet UILabel *weatherLable;
@property (weak, nonatomic) IBOutlet UISwitch *switchZyj;

@end
