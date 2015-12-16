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
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "APService.h"
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
    
    // Required

        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 
                                                 
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)

             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)

             // Required
             categories:nil];
        }
    [APService setupWithOption:launchOptions];
    
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",path);
    
    //打开XMPP的日志
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [WCNavigationController setupNavTheme];
    // 从沙盒里加载用户的数据到单例
    [[UserInfo defaultUserInfo] loadUserInfoFromSandbox];
    // 判断用户的登录状态,YES 直接来到主界面
    if ([UserInfo defaultUserInfo].loginStatus) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyBoard.instantiateInitialViewController;
        // 自动登录服务器
        // 1 秒后自动登录
#pragma mark 不立即连接 稍微等一下
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [[XMPPTool defaultTool] xmppUserLogin:nil];
        });
    }
    
    // 注册应用接收通知
    // 大于iOS8.0 才需要 注册通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0) {
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
