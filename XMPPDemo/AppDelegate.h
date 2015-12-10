//
//  AppDelegate.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/7.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMPPResultTypeLoginSuccess,// 登录成功
    XMPPResultTypeLoginFailure,// 登录失败
    XMPPResultTypeNetError // 网络错误
}XMPPResultType;
typedef void (^XMPPResultBlock)(XMPPResultType type); // XMPP 请求结果的Block

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// 注册标识 YES 代表注册 / NO 代表登录
@property (nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation; // 注册操作
// 登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;

// 注销
- (void)xmppUserLogOut;

// 注册
- (void)xmppUserRegister:(XMPPResultBlock)resultBlock;
@end

