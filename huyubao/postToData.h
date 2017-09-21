//
//  postToData.h
//  TingYuanBao
//
//  Created by mao ke on 2017/6/8.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

//成功回调类型:参数: 1. id: object(如果是 JSON ,那么直接解析成OC中的数组或者字典.如果不是JSON ,直接返回 NSData)

typedef void(^SuccessBlock)(NSDictionary *response);

// 失败回调类型:参数: NSError error;

typedef void(^failBlock)(NSString *error);

@interface postToData : NSObject<CLLocationManagerDelegate>{
    CLLocationDegrees lati;
    CLLocationDegrees longti;
}


// 单例的实例化方法
+ (instancetype)sharedNewtWorkTool;

@property NSString *weatherPic;
@property NSString *city;
@property (nonatomic, strong)CLLocationManager *cllocationManager;

- (void)PostRequestWithPost:(NSString *)post successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;

- (void)PostWeatherWithCity:(NSString *)city successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;

- (void)PostAccessToken:(NSString *)phone successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;

- (void)PostCity;
@end
