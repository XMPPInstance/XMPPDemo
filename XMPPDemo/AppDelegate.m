//
//  AppDelegate.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/7.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPP.h"
/*
 // 在appDelegate中实现登录
 
 1 初始化XMPPStream
 2 连接到服务器(传一个JID)
 3 连接到服务成功后,再发送密码授权
 4 授权成功后,再发送在线消息
 */
@interface AppDelegate ()<XMPPStreamDelegate> {
    XMPPStream * _xmppStream;
}
// 1 初始化XMPPStream
- (void)setUpXMPPStream;
// 2 连接到服务器(传一个JID)
- (void)connectToHost;
// 3 连接到服务成功后,再发送密码授权
- (void)sendPwdToHost;
// 4 授权成功后,再发送在线消息
- (void)sendOnlineToHost;
@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self connectToHost];
    return YES;
}
#pragma mark 私有方法
- (void)setUpXMPPStream {
    _xmppStream = [[XMPPStream alloc] init];
  
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

- (void)connectToHost {
    if (!_xmppStream) {
        [self setUpXMPPStream];
    }
    
    
    // 设置登录用户JID
    // resource 标识用户登录的客户端 iPhone Android WindowsPhone
    XMPPJID * myJID = [XMPPJID jidWithUser:@"lisi" domain:@"teacher.local" resource:@"iPhone"];
    _xmppStream.myJID = myJID;
    _xmppStream.hostPort = 5222;
    NSError * error = nil;
    if ([_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"%@",error);
    }
}

- (void)sendPwdToHost {
    NSLog(@"再发送密码授权");
    NSError * error = nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}

- (void)sendOnlineToHost {
    //
    NSLog(@"发送在线消息");
    XMPPPresence * presence = [XMPPPresence presence];
    NSLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}

#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"与主机连接成功");
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    // 如果有错误,代表连接失败
    NSLog(@"与主机断开连接%@",error);
}

#pragma mark 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"授权成功");
    [self sendOnlineToHost];
}

#pragma mark 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"授权失败 %@",error);
}

#pragma mark 公共方法
- (void)logOut {
    // 1 发送离线消息
    XMPPPresence * offLine = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:offLine];
    // 2 与服务器断开连接
    [_xmppStream disconnect];
}
@end
