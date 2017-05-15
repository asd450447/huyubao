//
//  DevTableViewController.h
//  huyubao
//
//  Created by mao ke on 2017/4/20.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DevTableViewController : UITableViewController<CLLocationManagerDelegate>
@property NSMutableArray *DevInfo;
@property NSString *weather;
@property NSString *temp;
@property NSString *city;
@property (nonatomic, strong)CLLocationManager *cllocationManager;
@property (weak, nonatomic) IBOutlet UILabel *cityLable;
@property (weak, nonatomic) IBOutlet UILabel *weatherLable;
@property (weak, nonatomic) IBOutlet UILabel *tempLable;
@property UIRefreshControl *control;
@end
