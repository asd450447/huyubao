//
//  ViewController.h
//  huyubao
//
//  Created by mao ke on 2017/4/19.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSStreamDelegate>{
    // 输入流,用来读取服务器返回的字节
    NSInputStream *inputStream;
    // 输出流,用于给服务器发送字节
    NSOutputStream *outputStream;
}


@end

