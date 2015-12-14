//
//  XMPPTool.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/13.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPvCardTempModule.h"
#import "XMPPFramework.h"
typedef enum {
    XMPPResultTypeLoginSuccess,// 登录成功
    XMPPResultTypeLoginFailure,// 登录失败
    XMPPResultTypeNetError, // 网络错误
    XMPPResultTypeRegisterSuccess,// 注册成功
    XMPPResultTypeRegisterFailure // 注册失败
}XMPPResultType;
typedef void (^XMPPResultBlock)(XMPPResultType type); // XMPP 请求结果的Block
@interface XMPPTool : NSObject
+ (XMPPTool *)defaultTool;
// 注册标识 YES 代表注册 / NO 代表登录
@property (nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation; // 注册操作
@property (nonatomic,strong)  XMPPRosterCoreDataStorage * rosterStorage; // 花名册数据存储
@property (nonatomic,strong) XMPPvCardTempModule * vCard; // 电子名片
// 登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;

// 注销
- (void)xmppUserLogOut;

// 注册
- (void)xmppUserRegister:(XMPPResultBlock)resultBlock;

@end
