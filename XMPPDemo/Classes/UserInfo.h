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
+ (UserInfo *)defaultUserInfo;
- (void)saveUserInfoToSandbox;
- (void)loadUserInfoFromSandbox;

@end
