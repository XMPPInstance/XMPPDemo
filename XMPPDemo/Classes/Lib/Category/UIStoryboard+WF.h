//
//  UIStoryboard+WF.h
//  XMPPDemo
//
//  Created by Wang Qitai on 15-12-11.
//  Copyright (c) 2015年 WangQitai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (WF)

/**
 * 1.显示Storybaord的第一个控制器到窗口
 */
+(void)showInitialVCWithName:(NSString *)name;
+(id)initialVCWithName:(NSString *)name;
@end
