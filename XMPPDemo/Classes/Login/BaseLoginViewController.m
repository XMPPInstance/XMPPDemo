//
//  BaseLoginViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "BaseLoginViewController.h"
#import "AppDelegate.h"
@interface BaseLoginViewController ()

@end

@implementation BaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)login {
    // 登录
    /*官方的登录实现
     * 1 把用户名和密码放在User单例里
     * 2 调用AppDelegate的一个connect 连接服务并登录
     *
     */
  
    // 隐藏键盘
    [self.view endEditing:YES];
    
    // 登录之前给个提示
    [MBProgressHUD showMessage:@"正在登录中......" toView:self.view];

    [XMPPTool defaultTool].registerOperation = NO;
    __weak typeof(self) selfWeak = self;
    [[XMPPTool defaultTool] xmppUserLogin:^(XMPPResultType type){
        [selfWeak handleResultType:type];
    }];
}


//- (IBAction)loginBtnClick {
//    // 登录
//    /*官方的登录实现
//     * 1 把用户名和密码放在沙盒里
//     * 2 调用AppDelegate的一个connect 连接服务并登录
//     *
//     */
//    NSString * user = self.userField.text;
//    NSString * pwd = self.pwdField.text;
//
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:user forKey:@"user"];
//    [defaults setObject:pwd forKey:@"pwd"];
//    [defaults synchronize];
//
//    [self.view endEditing:YES];
//
//    // 登录之前给个提示
//    [MBProgressHUD showMessage:@"正在登录中......" toView:self.view];
//    AppDelegate * app = [UIApplication sharedApplication].delegate;
//    __weak typeof(self) selfWeak = self;
//    [app xmppUserLogin:^(XMPPResultType type){
//        [selfWeak handleResultType:type];
//    }];
//
//
//}

- (void)handleResultType:(XMPPResultType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                [self enterMainPage];
                
                break;
                
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                [MBProgressHUD showError:@"用户名或者密码不正确" toView:self.view];
                break;
                
            case XMPPResultTypeNetError:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                
            default:
                break;
        }
    });
}

- (void)enterMainPage {
    [UserInfo defaultUserInfo].loginStatus = YES;
    
    // 把用户登录成功的数据,保存到沙盒
    [[UserInfo defaultUserInfo] saveUserInfoToSandbox];
    
    // 隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    // 登录成功 来到主界面
    // 此方法是在子线程中调用,应该在主线程中刷新UI
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyBoard.instantiateInitialViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
