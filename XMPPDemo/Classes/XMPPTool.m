//
//  XMPPTool.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/13.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "XMPPTool.h"

@interface XMPPTool ()<XMPPStreamDelegate> {
    XMPPStream * _xmppStream;
    XMPPResultBlock _resultBlock;
    // 电子名片
   
    XMPPvCardCoreDataStorage * _vCardStorage; // 电子名片的存储
    
    XMPPvCardAvatarModule * _avatar; // 电子名片的头像
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
    // 添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    // 激活
    [_vCard activate:_xmppStream];
    // 添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

- (void)connectToHost {
    WCLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setUpXMPPStream];
    }
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
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    
    // 如果有错误,代表连接失败
    
    // 如果没有错误,表示正常的断开连接(人为断开连接)
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetError);
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
    
}

#pragma mark 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    WCLog(@"授权失败 %@",error);
    // 判断Block有无值,再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
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

@end
