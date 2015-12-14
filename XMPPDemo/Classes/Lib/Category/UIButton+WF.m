//
//  UIButton+WF.m
//  XMPPDemo
//
//  Created by Wang Qitai on 15-12-11.
//  Copyright (c) 2015年 WangQitai. All rights reserved.
//

#import "UIButton+WF.h"

@implementation UIButton (WF)

-(void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg{
    [self setBackgroundImage:[UIImage imageNamed:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:hbg] forState:UIControlStateHighlighted];
}


- (void)setResizedN_BG:(NSString *)nbg H_BG:(NSString *)hbg {
    [self setBackgroundImage:[UIImage stretchedImageWithName:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage stretchedImageWithName:hbg] forState:UIControlStateHighlighted];
}
@end
