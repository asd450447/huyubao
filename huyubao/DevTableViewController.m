//
//  DevTableViewController.m
//  huyubao
//
//  Created by mao ke on 2017/4/20.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "DevTableViewController.h"
#import "DevTableViewCell.h"
#import "AFNetworking.h"
#import "ChartViewController.h"
#import "openfileRequest.h"
#import "DKProgressHUD.h"

@interface DevTableViewController ()
@property NSInteger *refreshCount;
@property NSMutableArray *onlineMacTVC;
@property NSString *judge;
@property (nonatomic,copy) NSString *zyjState;
@end

@implementation DevTableViewController
{
    CLLocationDegrees lati;
    CLLocationDegrees longti;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mac = @"testdpj";
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"HYBios" forKey:@"userName"];
    [def setObject:@"123456" forKey:@"passWord"];
    [def synchronize];
    
    [[openfileRequest sharedNewtWorkTool]connectToHost];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openfileOnlineDev) name:@"openfileOnline" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openfileFieldDev) name:@"openfileFiled" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showOnlineMac:) name:@"onLineMac" object:nil];
    
//    [self connectHost:@"115.28.179.114" connectPort:1234];
//    [self connectHost:@"192.168.1.31" connectPort:1234];
    
    //隐藏多余cell
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _refreshCount = 0;
    [self setupRefresh];
    
    _DevInfo = [[NSMutableArray alloc]init];
    [_DevInfo addObject:@"护渔宝1号"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [DKProgressHUD dismiss];
//    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _DevInfo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"DevTabCell";
    DevTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    NSLog(@"%@", [self getNowTime]);
    
    if (_onlineMacTVC.count == 0) {
        _onlineMacTVC = [[openfileRequest sharedNewtWorkTool]onLineMac];
    }
    
    cell.onLine.text = @"离线";

    for (int i = 0; i<_onlineMacTVC.count; i++) {
        if ([_onlineMacTVC[i] isEqualToString:@"testdpj"]) {
            cell.onLine.text = @"在线";
        }
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    _zyjState = [def objectForKey:@"zyjState"];
    
    if ([_zyjState isEqualToString:@" "]) {
        cell.switchZyj.on = false;
    }else if([_zyjState isEqualToString:@"已关"]){
        cell.switchZyj.on = false;
    }else if([_zyjState isEqualToString:@"已开"]){
        cell.switchZyj.on = YES;
    }
    
    cell.Name.text = _DevInfo[indexPath.row];
    cell.DevImage.image = [UIImage imageNamed:[self judgeWeather:_weather]];
    cell.weatherLable.text = _weather;
    cell.temp.text = [NSString stringWithFormat:@"%@%@",_temp,@"℃"];
    cell.o2Lable.text =[NSString stringWithFormat:@"%@%@",_hybRy,@"mg/l"];
    cell.tempLable.text = [NSString stringWithFormat:@"%@%@",_hybTemp,@"℃"];
//    [cell.zyj setTitle:_zyjState forState:UIControlStateNormal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

//下划线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])[cell setLayoutMargins:UIEdgeInsetsZero];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChartViewController *chartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chartViewController"];
    [self.navigationController pushViewController:chartVC animated:YES ];
}

- (IBAction)zyjSwitch:(id)sender {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if ([[def objectForKey:@"zyjState"] isEqualToString:@"已开"]) {
        _judge = @"ctl#off";
        [[openfileRequest sharedNewtWorkTool]sendMessage:@"ctl#off" Mac:_mac];
        [DKProgressHUD showLoading];
    }else{
        _judge = @"ctl#on";
        [[openfileRequest sharedNewtWorkTool]sendMessage:@"ctl#on" Mac:_mac];
        [DKProgressHUD showLoading];
    }
    
}

- (IBAction)zyjBtnClick:(id)sender {
    
//    [[openfileRequest sharedNewtWorkTool]addFriend:@"testdpj"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置增氧机状态" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
//    此功能暂未实现
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"请填写增氧时间／分钟";
//        _text_time = textField.text;
//    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        _judge = @"ctl#off";
        [[openfileRequest sharedNewtWorkTool]sendMessage:@"ctl#off" Mac:_mac];
        [DKProgressHUD showLoading];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self sendMassageBtuClick:@"{\"contentType\":\"communication\",\"content\":{\"to\":12345,\"order\":\"get\",\"factoryId\":12345}}\n"];
        _judge = @"ctl#on";
        [[openfileRequest sharedNewtWorkTool]sendMessage:@"ctl#on" Mac:_mac];
        [DKProgressHUD showLoading];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)autoControlClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自动控制" message:@"当溶氧小于设定的值后，增氧机自动打开" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请填写溶氧值";
        _text_ry = textField.text;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        [self sendMassageBtuClick:@"{\"contentType\":\"communication\",\"content\":{\"to\":12345,\"order\":\"get\",\"factoryId\":12345}}\n"];
        [[openfileRequest sharedNewtWorkTool]sendMessage:@"" Mac:_mac];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
   
}

