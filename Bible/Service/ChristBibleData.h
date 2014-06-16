//
//  ChristBibleData.h
//  Bible
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChristBibleData : NSObject

@property(assign)BOOL  isbibleAll;//有没有解析成功
@property(atomic)NSArray* unBibleTextArr;//未解析整本圣经
@property(atomic)NSArray* bibleTextArr;//解析后的整本圣经

@end
