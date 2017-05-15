//
//  AppDelegate.h
//  huyubao
//
//  Created by mao ke on 2017/4/19.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMPPFramework/XMPPFramework.h>
#import "AFNetworking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPRosterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;

+(AppDelegate *)instance;
-(void)connectToHost;
-(void)disconnect;
-(void)sendMessage:(NSString*) mes Mac:(NSString *)whichMac;
-(void)postToData:(NSString *)post;

@end

