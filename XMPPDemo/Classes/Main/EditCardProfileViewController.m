//
//  EditCardProfileViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "EditCardProfileViewController.h"
#import "XMPPvCardTemp.h"
@interface EditCardProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation EditCardProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.cell.textLabel.text;
    self.textField.text = self.cell.detailTextLabel.text;

    // 右边添加个按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    
}

- (void)saveBtnClick {
    // 1 更改cell的detailTextLabel的text
    self.cell.detailTextLabel.text = self.textField.text;
    [self.cell layoutSubviews];
    // 2 当前的控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
//    XMPPvCardTemp * myVCard = [XMPPTool defaultTool].vCard.myvCardTemp;
//    myVCard.nickname = self.textField.text;
//
    if ([self.delegate respondsToSelector:@selector(editProfileViewControllerDidSave)]) {
//       通知代理 点击了保存按钮
        [self.delegate editProfileViewControllerDidSave];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
