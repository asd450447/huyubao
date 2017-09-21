//
//  AddFinshViewController.m
//  PetCare
//
//  Created by mao ke on 2017/3/13.
//  Copyright © 2017年 江苏科茂. All rights reserved.
//

#import "AddFinshViewController.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import "DKProgressHUD.h"
#import "AFNetworking.h"
#import <XMPPFramework/XMPPFramework.h>
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "openfileRequest.h"
#import "TableViewController.h"
#import "postToData.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AddFinshViewController ()<XMPPStreamDelegate,XMPPRosterDelegate>{
    HFSmartLink * smtlk;
    BOOL isconnecting;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UILabel *needChangeLable;
@property (weak, nonatomic) IBOutlet UILabel *needHideLable;
@property NSString *searching;
@property NSString *reSetWifi;
@property NSString *cancel;
@property NSString *added;
@property NSString *setted;
@property NSString *finish;
@end

@implementation AddFinshViewController
- (IBAction)searchClick:(id)sender {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers)
    {
        if ([vc isKindOfClass:[TableViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _searching = @"搜索中";
    _reSetWifi = @"重按配网，重新配置";
    _cancel = @"取消";
    _added = @"设备已被其他账号添加";
    _setted = @"配置完成";
    _finish = @"完成";
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    _ssidStr = [def objectForKey:@"ssidStr"];
    _pswdStr = [def objectForKey:@"pswdStr"];
    smtlk = [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = true;
    smtlk.waitTimers = 30;
    isconnecting=false;
    
    [self configWifi];
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//配置wifi
-(void)configWifi{
    
    if(!isconnecting){
        isconnecting = true;
        [smtlk startWithSSID:_ssidStr Key:_pswdStr withV3x:true
                processblock: ^(NSInteger pro) {
                   
                } successBlock:^(HFSmartLinkDeviceInfo *dev) {
                  
//                    [self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
                    NSLog(@"%@", dev.mac);
                    _whichMac = [dev.mac lowercaseString];
                    NSString *post = [NSString stringWithFormat:@"%@%@%@",@"paraName={\"name\":method,\"value\":PhoneIsDevExsitByMacWhenBind},{\"name\":mac,\"value\":",[dev.mac lowercaseString],@"}"];
                    [self postToData:dev.mac typeData:@"search" senfPost:post];
                } failBlock:^(NSString *failmsg) {
                    [self  showAlertWithMsg:failmsg title:@"error"];
                } endBlock:^(NSDictionary *deviceDic) {
                    isconnecting  = false;
//                    [self.btnSearch setTitle:@"搜索中3" forState:UIControlStateNormal];
//                    _btnSearch.enabled = false;
                }];
        [self.btnSearch setTitle:_searching forState:UIControlStateNormal];
    }else{
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            if(isOk){
                isconnecting  = false;
                [self.btnSearch setTitle:_searching forState:UIControlStateNormal];
                [self showAlertWithMsg:stopMsg title:@"OK"];
            }else{
                [self showAlertWithMsg:stopMsg title:@"error"];
            }
        }];
    }
}


-(void)showAlertWithMsg:(NSString *)msg
                  title:(NSString*)title{
//    _message = [msg substringToIndex:12];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:_reSetWifi style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self configWifi];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:_cancel style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 请求数据库信息
 */
-(void)postToData:(NSString *)msg typeData:(NSString *)type senfPost:(NSString *)post{

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
        if (!error) {
            NSString *str = responseObject[@"flag"];
            str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            NSLog(@"%@", str);
            if ([type isEqualToString:@"search"]) {
                str = [str substringFromIndex:29];
                if ([str isEqualToString:@"true"]) {
                    [self showAlertWithMsg:_added title:@"ERROR"];
                }else{
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    NSString *sendPost = [NSString stringWithFormat:@"%@%@%@%@%@",@"paraName={\"name\":method,\"value\":PhoneCreateMacWhenBind},{\"name\":mac,\"value\":",msg,@"},{\"name\":user,\"value\":",[def objectForKey:@"userName"],@"}"];
                    NSLog(@"sendpost:%@", sendPost);
                    [self postToData:msg typeData:@"Add" senfPost:sendPost];
                    
                }
            }else{
                str = [str substringFromIndex:23];
                if ([str isEqualToString:@"true"]) {
                    [[openfileRequest sharedNewtWorkTool]addFriend:msg];
//                  XMPPJID *jid = [XMPPJID jidWithString:msg];
//                  [xmppRoster subscribePresenceToUser:jid];
                    [[postToData sharedNewtWorkTool]PostCity];
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFinishBtn) name:@"location" object:nil];
                    
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:_reSetWifi preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:_reSetWifi style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self configWifi];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:_cancel style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }else{
            if ([type isEqualToString:@"search"]) {
                NSString *post = [NSString stringWithFormat:@"%@%@%@",@"paraName={\"name\":method,\"value\":PhoneIsDevExsitByMacWhenBind},{\"name\":mac,\"value\":",_whichMac,@"}"];
                [self postToData:_whichMac typeData:@"search" senfPost:post];
            }else{
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                NSString *sendPost = [NSString stringWithFormat:@"%@%@%@%@%@",@"paraName={\"name\":method,\"value\":PhoneCreateMacWhenBind},{\"name\":mac,\"value\":",msg,@"},{\"name\":user,\"value\":",[def objectForKey:@"userName"],@"}"];
                NSLog(@"sendpost:%@", sendPost);
                [self postToData:msg typeData:@"Add" senfPost:sendPost];
            }
        }
        }];
    
    [task resume];
}

-(void)showFinishBtn{

    NSString *post = [NSString stringWithFormat:@"%@%@%@%@%@",@"paraName={\"name\":method,\"value\":PhoneAddPet},{\"name\":mac,\"value\":",_whichMac,@"},{\"name\":name,\"value\":",[[postToData sharedNewtWorkTool]city],@"},{\"name\":type,\"value\":city},{\"name\":gender,\"value\":city},{\"name\":birth,\"value\":city},{\"name\":weight,\"value\":city}"];
    NSLog(@"post:%@", post);
    [[postToData sharedNewtWorkTool]PostRequestWithPost:post successBlock:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _needHideLable.hidden = true;
            _needChangeLable .text = _setted;
            [_btnSearch setTitle:_finish forState:UIControlStateNormal];
            _btnSearch.enabled = YES;
            _btnSearch.backgroundColor = UIColorFromRGB(0x6dd4ee);
        });
    } FailBlock:^(NSString *error) {
        [self showAlertWithMsg:_reSetWifi title:nil];
    }];
    
}

/**
 移除观察者
 */
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
