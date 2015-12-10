//
//  RegisterViewController.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/10.
//  Copyright (c) 2015年 QianFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RegisterViewController.h"

@protocol RegisterViewControllerDelegate <NSObject>
// 完成注册
- (void)registerViewControllerDidFinishRegister;

@end
@interface RegisterViewController : UIViewController
@property (nonatomic,assign) id<RegisterViewControllerDelegate> delegate;
@end
