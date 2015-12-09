//
//  OtherLoginViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/9.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "OtherLoginViewController.h"
#import "AppDelegate.h"
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
     * 1 把用户名和密码放在沙盒里
     * 2 调用AppDelegate的一个connect 连接服务并登录
     *
     */
    NSString * user = self.userField.text;
    NSString * pwd = self.pwdField.text;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:@"user"];
    [defaults setObject:pwd forKey:@"pwd"];
    [defaults synchronize];
    // 登录之前给个提示
    [MBProgressHUD showMessage:@"正在登录中......"];
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    
    [app xmppUserLogin:^(XMPPResultType type){
        [self handleResultType:type];
    }];
    
    
}

- (void)handleResultType:(XMPPResultType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                [self enterMainPage];
                
                break;
                
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                [MBProgressHUD showError:@"用户名或者密码不正确"];
                break;
            default:
                break;
        }
    });
}

- (void)enterMainPage {
    // 登录成功 来到主界面
    // 此方法是在子线程中调用,应该在主线程中刷新UI
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.view.window.rootViewController = storyBoard.instantiateInitialViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
