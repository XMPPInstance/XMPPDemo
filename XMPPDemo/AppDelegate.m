//
//  AppDelegate.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/7.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPP.h"
#import "WCNavigationController.h"

/*
 // 在appDelegate中实现登录
 
 1 初始化XMPPStream
 2 连接到服务器(传一个JID)
 3 连接到服务成功后,再发送密码授权
 4 授权成功后,再发送在线消息
 */

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self connectToHost];
    [WCNavigationController setupNavTheme];
    // 从沙盒里加载用户的数据到单例
    [[UserInfo defaultUserInfo] loadUserInfoFromSandbox];
    // 判断用户的登录状态,YES 直接来到主界面
    if ([UserInfo defaultUserInfo].loginStatus) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyBoard.instantiateInitialViewController;
        // 自动登录服务器
        [[XMPPTool defaultTool] xmppUserLogin:nil];
    
    }
    return YES;
}

@end
