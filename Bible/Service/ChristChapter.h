//
//  ChristChapter.h
//  Bible
//
//  Created by yons on 14-6-2.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChristChapter : NSObject{
    NSString* spinePath;
    NSString* title;
	NSString* text;
    int pageCount;
    int chapterIndex;
    CGRect windowSize;
    int fontPercentSize;
}


- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex;
- (NSString*)getTitle;
- (NSString*)getText;
- (int)getChapterIndex;

@end
