//
//  ChristMessageContronl.h
//  Bible
//
//  Created by yons on 14-8-2.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristModel.h"
#import <Foundation/Foundation.h>

@interface ChristMessageContronl : NSObject

@property(assign)ChristMessageType messageType;
@property(atomic, strong)NSMutableArray* messageArray;

-(int)addDelegate:(id)delegate;
-(int)delDelegate:(id)delegate;

-(BOOL)haveDelegate:(id)delegate;
-(void)sendMessage:(NSDictionary*)message;

@end
