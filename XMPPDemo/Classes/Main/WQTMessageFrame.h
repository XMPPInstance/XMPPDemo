//
//  WQTMessageFrame.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/15.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WQTMessage;
@interface WQTMessageFrame : NSObject


@property (nonatomic,assign) CGRect timeFrame;

@property (nonatomic,assign) CGRect iconFrame;

@property (nonatomic,assign) CGRect textFrame;

@property (nonatomic,assign) CGFloat cellHeight;


@property (nonatomic,strong)WQTMessage * message;

+(instancetype)messageWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
