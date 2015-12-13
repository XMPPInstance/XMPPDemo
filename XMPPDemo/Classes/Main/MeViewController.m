//
//  MeViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import "MeViewController.h"
#import "XMPPTool.h"
#import "XMPPvCardTemp.h"
@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatNumLabel;

- (IBAction)logOutBtnClick:(id)sender;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    XMPPvCardTemp * myVCard = [XMPPTool defaultTool].vCard.myvCardTemp;
    if (myVCard.photo) {
        self.headerView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    self.nickNameLabel.text = myVCard.nickname;
    
    NSString * user = [UserInfo defaultUserInfo].user;
    self.weChatNumLabel.text = [NSString stringWithFormat:@"微信号:%@",user];
    
}



- (IBAction)logOutBtnClick:(id)sender {
//    AppDelegate * app = [UIApplication sharedApplication].delegate;
    [[XMPPTool defaultTool] xmppUserLogOut];

}
@end
