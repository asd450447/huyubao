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
@property (weak, nonatomic) IBOutlet UIProgressView *tempProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *o2Progress;
@property (weak, nonatomic) IBOutlet UILabel *refreshTime;
@property (weak, nonatomic) IBOutlet UILabel *tempLable;
@property (weak, nonatomic) IBOutlet UILabel *o2Lable;

@end
