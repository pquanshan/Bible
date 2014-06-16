//
//  ChristChapter.m
//  Bible
//
//  Created by yons on 14-6-2.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "NSString+HTML.h"
#import "ChristChapter.h"

@implementation ChristChapter

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex{
    if((self=[super init])){
        spinePath = theSpinePath;
        title = theTitle;
        chapterIndex = theIndex;
        
		NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:theSpinePath]] encoding:NSUTF8StringEncoding];
		text = [html stringByConvertingHTMLToPlainText];
    }
    return self;
}

- (NSString*)getTitle{
    return title;
}

- (NSString*)getText{
    return text;
}

- (int)getChapterIndex{
    return chapterIndex;
}

@end
