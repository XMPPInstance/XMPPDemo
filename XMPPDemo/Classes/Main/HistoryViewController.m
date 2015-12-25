//
//  HistoryViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/16.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "HistoryViewController.h"
#import "XMPPTool.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation HistoryViewController
- (IBAction)shareBtnClick:(id)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"567cab8367e58e5aa6000e77"
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:nil];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:@"LoginStatusChangeNotification" object:nil];
    
}

- (void)changeStatus:(NSNotification *)noti {
   // 通知是在子线程调用 刷新UI应该在主线程进行
   dispatch_async(dispatch_get_main_queue(), ^{
       NSLog(@"%@",noti.userInfo);
       int status = [noti.userInfo[@"loginStatus"] intValue];
       
       switch (status) {
           case XMPPResultTypeConnecting: // 正在连接
               [self.indicatorView startAnimating];
               break;
           case XMPPResultTypeNetError: // 连接失败
               [self.indicatorView stopAnimating];
               break;
               
           case XMPPResultTypeLoginSuccess: // 登录成功也就是 连接成功
               [self.indicatorView stopAnimating];
               break;
               
           case XMPPResultTypeLoginFailure: // 登录失败
               [self.indicatorView stopAnimating];
               break;
           default:
               break;
       }
   });
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
