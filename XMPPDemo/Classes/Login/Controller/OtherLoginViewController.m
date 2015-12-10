//
//  OtherLoginViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/9.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "OtherLoginViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
@interface OtherLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;

@property (weak, nonatomic) IBOutlet UITextField *userField;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation OtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 判断当前设备的类型 改变当前左右两边约束的距离
    self.title = @"其他方式登录";
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftContraint.constant = 10;
        self.rightContraint.constant = 10;
    }
    
    // 设置textField背景
    
//    self.userField.background = [UIImage imageNamed:@"operationbox_text"];
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.loginBtn setResizedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
}

- (IBAction)loginBtnClick {
    // 登录
    /*官方的登录实现
     * 1 把用户名和密码放在User单例里
     * 2 调用AppDelegate的一个connect 连接服务并登录
     *
     */
    
    UserInfo * userInfo = [UserInfo defaultUserInfo];
    userInfo.user = self.userField.text;
    userInfo.pwd = self.pwdField.text;
    [super login];
    
}
- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"dealloc");
}
@end
