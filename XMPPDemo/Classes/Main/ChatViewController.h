//
//  ChatViewController.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"
#import "HttpTool.h"
@interface ChatViewController : UIViewController
@property (nonatomic,strong) XMPPJID * friendJid;
@property (nonatomic,strong) HttpTool * httpTool;
@end
