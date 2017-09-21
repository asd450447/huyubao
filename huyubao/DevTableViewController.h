//
//  DevTableViewController.h
//  huyubao
//
//  Created by mao ke on 2017/4/20.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LDProgressView.h"
#import "GCDAsyncSocket.h"

@interface DevTableViewController : UITableViewController<CLLocationManagerDelegate>{
    GCDAsyncSocket *_socket;
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    NSMutableArray *_msgArray;
}

@property (weak, nonatomic) IBOutlet UISwitch *zyjSw;

@property NSMutableArray *DevInfo;
@property NSString *weather;
@property NSString *temp;
@property NSString *city;
@property (nonatomic, strong)CLLocationManager *cllocationManager;
@property NSString *hybTemp;
@property NSString *hybRy;
@property UIRefreshControl *control;
@property (nonatomic,copy) NSString *text_time;
@property (nonatomic,copy) NSString *text_ry;
@property NSString *mac;
@end
