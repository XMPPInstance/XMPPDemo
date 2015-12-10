//
//  UserInfo.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "UserInfo.h"
#define UserKey @"user"
@implementation UserInfo
+ (UserInfo *)defaultUserInfo {
    static UserInfo * userInfo = nil;
    if (!userInfo) {
        userInfo = [[UserInfo alloc] init];
    }
    return userInfo;
}

- (void)saveUserInfoToSandbox {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.user forKey:UserKey];
    
}

- (void)loadUserInfoFromSandbox {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    self.user = [userDefaults objectForKey:UserKey];
}

@end