- (IBAction)checkBtnClick:(id)sender {
    [[openfileRequest sharedNewtWorkTool]sendMessage:@"gethuyubao" Mac:_mac];
//    [self sendMassageBtuClick:@"{\"contentType\":\"communication\",\"content\":{\"to\":12345,\"order\":\"get\",\"factoryId\":12345}}\n"];
}

/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    //1.添加刷新控件
    _control=[[UIRefreshControl alloc]init];
    [_control addTarget:self action:@selector(DTrefreshStateChange) forControlEvents:UIControlEventValueChanged];
    
    _control.attributedTitle = [[NSAttributedString alloc]initWithString:[self getNowTime]];
    
    
    [self.tableView addSubview:_control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [_control beginRefreshing];
    
    // 3.加载数据
    [self DTrefreshStateChange];
    
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)DTrefreshStateChange
{
    
    if (_refreshCount > 0) {
        _judge = @"refresh";
        [[openfileRequest sharedNewtWorkTool]sendMessage:@"get#data" Mac:_mac];
    }
    _refreshCount++;
    
//    [self setMap];
//    [self sendMassageBtuClick:@"{\"contentType\":\"communication\",\"content\":{\"to\":12345,\"order\":\"get\",\"factoryId\":12345}}\n"];
    
}

/**
 在线用户存入数组
 
 @param noti 广播信息
 */
-(void)showOnlineMac:(NSNotification *)noti{
    NSLog(@"我运行了");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [_onlineMacTVC addObject:[[openfileRequest sharedNewtWorkTool]onLineMac]];
        
        _onlineMacTVC = [[openfileRequest sharedNewtWorkTool]onLineMac];
        
        if (_onlineMacTVC.count>1) {
            for (int i=0; i<_onlineMacTVC.count; i++) {
                for (int j=i+1; j<_onlineMacTVC.count; j++) {
                    if ([_onlineMacTVC[i] isEqualToString: _onlineMacTVC[j]]) {
                        [_onlineMacTVC removeObjectAtIndex:j];
                    }
                }
            }
        }
        
        NSLog(@"onlineMacTVC:%@", _onlineMacTVC);
        
        //刷新表格
        [self.tableView reloadData];
        
    });
}

-(id)getNowTime{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [format1 stringFromDate:date];
}

-(void)getWeather{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{
                             @"cityname" : @"镇江",
                             @"key" : @"8a9fcef45a44b211652af449a28f494c",
                             };
    
    [sessionManager POST:@"https://op.juhe.cn/onebox/weather/query" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject[@"reason"]);
        _weather = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"info"];
        _temp = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"temperature"];
//        NSLog(@"post success:%@",responseObject[@"result"][@"data"][@"realtime"][@"weather"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_control endRefreshing];
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post failure:%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_control endRefreshing];
            [self.tableView reloadData];
            [DKProgressHUD showErrorWithStatus:@"获取环境参数失败"];
        });
        
    }];
}


- (void)setMap {
    
    //定位功能可用，开始定位
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:Ok];
    [self presentViewController:alert animated:YES completion:nil];
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
            _city = [place.locality substringToIndex:2 ];
            [self getWeather];
            NSLog(@"城市：%@", _city);
//            NSLog(@"区：%@", place.subLocality);
//            NSLog(@"街道：%@", place.thoroughfare);
//            NSLog(@"子街道：%@", place.subThoroughfare);
        }
    }];
    
    NSLog(@"@@@@@@@@@@=====%f,%f",lati,longti);
    
}

//openfile登陆成功
-(void)openfileOnlineDev{
    _judge = @"search";
    [[openfileRequest sharedNewtWorkTool]sendMessage:@"get#data" Mac:_mac];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(manageInfo) name:@"receiveMessage" object:nil];
}

//openfile登录失败
-(void)openfileFieldDev{
    [self showAlertTitle:@"登录失败" content:@"是否重新连接"];
    
}

