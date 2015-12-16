//
//  XMPPTool.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/13.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "XMPPTool.h"
extern  NSString * const LoginStatusChangeNotification = @"LoginStatusChangeNotification";
@interface XMPPTool ()<XMPPStreamDelegate> {
    
    XMPPResultBlock _resultBlock;
    XMPPReconnect * _reconnect;
    // 电子名片
    XMPPvCardCoreDataStorage * _vCardStorage; // 电子名片的存储
    
    
    
    XMPPMessageArchiving * _msgArchiving;// 聊天模块
    
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

@implementation XMPPTool

+ (XMPPTool *)defaultTool {
    static XMPPTool * tool = nil;
    if (tool == nil) {
        tool = [[XMPPTool alloc] init];
    }
    return tool;
}

#pragma mark 私有方法
- (void)setUpXMPPStream {
    _xmppStream = [[XMPPStream alloc] init];
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    // 添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    // 激活
    [_vCard activate:_xmppStream];
    // 添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    // 添加花名册模块
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    // 添加聊天模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving activate:_xmppStream];
    
    _xmppStream.enableBackgroundingOnSocket = YES;
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

#pragma mark 释放XMPPStream相关的资源
- (void)tearDownXMPPStream {
    // 移除代理
    [_xmppStream removeDelegate:self];
    // 停止模块
    [_reconnect deactivate];
    [_roster deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_msgArchiving deactivate];
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
    _reconnect = nil;
    _roster = nil;
    _rosterStorage = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
    _xmppStream = nil;
    
}

- (void)connectToHost {
    WCLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setUpXMPPStream];
    }
    // 发送通知 "正在连接"
    [self postNotification:XMPPResultTypeConnecting];
    
    // 设置登录用户JID
    // resource 标识用户登录的客户端 iPhone Android WindowsPhone
    
    
    NSString * user = nil;
    
    if (self.registerOperation) {
        user = [UserInfo defaultUserInfo].registerUser;
    } else {
        user = [UserInfo defaultUserInfo].user;
    }
    
    
    XMPPJID * myJID = [XMPPJID jidWithUser:user domain:@"swkits.com" resource:@"iPhone"];
    _xmppStream.myJID = myJID;
    _xmppStream.hostPort = 5222;
    NSError * error = nil;
    if ([_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        WCLog(@"%@",error);
    }
}

- (void)sendPwdToHost {
    WCLog(@"再发送密码授权");
    NSError * error = nil;
    // 从沙盒获取密码
    NSString * pwd = [UserInfo defaultUserInfo].pwd;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@",error);
    }
}

- (void)sendOnlineToHost {
    //
    WCLog(@"发送在线消息");
    XMPPPresence * presence = [XMPPPresence presence];
    WCLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}
// 定义发送通知的方法
// 通知 HistoryViewController 登陆状态
- (void)postNotification:(XMPPResultType)resultType {
    // 将登陆状态放入字典 然后通过通知传递
    NSDictionary * userInfo = @{@"loginStatus":@(resultType)};
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangeNotification object:nil userInfo:userInfo];
}

#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    WCLog(@"与主机连接成功");
    if (self.isRegisterOperation) {// 注册操作 发送注册的密码
        NSString * pwd = [UserInfo defaultUserInfo].pwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    } else {// 登录操作
        // 主机连接成功后,发送密码进行授权
        [self sendPwdToHost];
    }
    [self postNotification:XMPPResultTypeLoginSuccess];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    
    // 如果有错误,代表连接失败
    
    // 如果没有错误,表示正常的断开连接(人为断开连接)
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetError);
    }
    
    if (error) {
        // 通知网络不稳定
        [self postNotification:XMPPResultTypeNetError];
    }
    
    WCLog(@"与主机断开连接%@",error);
}

#pragma mark 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    WCLog(@"授权成功");
    [self sendOnlineToHost];
    
    // 回调控制器 登录成功
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    [self postNotification:XMPPResultTypeLoginSuccess];
}

#pragma mark 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    WCLog(@"授权失败 %@",error);
    // 判断Block有无值,再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    [self postNotification:XMPPResultTypeLoginFailure];
}

#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    WCLog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
    
}

#pragma mark - 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    WCLog(@"注册失败 %@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

#pragma mark - 接收到好友的消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    WCLog(@"%@",message);
    
    // 如果程序不在前台 发出一个本地通知
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        WCLog(@"在后台");
        // 本地通知
        UILocalNotification * localNoti = [[UILocalNotification alloc] init];
        // 设置通知内容
        localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.fromStr,message.body];
        // 设置通知执行时间
        localNoti.fireDate = [NSDate date];
        // 设置通知声音
        localNoti.soundName = @"default";
        // 执行通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    }
    
    
    
}



#pragma mark 公共方法
- (void)xmppUserLogOut {
    // 1 发送离线消息
    XMPPPresence * offLine = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:offLine];
    // 2 与服务器断开连接
    [_xmppStream disconnect];
    // 3 回到登录界面
//    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController = storyBoard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    // 4 更新用户的登录状态
    [UserInfo defaultUserInfo].loginStatus = NO;
    [[UserInfo defaultUserInfo] saveUserInfoToSandbox];
    
}
// 连接主机 成功后发送密码
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock {
    // 先把Block保存起来
    _resultBlock = resultBlock;
    
    // 如果以前连接过服务,要断开
    //    if (_xmppStream.isConnected) {
    [_xmppStream disconnect];
    //    }
    // 连接主机 成功后发送登录密码
    [self connectToHost];
}

- (void)xmppUserRegister:(XMPPResultBlock)resultBlock {
    // 先把Block保存起来
    _resultBlock = resultBlock;
    
    // 如果以前连接过服务,要断开
    //    if (_xmppStream.isConnected) {
    [_xmppStream disconnect];
    //    }
    // 连接主机 成功后发送注册密码
    [self connectToHost];
}

- (void)dealloc {
    [self tearDownXMPPStream];
}

@end
