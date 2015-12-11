//
//  LoginViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "WCNavigationController.h"
@interface LoginViewController ()<RegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置pwdField和Btn的样式
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
//    UIImageView * lockView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Card_Lock"]];
//    lockView.bounds = CGRectMake(0, 0, 20, 20);
//    self.pwdField.leftView = lockView;
//    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    [self.loginBtn setResizedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
// 设置登录名为上次登录的用户名
    // 从沙盒获取用户名
    NSString * user = [UserInfo defaultUserInfo].user;
    self.userLabel.text = user;



}
- (IBAction)loginBtnClick:(id)sender {
    // 保存数据到单例
    UserInfo * userInfo = [UserInfo defaultUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
    // 调用父类的登录
    [super login];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // 获取注册控制器
    id destVc = segue.destinationViewController;
    
    if ([destVc isKindOfClass:[WCNavigationController class]]) {
        WCNavigationController * nav = destVc;
        // 获取根控制器
        if ([nav.topViewController isKindOfClass:[RegisterViewController class]]) {
            RegisterViewController * registerVc = (RegisterViewController *)nav.topViewController;
            registerVc.delegate = self;
        }
    }

}
#pragma mark registerViewController的代理
- (void)registerViewControllerDidFinishRegister {
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text = [UserInfo defaultUserInfo].registerUser;
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
    
}
@end
