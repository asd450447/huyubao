//
//  postToData.m
//  TingYuanBao
//
//  Created by mao ke on 2017/6/8.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "postToData.h"

@implementation postToData

+(instancetype)sharedNewtWorkTool

{
    
    static id _instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
        
    });
    
    return _instance;
    
}

-(void)PostRequestWithPost:(NSString *)post successBlock:(SuccessBlock)success FailBlock:(failBlock)fail
{
    NSString *strURL =@"http://115.28.179.114:8885/wacw/WebServlet";
    NSURL *url = [NSURL URLWithString:strURL];
    
    //设置参数
    //    NSString *post = [NSString stringWithFormat:@"%@"@"%@",@"paraName={\"name\":method,\"value\":PhoneGetDevInfo},{\"name\":user,\"value\":",user];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"请求完成...");
//        NSLog(@"appdeleget:%@", responseObject[@"flag"]);
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"postToData" object:self userInfo:responseObject[@"flag"] ];
                NSLog(@"responseObject[flag]:%@", responseObject[@"flag"]);
                success(responseObject[@"flag"]);
            });
        } else {
            NSLog(@"error : %@", error.localizedDescription);
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"postToDataError" object:self ];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"error:%@", error.localizedDescription);
                fail(error.localizedDescription);
            });
        }
    }];
    
    [task resume];

}

- (void)PostAccessToken:(NSString *)phone successBlock:(SuccessBlock)success FailBlock:(failBlock)fail{
    NSString *strURL =@"https://jiangsukemao.top:443/EzvizService/servlet/LoginServlet";
    NSURL *url = [NSURL URLWithString:strURL];
    //设置参数
    NSString *post = [NSString stringWithFormat:@"%@%@",@"phone=",phone];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"请求完成...");
        
        if (!error) {
            NSLog(@"response:%@", responseObject[@"accessToken"]);
            success(responseObject[@"accessToken"]);
        } else {
            NSLog(@"error:%@", error.localizedDescription);
            fail(error.localizedDescription);
        }
    }];
    
    [task resume];
}

- (void)PostWeatherWithCity:(NSString *)city successBlock:(SuccessBlock)success FailBlock:(failBlock)fail{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"cityname" : city,
                             @"key" : @"8a9fcef45a44b211652af449a28f494c",
                             };
    
    [sessionManager POST:@"https://op.juhe.cn/onebox/weather/query" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        @try {
            _weatherPic = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"info"];
            _weatherPic = [self judgeWeather:_weatherPic];
        } @catch (NSException *exception) {
            NSLog(@"%@", responseObject);
        } @finally {
            
        }
        
        success(responseObject[@"result"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error.localizedDescription);
    }];
//    [sessionManager POST:@"https://op.juhe.cn/onebox/weather/query" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject[@"reason"]);
//        success(responseObject[@"reason"]);
////        _weather = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"info"];
////        _temp = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"temperature"];
//        //        NSLog(@"post success:%@",responseObject[@"result"][@"data"][@"realtime"][@"weather"]);
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"post failure:%@",error);
//    }];
}

- (void)PostCity{
    //定位功能可用，开始定位
    NSLog(@"开始定位");
    _cllocationManager = [[CLLocationManager alloc]init];
    _cllocationManager.delegate = self;
    _cllocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_cllocationManager requestWhenInUseAuthorization];
    [_cllocationManager startUpdatingLocation];
}

// 判断定位是否可用
- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"用户关闭";
            // 定位不可用 —— 传虚拟经纬度
            lati = 0.000000;
            longti = 0.000000;
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"位置数据不可用";
            //Do something else...
            break;
        default:
            errorString = @"未知错误";
            break;
    }
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //    [alert show];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *Ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:Ok];
//    [self presentViewController:alert animated:YES completion:nil];
}

// 代理方法 地理位置反编码
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newlocation = locations[0];
    CLLocationCoordinate2D oCoordinate = newlocation.coordinate;
    NSLog(@"经度：%f，维度：%f",oCoordinate.longitude,oCoordinate.latitude);
    // 给经纬度全局属性赋值
    lati = oCoordinate.latitude;
    longti = oCoordinate.longitude;
    
    //    [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(action:) userInfo:nil repeats:nil];
    [_cllocationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newlocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            //            NSDictionary *location =[place addressDictionary];
            //            NSLog(@"国家：%@",[location objectForKey:@"Country"]);
            //            NSLog(@"城市：%@",[location objectForKey:@"State"]);
            //            NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
            //            NSLog(@"位置：%@", place.name);
            //            NSLog(@"国家：%@", place.country);
            _city = place.locality;
            NSLog(@"%@", _city);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"location" object:self];
            //            NSLog(@"区：%@", place.subLocality);
            //            NSLog(@"街道：%@", place.thoroughfare);
            //            NSLog(@"子街道：%@", place.subThoroughfare);
        }
    }];
    
}

//转换天气图片
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
@end
