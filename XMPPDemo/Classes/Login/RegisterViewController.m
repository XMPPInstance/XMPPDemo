//
//  RegisterViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)registerBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 判断当前设备的类型 改变当前左右两边约束的距离
    self.title = @"注册";
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftContraint.constant = 10;
        self.rightContraint.constant = 10;
    }
    
    // 设置textField背景
    
    //    self.userField.background = [UIImage imageNamed:@"operationbox_text"];
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.registerBtn setResizedN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
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

- (IBAction)registerBtnClick:(id)sender {
    // 1 把用户注册的数据保存单例
    UserInfo * userInfo = [UserInfo defaultUserInfo];
    userInfo.registerUser = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;
    // 2 调用AppDelegate的xmppUserRegister
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    app.registerOperation = YES;
    [app xmppUserRegister:^(XMPPResultType type) {
        
    }];
    
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