-(void)manageInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if ([_judge isEqualToString:@"search"]) {
            NSArray *hyb = [[[openfileRequest sharedNewtWorkTool]reciveMessage] componentsSeparatedByString:@";"];
            _hybTemp = hyb[0];
            _hybTemp = [_hybTemp substringToIndex:_hybTemp.length-2];
            _hybRy = hyb[1];
            
            //        [self.tableView reloadData];
            //        [_control endRefreshing];
            //        [self setMap];
            [self getWeather];
        }
        
        if ([_judge isEqualToString:@"refresh"]) {
            NSArray *hyb = [[[openfileRequest sharedNewtWorkTool]reciveMessage] componentsSeparatedByString:@";"];
            _hybTemp = hyb[0];
            _hybTemp = [_hybTemp substringToIndex:_hybTemp.length-2];
            _hybRy = hyb[1];
            [self.tableView reloadData];
            [_control endRefreshing];

        }
        
        if ([_judge isEqualToString:@"ctl#on"]) {
            NSLog(@"%@", [[openfileRequest sharedNewtWorkTool]reciveMessage] );
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"已开" forKey:@"zyjState"];
            [def synchronize];
            
            [self.tableView reloadData];
        }
        
        if ([_judge isEqualToString:@"ctl#off"]) {
            NSLog(@"%@", [[openfileRequest sharedNewtWorkTool]reciveMessage] );
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"已关" forKey:@"zyjState"];
            [def synchronize];

            [self.tableView reloadData];
        }
        _judge = @"";
    });
}

//alert弹框不在线
-(void)showAlertTitle:(NSString *)title content:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[openfileRequest sharedNewtWorkTool]connectToHost];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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

////tcp连接服务器
//-(void)connectHost:(NSString *)host connectPort:(UInt32)port{
//    //创建GCDAsyncSocket
//    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    NSError *error = nil;
//    [_socket connectToHost:host onPort:port error:&error];
//    if (error != nil) {
//        NSLog(@"%@",error);
//    }
//}
//
//#pragma mark socket delegate
//-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
//    NSLog(@"didConneetToHost:%s",__func__);
//    [self sendMassageBtuClick:@"{\"contentType\":\"register\",\"content\":{\"to\":\"null\",\"order\":\"null\",\"factoryId\":105}}\n"];
//}
//
//-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
//    NSLog(@"连接失败或已断开:%@",err);
//}
//
//-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
//    //    NSLog(@"didWriteDataWithTag%s",__func__);
//    [_socket readDataWithTimeout:-1 tag:tag];
//    
//}
//
//-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
//    //    NSLog(@"didReadData:%s",__func__);
//    [sock readDataWithTimeout:-1 tag:200];
//    NSString *receiverStr = [[NSString alloc] initWithData:[self replaceNoUtf8:data] encoding:NSUTF8StringEncoding];
//    //   除去字符串中看不见的空格
//    NSString *additionalMessage = [receiverStr   stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
//    NSArray *hyb = [receiverStr componentsSeparatedByString:@","];
//    NSLog(@"receiverStr:%@",additionalMessage);
//    NSLog(@"receiverStr:%lu",(unsigned long)additionalMessage.length);
//    if ([receiverStr isEqualToString:@"ping\n"]) {
//        NSLog(@"pong\n");
//        [self sendMassageBtuClick:@"pong\n"];
//    }
//    
//    if (receiverStr.length == 8) {
//        NSLog(@"我收到success了\n");
////        [self sendMassage:@"pong\r\n"];
//    }
//    
//    if ([hyb[0] isEqual:@"data"]) {
//        _hybTemp = hyb[1];
//        _hybRy = hyb[2];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    }
//}
//
//#pragma mark 读取数据
//-(void)readData{
//    uint8_t buff[1024];
//    
//    NSInteger len = [_inputStream read:buff maxLength:sizeof(buff)];
//    NSMutableData *input = [[NSMutableData alloc] init];
//    [input appendBytes:buff length:len];
//    NSString *resultstring = [[NSString alloc]initWithData:input encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",resultstring);
//    [_msgArray addObject:resultstring];
//    //    [_tableView1 reloadData];
//    
//}
//
//#pragma mark send 按钮
//- (void)sendMassageBtuClick:(NSString *)msg{
//    
//    //    NSString *msg = @"getdatabyjl";
//    [_socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:102];
//    
//    [self.view endEditing:YES];
//    
//}
//
//
//#pragma mark 发送的封装方法
//-(void)sendMassage:(NSString *)msg{
//    NSData *buff = [msg dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [_outputStream write:buff.bytes maxLength:buff.length];
//}


//丢弃无用的ascii码
- (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
