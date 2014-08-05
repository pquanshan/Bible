//
//  ChristChapterEpub.h
//  Bible
//  一个书卷的所有内容
//  Created by apple on 14-6-3.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChristChapterEpub : NSObject{
    NSString* title;//标题
    int chapterIndex;//在ChristEpub位置
    NSDictionary* spineDic;//小章内容数组
}

- (id) initWithPath:(NSString*)text title:(NSString*)theTitle chapterIndex:(int) theIndex;

-(NSDictionary*) getSpineDic;
-(NSString*) getTitle;
-(int) getChapterIndex;

-(NSDictionary*) getSamllChapter:(int)schapterIndex;//获取一小章的内容
-(NSString*) getSectionText:(int)schapterIndex sectionIndex:(int)sectionIndex;//获取一节的内容

@end
