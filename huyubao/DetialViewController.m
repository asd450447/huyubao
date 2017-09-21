//
//  DetialViewController.m
//  huyubao
//
//  Created by 蒋磊 on 2017/9/18.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "DetialViewController.h"
#import "openfileRequest.h"
#import "DKProgressHUD.h"
#import "AFNetworking.h"

@interface DetialViewController ()

@end

@implementation DetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mac = @"testdpj";
    
    self.navigationItem.title = _name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //去掉下划线
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    [DKProgressHUD showLoading];
    _judge = @"search";
    [[openfileRequest sharedNewtWorkTool]sendMessage:@"get#data" Mac:_mac];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manageInfo) name:@"receiveMessage" object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [DKProgressHUD dismiss];
    
//    _judge = @"refresh";
//    [[openfileRequest sharedNewtWorkTool]sendMessage:@"get#data" Mac:_mac];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchClick:(id)sender {
    
}

- (IBAction)autoControl:(id)sender {
    
}

- (IBAction)refreshClick:(id)sender {
    [DKProgressHUD showLoading];
    _judge = @"refresh";
    [[openfileRequest sharedNewtWorkTool]sendMessage:@"get#data" Mac:_mac];
}

- (IBAction)timeControl:(id)sender {
    
}

- (IBAction)dataHistory:(id)sender {
    
}

-(void)manageInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([_judge isEqualToString:@"search"]) {
            NSArray *hyb = [[[openfileRequest sharedNewtWorkTool]reciveMessage] componentsSeparatedByString:@";"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *t = hyb[0];
                t = [t substringToIndex:t.length-2];
                _waterTemp.text = [NSString stringWithFormat:@"%@%@",t,@"℃"];
                _rongyang.text = hyb[1];
            });
            
            [self getWeather];
        }
        
        if ([_judge isEqualToString:@"refresh"]) {
            NSArray *hyb = [[[openfileRequest sharedNewtWorkTool]reciveMessage] componentsSeparatedByString:@";"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *t = hyb[0];
                t = [t substringToIndex:t.length-2];
                _waterTemp.text = [NSString stringWithFormat:@"%@%@",t,@"℃"];
                _rongyang.text = hyb[1];
                [DKProgressHUD dismiss];
            });
            
        }
        
        if ([_judge isEqualToString:@"ctl#on"]) {
            NSLog(@"%@", [[openfileRequest sharedNewtWorkTool]reciveMessage] );
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"已开" forKey:@"zyjState"];
            [def synchronize];
            
        }
        
        if ([_judge isEqualToString:@"ctl#off"]) {
            NSLog(@"%@", [[openfileRequest sharedNewtWorkTool]reciveMessage] );
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"已关" forKey:@"zyjState"];
            [def synchronize];
            
        }
        _judge = @"";
    });
}

-(void)getWeather{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{
                             @"cityname" : @"镇江",
                             @"key" : @"8a9fcef45a44b211652af449a28f494c",
                             };
    
    [sessionManager POST:@"https://op.juhe.cn/onebox/weather/query" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject[@"reason"]);
        
        //        NSLog(@"post success:%@",responseObject[@"result"][@"data"][@"realtime"][@"weather"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *t;
            _weaterLable.text = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"info"];
            t = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"temperature"];
            _temp.text = [NSString stringWithFormat:@"%@%@",t,@"℃"];
            _weatherImg.image = [UIImage imageNamed:[self judgeWeather:_weaterLable.text]];
            [DKProgressHUD dismiss];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post failure:%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [DKProgressHUD dismiss];
            [DKProgressHUD showErrorWithStatus:@"获取环境参数失败"];
        });
        
    }];
}

//天气转化为图片
-(id)judgeWeather:(NSString *)weather{
    if ([weather isEqualToString:@"晴"]) {
        return @"ic_sunny_big";
    }
    else if ([weather isEqualToString:@"多云"]) {
        return @"ic_cloudy_big";
    }
    else if ([weather isEqualToString:@"阴"]) {
        return @"ic_overcast_big";
    }
    else if ([weather isEqualToString:@"雾"]) {
        return @"cloud";
    }
    else if ([weather isEqualToString:@"暴风雨"]) {
        return @"ic_nightrain_big";
    }
    else if ([weather isEqualToString:@"阵雨"]) {
        return @"ic_shower_big";
    }
    else if ([weather isEqualToString:@"大雨"]) {
        return @"ic_heavyrain_big";
    }
    else if ([weather isEqualToString:@"中雨"]) {
        return @"ic_moderraterain_big";
    }
    else if ([weather isEqualToString:@"小雨"]) {
        return @"ic_lightrain_big";
    }
    else if ([weather isEqualToString:@"雨夹雪"]) {
        return @"ic_sleet_big";
    }
    else if ([weather isEqualToString:@"暴雪"]) {
        return @"ic_snow_big";
    }
    else if ([weather isEqualToString:@"阵雪"]) {
        return @"ic_snow_big";
    }
    else if ([weather isEqualToString:@"大雪"]) {
        return @"ic_heavysnow_big";
    }
    else if ([weather isEqualToString:@"中雪"]) {
        return @"ic_snow_big";
    }
    else if ([weather isEqualToString:@"小雪"]) {
        return @"ic_snow_big";
    }
    else if ([weather isEqualToString:@"霾"]) {
        return @"ic_haze_big";
    }
    else if ([weather isEqualToString:@"冰雹"]) {
        return @"freezing_rain_day_night";
    }else{
        return @"sunny";
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
