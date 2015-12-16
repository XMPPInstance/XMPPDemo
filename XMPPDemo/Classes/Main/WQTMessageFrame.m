//
//  WQTMessageFrame.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/15.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "WQTMessageFrame.h"
#import "WQTMessage.h"
@implementation WQTMessageFrame
- (void)setMessage:(WQTMessage *)message
{
    _message = message;
    
    CGRect sFrame = [UIScreen mainScreen].bounds;
    if (message.isHiddenTime == NO)
    {
        //1.labFrame
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeH = 30;
        CGFloat timeW = sFrame.size.width;
        self.timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    //        self.timeFrame = CGRectZero;
    
    //2.设置头像Frame
    CGFloat padding = 15;
    CGFloat iconH = 40;
    CGFloat iconW = 40;
    CGFloat iconX = 0;
   
    
    if ([message.type boolValue]== MESSAGETYPEOTHER)
        iconX = padding;
    else
        iconX = sFrame.size.width - padding - iconW;
    
    CGFloat iconY = CGRectGetMaxY(self.timeFrame);
    
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //3.设置文字button的Frame
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize size = [message.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:dict
                                             context:nil].size;
    CGFloat tmp = 40;
    
    CGFloat textH = size.height + tmp;
    CGFloat textW = size.width  + tmp;
    
    CGFloat textX = 0;
    if ([message.type boolValue]== MESSAGETYPEOTHER)
        textX = CGRectGetMidX(self.iconFrame) + padding*2;
    else
        textX = sFrame.size.width - padding*2 - iconW - size.width - tmp;
    CGFloat textY = iconY;
    
    self.textFrame = CGRectMake(textX, textY, textW, textH);
    
    //4.设置cell高度
    CGFloat textMaxY = CGRectGetMaxY(self.textFrame);
    CGFloat iconMaxY = CGRectGetMaxY(self.iconFrame);
    
    //cell还得加一个padding 要不然不现实时间的时候两条数据头像离的太近了
    self.cellHeight = MAX(textMaxY, iconMaxY) + padding;
    
}
@end
