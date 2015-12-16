//
//  ChatCell.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/15.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "ChatCell.h"
#import "WQTMessageFrame.h"
#import "WQTMessage.h"
@interface ChatCell ()
@property (nonatomic,weak) UILabel * timeLab;
@property (nonatomic,weak) UIImageView * iconView;
@property (nonatomic,weak) UIButton * textBtn;
@end


@implementation ChatCell

+ (instancetype)chatCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"MessageCell";
    ChatCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 显示时间的label
        UILabel * timeLab = [[UILabel alloc] init];
        [self.contentView addSubview:timeLab];
        self.timeLab = timeLab;
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = [UIFont systemFontOfSize:13];
        
        
        //icon图标
        UIImageView * iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        //显示文字的UIButton
        UIButton * textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:textBtn];
        self.textBtn = textBtn;
        
        //btn细节调整
        textBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        textBtn.titleLabel.numberOfLines = 0;
        [textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //这里应该设置的是20 而不是40 因为左右是20+20 上下也是20+20;
        textBtn.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return  self;
}

- (void)setMFrame:(WQTMessageFrame *)mFrame
{
    _mFrame = mFrame;
    
    [self setData:mFrame.message];
    
    [self setFrameData:mFrame];
    
}

- (void)setFrameData:(WQTMessageFrame *)mFrame
{
    
    self.timeLab.frame = mFrame.timeFrame;
    self.iconView.frame = mFrame.iconFrame;
    self.textBtn.frame = mFrame.textFrame;
    
}
// 获取日期中的某一天
- (int)dayFromDate:(NSDate *)date {
    NSString * timeStr = [NSString stringWithFormat:@"%@",date];
    NSRange range = [timeStr rangeOfString:@"+"];
    timeStr = [timeStr substringToIndex:range.location];

    timeStr = [timeStr substringFromIndex:5];
    range = [timeStr rangeOfString:@"-"];
    NSUInteger loc = range.location;
    range = NSMakeRange(loc+1, 2);
    NSString * day1Str = [timeStr substringWithRange:range];
    int day1 = [day1Str intValue];
    return day1;
}
// 调整时区差
- (NSDate *)dateToNow:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone ];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

- (void)setData:(WQTMessage *)message
{
    message.time = [self dateToNow:message.time];
    //1.设置内容
    NSString * timeStr = [NSString stringWithFormat:@"%@",message.time];
    NSRange range = [timeStr rangeOfString:@"+"];
    timeStr = [timeStr substringToIndex:range.location];
    
    timeStr = [timeStr substringFromIndex:5];
    
    NSArray * chatTimeArr = [timeStr componentsSeparatedByString:@" "];
    NSString * chatTime = chatTimeArr[chatTimeArr.count -2];
    int day1 = [self dayFromDate:message.time];
    int day2 = [self dayFromDate:[self dateToNow:[NSDate date]]];
    if (day2 - day1 == 0) {
        timeStr = [NSString stringWithFormat:@"今天 %@",chatTime];
    }else if (day2 - day1 == 1) {
        timeStr = [NSString stringWithFormat:@"昨天 %@",chatTime];
    } else if (day2 - day1 == 2){
        timeStr = [NSString stringWithFormat:@"前天 %@",chatTime];
    }
    
    
    self.timeLab.text = timeStr;
    
    //根据type 设置 icon图标
    
    NSString * iconName = [message.type boolValue]== MESSAGETYPEME?@"me":@"other";
    self.iconView.image =  [UIImage imageNamed:iconName];
    
    [self.textBtn setTitle:message.text forState:UIControlStateNormal];
    NSLog(@"%@",message.type);
    if([message.type boolValue] == MESSAGETYPEME)
        [self.textBtn setBackgroundImage:[self resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    else
        [self.textBtn setBackgroundImage:[self resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    
    
}
- (UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
