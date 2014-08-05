//
//  ChristBibleData.h
//  Bible
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//
#define KCacheCount             (1)

#import <Foundation/Foundation.h>

@interface ChristBibleData : NSObject

@property(assign)BOOL  isbibleAll;//有没有解析成功
@property(atomic)NSArray* unBibleTextArr;//未解析整本圣经
@property(atomic)NSArray* bibleTextArr;//解析后的整本圣经
@property(atomic ,strong) NSMutableDictionary* bibleTextDic;//解析了的章节 目前只缓存KCacheCount章


-(ChristChapterEpub*) getSheetChapter:(int)sheetIndex;//获取一小章的内容
-(NSString*) getSectionText:(int)schapterIndex sectionIndex:(int)sectionIndex;//获取一节的内容

@end
