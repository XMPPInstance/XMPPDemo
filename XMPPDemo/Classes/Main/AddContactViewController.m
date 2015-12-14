//
//  AddContactViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()<UITextFieldDelegate>

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 添加好友
    
    // 1 获取好友账号
    NSString * user = textField.text;
    WCLog(@"%@",user);
   // 判断这个账号是否为手机号
//    if (![textField isTelphoneNum]) {
//        // 提示
//        
//        [self showAlert:@"请输入正确的手机号码"];
//        
//        return YES;
//    }
    
    // 判断是否添加自己
    if ([user isEqualToString:[UserInfo defaultUserInfo].user]) {
        [self showAlert:@"不能添加自己为好友"];
        return YES;
    }
    
     // 2 发送好友添加的请求
    // 添加好友 XMPP有个叫订阅
    NSString * jidStr = [NSString stringWithFormat:@"%@@%@",user,domain];
    XMPPJID * friendJid = [XMPPJID jidWithString:jidStr];
    
    
    if ([[XMPPTool defaultTool].rosterStorage userExistsWithJID:friendJid xmppStream:[XMPPTool defaultTool].xmppStream]) {
        [self showAlert:@"当前好友已经存在"];
        return YES;
    }
    
    
    [[XMPPTool defaultTool].roster subscribePresenceToUser:friendJid];
    
    return YES;
}

- (void)showAlert:(NSString *)msg {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}


@end
