//
//  TableViewController.m
//  huyubao
//
//  Created by 蒋磊 on 2017/9/18.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "openfileRequest.h"
#import "DetialViewController.h"
#import "DKProgressHUD.h"

@interface TableViewController ()
@property NSString *mac;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _devTable = [[NSMutableArray alloc]init];
    [_devTable addObject:@"护鱼1号"];
    
    _mac = @"testdpj";
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"HYBios" forKey:@"userName"];
    [def setObject:@"123456" forKey:@"passWord"];
    [def synchronize];
    
    [[openfileRequest sharedNewtWorkTool]connectToHost];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openfileOnlineDev) name:@"openfileOnline" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openfileFieldDev) name:@"openfileFiled" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showOnlineMac:) name:@"onLineMac" object:nil];
    
    //隐藏多余cell
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self setupRefresh];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [DKProgressHUD dismiss];
    [DKProgressHUD dismissForView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _devTable.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tablecell" forIndexPath:indexPath];
    
    if (_onlineMacTVC.count == 0) {
        _onlineMacTVC = [[openfileRequest sharedNewtWorkTool]onLineMac];
    }
    
    for (int i = 0; i<_onlineMacTVC.count; i++) {
        if ([_onlineMacTVC[i] isEqualToString:@"testdpj"]) {
            cell.onLine.text = @"在线";
        }
    }
    
    cell.name.text = _devTable[indexPath.row];
    
    return cell;
}

//下划线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])[cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetialViewController *detialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detialVC"];
    detialVC.name = _devTable[indexPath.row];
    [self.navigationController pushViewController:detialVC animated:YES ];
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

/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    //1.添加刷新控件
    _control=[[UIRefreshControl alloc]init];
//    [_control addTarget:self action:@selector(DTrefreshStateChange) forControlEvents:UIControlEventValueChanged];
    
    _control.attributedTitle = [[NSAttributedString alloc]initWithString:[self getNowTime]];
    
    
    [self.tableView addSubview:_control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [_control beginRefreshing];
    
    // 3.加载数据
//    [self DTrefreshStateChange];
    
}

-(id)getNowTime{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [format1 stringFromDate:date];
}

//openfile登陆成功
-(void)openfileOnlineDev{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_control endRefreshing];
    });
}

//openfile登录失败
-(void)openfileFieldDev{
    
    [self showAlertTitle:@"登录失败" content:@"是否重新连接"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
