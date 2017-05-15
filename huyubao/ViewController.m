//
//  ViewController.m
//  huyubao
//
//  Created by mao ke on 2017/4/19.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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

@end
