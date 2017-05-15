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

@interface DevTableViewController ()

@end

@implementation DevTableViewController
{
    CLLocationDegrees lati;
    CLLocationDegrees longti;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏多余cell
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self setupRefresh];
    _DevInfo = [[NSMutableArray alloc]init];
    [_DevInfo addObject:@"护渔宝"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSLog(@"%@", [self getNowTime]);
    cell.Name.text = _DevInfo[indexPath.row];
    cell.DevImage.image = [UIImage imageNamed:@"leave"];
    NSString *count = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    NSString *arrCount = [NSString stringWithFormat:@"%ld", (long)_DevInfo.count];
//    NSLog(@"count%@arrcount%@",count,arrCount);
    if ([count isEqualToString:arrCount]) {
        cell.refreshTime.text = [self getNowTime];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChartViewController *chartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chartViewController"];
    [self.navigationController pushViewController:chartVC animated:YES ];
}


/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    //1.添加刷新控件
    _control=[[UIRefreshControl alloc]init];
    [_control addTarget:self action:@selector(DTrefreshStateChange) forControlEvents:UIControlEventValueChanged];
    
    _control.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
    
    
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
    [self setMap];
}


-(id)getNowTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format1 stringFromDate:date];
}

-(void)getWeather{
//    NSString *strURL =@"";
//    NSURL *url = [NSURL URLWithString:strURL];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"cityname" : _city,
                             @"key" : @"8a9fcef45a44b211652af449a28f494c",
                             };
    
    [sessionManager POST:@"http://op.juhe.cn/onebox/weather/query" parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        _weather = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"info"];
        _temp = responseObject[@"result"][@"data"][@"realtime"][@"weather"][@"temperature"];
//        NSLog(@"post success:%@",responseObject[@"result"][@"data"][@"realtime"][@"weather"]);
        dispatch_async(dispatch_get_main_queue(), ^{
            _cityLable.text = _city;
            _tempLable.text = _temp;
            _weatherLable.text = _weather;
            [_control endRefreshing];
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post failure:%@",error);
    }];
        //设置参数
    
//    NSString *post = [NSString stringWithFormat:@"%@"@"",@"paraName={\"name\":method,\"value\":PhoneGetDevInfo},{\"name\":user,\"value\":"];
//    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:postData];
//    
//    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
//    
//    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSLog(@"请求完成...");
//        if (!error) {
//            NSLog(@"%@", responseObject[@"result"]);
//            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"postToData" object:self userInfo:responseObject[@"flag"] ];
//        } else {
//            NSLog(@"error : %@", error.localizedDescription);
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"postToDataError" object:self ];
//        }
//    }];
//    
//    [task resume];
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
    NSLog(@"5");
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
            NSDictionary *location =[place addressDictionary];
            NSLog(@"国家：%@",[location objectForKey:@"Country"]);
            NSLog(@"城市：%@",[location objectForKey:@"State"]);
            NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
            NSLog(@"位置：%@", place.name);
            NSLog(@"国家：%@", place.country);
            _city = [place.locality substringToIndex:2 ];
            [self getWeather];
            NSLog(@"城市：%@", _city);
            NSLog(@"区：%@", place.subLocality);
            NSLog(@"街道：%@", place.thoroughfare);
            NSLog(@"子街道：%@", place.subThoroughfare);
        }
    }];
    
    NSLog(@"@@@@@@@@@@=====%f,%f",lati,longti);
    
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
