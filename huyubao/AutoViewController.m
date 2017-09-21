//
//  AutoViewController.m
//  pet
//
//  Created by mao ke on 2017/5/4.
//  Copyright © 2017年 江苏科茂. All rights reserved.
//

#import "AutoViewController.h"
#import "ActionSheetPicker.h"
#import "DKProgressHUD.h"
#import "openfileRequest.h"

@interface AutoViewController ()
@property NSString *judge;
@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DKProgressHUD showLoading];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",_name,@"自动浇灌"];
    
    [[openfileRequest sharedNewtWorkTool]sendMessage:@"GetAutoState" Mac:_mac];
    _judge = @"GetAutoState";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleReceiveMes) name:@"receiveMessage" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchOn:(id)sender {
    if (_switchOff.on == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _lable1.hidden = false;
            _lable2.hidden = false;
            _label3.hidden = false;
            _lable4.hidden = false;
            _lable5.hidden = false;
            _lable6.hidden = false;
            _lable7.hidden = false;
            _lable8.hidden = false;
            _btnselect.hidden = false;
            [_btnselect setTitle:@"请选择" forState:UIControlStateNormal];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            _lable1.hidden = YES;
            _lable2.hidden = YES;
            _label3.hidden = YES;
            _lable4.hidden = YES;
            _lable5.hidden = YES;
            _lable6.hidden = YES;
            _lable7.hidden = YES;
            _lable8.hidden = YES;
            _btnselect.hidden = YES;
        });
        _judge = @"CloseAutoRun";
        [[openfileRequest sharedNewtWorkTool]sendMessage:@"CloseAutoRun#1" Mac:_mac];
    }
}
- (IBAction)selectHum:(id)sender {
    _judge = @"OpenAutoRun";
    NSArray *percente = [NSArray arrayWithObjects:@"50",@"55", @"60",@"65",@"70",@"75",@"80",@"85", nil];
    [ActionSheetStringPicker showPickerWithTitle:@"选择湿度（%）"
                                            rows:percente
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [_btnselect setTitle:selectedValue forState:UIControlStateNormal];
                                           [[openfileRequest sharedNewtWorkTool]sendMessage:[NSString stringWithFormat:@"OpenAutoRun#%@",selectedValue] Mac:_mac];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

-(void)handleReceiveMes{
    NSString *message = [[openfileRequest sharedNewtWorkTool]reciveMessage];
    if ([_judge isEqualToString:@"GetAutoState"]) {
        if (![message  isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _switchOff.on = YES;
                _btnselect.hidden = false;
                [_btnselect setTitle:message forState:UIControlStateNormal];
                _lable1.hidden = false;
                _lable2.hidden = false;
                _label3.hidden = false;
                _lable4.hidden = false;
                _lable5.hidden = false;
                _lable6.hidden = false;
                _lable7.hidden = false;
                _lable8.hidden = false;
                [DKProgressHUD dismiss];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [DKProgressHUD dismiss];
            });
        }
    }
    if ([_judge isEqualToString:@"OpenAutoRun" ]) {
        if ([message isEqualToString:@"CtlSuccess"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DKProgressHUD showSuccessWithStatus:@"自动控制调整成功" toView:self.view];
            });
        }
    }
    if ([_judge isEqualToString:@"CloseAutoRun"]) {
        if ([message isEqualToString:@"CtlSuccess"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DKProgressHUD showSuccessWithStatus:@"关闭自动控制" toView:self.view];
            });
        }
    }

}

//移除观察者
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc");
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
