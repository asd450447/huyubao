//
//  AppDelegate.m
//  huyubao
//
//  Created by mao ke on 2017/4/19.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
+ (AppDelegate *)instance {
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self setupStream];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 请求数据库信息
 */
-(void)postToData:(NSString *)post postToDate:(NSString *)date{
    NSString *strURL =@"http://115.28.179.114:8885/HuYuBaoServlet/servlet/LoginServlet";
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
        if (!error) {
//            NSLog(@"%@", [responseObject valueForKeyPath:@"mac"]);
            if ([date isEqualToString:@"today"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"today" object:self userInfo:responseObject ];
            }
            if ([date isEqualToString:@"yesterday"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"yesterday" object:self userInfo:responseObject ];
            }
            if ([date isEqualToString:@"week"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"week" object:self userInfo:responseObject ];
            }
            if ([date isEqualToString:@"select"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"select" object:self userInfo:responseObject ];
            }
        } else {
            NSLog(@"error : %@", error.localizedDescription);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postToDataError" object:self ];
        }
    }];
    
    [task resume];
}


@end
