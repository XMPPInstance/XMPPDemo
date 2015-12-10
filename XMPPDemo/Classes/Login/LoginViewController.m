//
//  LoginViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
