//
//  CGNetworkQueue.m
//  CGAVPlayerDemo
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 wolf. All rights reserved.
//

#import "CGNetworkQueue.h"

@implementation CGNetworkQueue

+ (instancetype)sharedSingle {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ASINetworkQueue alloc] init];
        [_instance reset];
        [_instance setShowAccurateProgress:YES];
        [_instance go];
    });
    return _instance;
}

@end
