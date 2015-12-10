//
//  UserInfo.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic,copy) NSString * user;
@property (nonatomic,copy) NSString * pwd;

/**
 YES 代表登陆过 /NO 代表 注销
 */
@property (nonatomic,assign) BOOL loginStatus;
+ (UserInfo *)defaultUserInfo;
- (void)saveUserInfoToSandbox;
- (void)loadUserInfoFromSandbox;

@end
