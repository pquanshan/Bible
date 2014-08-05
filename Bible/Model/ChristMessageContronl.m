//
//  ChristMessageContronl.m
//  Bible
//
//  Created by yons on 14-8-2.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristMessageContronl.h"
#import "ChristConfig.h"

@implementation ChristMessageContronl
@synthesize messageType = _messageType;
@synthesize messageArray = _messageArray;

-(int)addDelegate:(id)delegate{
    if (_messageArray == nil) {
        _messageArray = [[NSMutableArray alloc]init];
    } else {
        for (id message in _messageArray) {
            if (message == delegate) {
                return _messageArray.count;
            }
        }
    }
    
    [_messageArray addObject:delegate];
    return _messageArray.count;
}

-(int)delDelegate:(id)delegate{
    if (_messageArray) {
        for (id message in _messageArray) {
            if (message == delegate) {
                [_messageArray removeObject:message];
                break;
            }
        }
        
        return _messageArray.count;
    } else {
        return 0;
    }
}

-(BOOL)haveDelegate:(id)delegate{
    BOOL res = NO;
    if (_messageArray) {
        for (id message in _messageArray) {
            if (message == delegate) {
                res = YES;
                break;
            }
        }
    }
    
    return res;
}

-(void)sendMessage:(NSDictionary*)message{
    for (int i = 0; i < _messageArray.count; ++i) {
        id delegate = [_messageArray objectAtIndex:i];
//        [delegate receiveMessage:message];
    }
}

@end
