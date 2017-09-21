//
//  openfileRequest.h
//  TingYuanBao
//
//  Created by mao ke on 2017/6/12.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>

//成功回调类型:参数: 1. id: object(如果是 JSON ,那么直接解析成OC中的数组或者字典.如果不是JSON ,直接返回 NSData)

typedef void(^SuccessBlock)(NSDictionary *response);

// 失败回调类型:参数: NSError error;

typedef void(^failBlock)(NSString *error);

@interface openfileRequest : NSObject <XMPPRosterDelegate,XMPPRegistrationDelegate,XMPPStreamDelegate>

// 单例的实例化方法
+ (instancetype)sharedNewtWorkTool;

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;
@property (strong, nonatomic) XMPPRoster *xmppRoster;
@property (strong, nonatomic) XMPPRegistration *xmppRegistration;
@property (strong, nonatomic) XMPPIDTracker *xmppIDTracker;
@property (nonatomic , strong) XMPPRosterCoreDataStorage *xmppRosterDataStorage;
@property NSMutableArray *onLineMac;
@property NSString *reciveMessage;
@property NSString *password;
@property NSString *registerBool;
@property NSString *postDataError;
@property NSString *addid;

-(void)connectToHost;
-(void)disconnect;
-(void)sendMessage:(NSString*) mes Mac:(NSString *)whichMac;
-(void)addFriend:(NSString *)friendMac;
-(void)registerWithName:(NSString *)userName andPassword:(NSString *)password;
- (void)changePassworduseWord:(NSString *)checkPassword userName:(NSString *)userName;
@end
