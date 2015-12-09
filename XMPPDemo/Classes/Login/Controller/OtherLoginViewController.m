//
//  OtherLoginViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/9.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "OtherLoginViewController.h"

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
