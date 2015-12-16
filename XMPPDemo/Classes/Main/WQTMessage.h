//
//  WQTMessage.h
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/15.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    MESSAGETYPEOTHER,
    MESSAGETYPEME,
}MESSAGETYPE;
@interface WQTMessage : NSObject
/**
 *
 */
@property (nonatomic,copy)NSString * text;

@property (nonatomic,copy)NSDate * time;

@property (nonatomic,assign)NSString * type;

@property(nonatomic,assign,getter=isHiddenTime)BOOL hiddenTime;


+(instancetype)messageWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
