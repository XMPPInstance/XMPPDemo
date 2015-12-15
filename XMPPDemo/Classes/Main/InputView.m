//
//  InputView.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "InputView.h"

@implementation InputView
+ (instancetype)inputView {
    return [[[NSBundle mainBundle] loadNibNamed:@"InputView" owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
