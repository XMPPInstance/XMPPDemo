//
//  CategoryWF.h
//  XMPPDemo
//
//  Created by Wang Qitai on 15-12-11.
//  Copyright (c) 2015年 WangQitai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpToolProgressBlock)(CGFloat progress);
typedef void (^HttpToolCompletionBlock)(NSError *error);



@interface HttpTool : NSObject

-(void)uploadData:(NSData *)data
              url:(NSURL *)url
    progressBlock : (HttpToolProgressBlock)progressBlock
            completion:(HttpToolCompletionBlock) completionBlock;

/**
 下载数据
 */
-(void)downLoadFromURL:(NSURL *)url
        progressBlock : (HttpToolProgressBlock)progressBlock
            completion:(HttpToolCompletionBlock) completionBlock;


-(NSString *)fileSavePath:(NSString *)fileName;

@end
