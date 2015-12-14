//
//  UIButton+WF.h
//  XMPPDemo
//
//  Created by Wang Qitai on 15-12-11.
//  Copyright (c) 2015年 WangQitai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WF)

/**
 * 设置普通状态与高亮状态的背景图片
 */
-(void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg;

/**
 * 设置普通状态与高亮状态的拉伸后的背景图片
 */
-(void)setResizedN_BG:(NSString *)nbg H_BG:(NSString *)hbg;
@end
