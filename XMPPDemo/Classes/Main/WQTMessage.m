//
//  WQTMessage.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/15.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "WQTMessage.h"

@implementation WQTMessage
+(instancetype)messageWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"text = %@,time = %@,type = %@ hidden = %d",_text,_time,_type,_hiddenTime];
}
@end
