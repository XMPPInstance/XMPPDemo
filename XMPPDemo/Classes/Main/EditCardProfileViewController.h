//
//  EditCardProfileViewController.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditCardProfileViewControllerDelegate <NSObject>

- (void)editProfileViewControllerDidSave;

@end


@interface EditCardProfileViewController : UITableViewController
@property (nonatomic,weak) id<EditCardProfileViewControllerDelegate> delegate;
@property (nonatomic,strong) UITableViewCell * cell;
@end
