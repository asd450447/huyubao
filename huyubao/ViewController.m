//
//  ViewController.m
//  huyubao
//
//  Created by mao ke on 2017/4/19.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "ViewController.h"
#import "LDProgressView.h"
#import "GCDAsyncSocket.h"

@interface ViewController (){
    GCDAsyncSocket *_socket;
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    NSMutableArray *_msgArray;
}


@end

@implementation ViewController
- (IBAction)btnSend:(id)sender {
    [self inputToSever];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self connectToServer:@"192.168.199.21" port:8080];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 建立与服务器的连接
-(void)connectToServer:(NSString *)host port:(int)port{
    
    // 创建CF下的读入流
    CFReadStreamRef readStream;
    // 创建CF下的写出流
    CFWriteStreamRef writeStream;
    
    // 创建流
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)(host), port, &readStream, &writeStream);
    
    // 将CFXXX流和NSXXX流建立对应关系
    inputStream = (__bridge NSInputStream *)(readStream);
    outputStream = (__bridge NSOutputStream *)(writeStream);
    
    // 设置通信过程中的代理
    inputStream.delegate = self;
    outputStream.delegate = self;
    
    // 将流对象添加到主运行循环(如果不加到主循环,Socket流是不会工作的)
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // 打开流
    [inputStream open];
    [outputStream open];
    
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"%lu",(unsigned long)eventCode);
    
    switch (eventCode) {
            case NSStreamEventOpenCompleted:
            NSLog(@"连接完成");
            break;
            case NSStreamEventHasBytesAvailable:
        {NSLog(@"有刻度字节");
            uint8_t buffer[10];
            NSMutableString *mstr = [NSMutableString string];
            NSInteger len;// = [inputStream read:buffer maxLength:sizeof(buffer)];
            do{
                len =  [inputStream read:buffer maxLength:sizeof(buffer)];
                NSString *s = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                [mstr appendString:s];
            }while (len == sizeof(buffer));
            
            NSLog(@"====%@====",mstr);
        }
            break;
            case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以写入数据");
            break;
            case NSStreamEventErrorOccurred:
            NSLog(@"发生错误");
            break;
            case NSStreamEventEndEncountered:
            NSLog(@"流结束");
            // 做善后工作
            // 关闭流的同时，将流从主运行循环中删除
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        default:
            break;
    }
    
}

-(void)inputToSever{
    NSString *str = @"\n12345\n";
    NSLog(@"%@", str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data.bytes maxLength:data.length];
}

-(void)connectHost:(NSString *)host connectPort:(UInt32)port{
    //创建GCDAsyncSocket
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
    }
}

#pragma mark socket delegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"didConneetToHost:%s",__func__);
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"连接失败或已断开:%@",err);
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    //    NSLog(@"didWriteDataWithTag%s",__func__);
    [_socket readDataWithTimeout:-1 tag:tag];
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //    NSLog(@"didReadData:%s",__func__);
    [sock readDataWithTimeout:-1 tag:200];
    NSString *receiverStr = [[NSString alloc] initWithData:[self replaceNoUtf8:data] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receiverStr);
    
}

#pragma mark 读取数据
-(void)readData{
    uint8_t buff[1024];
    
    NSInteger len = [_inputStream read:buff maxLength:sizeof(buff)];
    NSMutableData *input = [[NSMutableData alloc] init];
    [input appendBytes:buff length:len];
    NSString *resultstring = [[NSString alloc]initWithData:input encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resultstring);
    [_msgArray addObject:resultstring];
    //    [_tableView1 reloadData];
    
}

#pragma mark send 按钮
- (void)sendMassageBtuClick:(NSString *)msg{
    
    //    NSString *msg = @"getdatabyjl";
    [_socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:102];
    
    [self.view endEditing:YES];
    
}


#pragma mark 发送的封装方法
-(void)sendMassage:(NSString *)msg{
    NSData *buff = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [_outputStream write:buff.bytes maxLength:buff.length];
}


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


@end
