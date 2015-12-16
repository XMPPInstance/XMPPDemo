//
//  ChatCell.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/15.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQTMessage;
@class WQTMessageFrame;
@interface ChatCell : UITableViewCell
@property (nonatomic,strong) WQTMessageFrame * mFrame;
+ (instancetype)chatCellWithTableView:(UITableView *)tableView;

@end
