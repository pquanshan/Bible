//
//  ChristBibleData.m
//  Bible
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristEpub.h"
#import "ChristChapter.h"
#import "ChristChapterEpub.h"
#import "ChristBibleData.h"
#import "ChristConfig.h"

@implementation ChristBibleData

@synthesize unBibleTextArr = _unBibleTextArr;
@synthesize bibleTextArr= _bibleTextArr;
@synthesize isbibleAll = _isbibleAll;

-(id)init{
    _isbibleAll = NO;
    DebugLog(@"--------AAAAA圣经解析开始");
    NSURL* urlpahe = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"biblebook" ofType:@"epub"]];
    ChristEpub *epud = [[ChristEpub alloc] initWithEPubPath:[urlpahe path]];//能得到所有的文本内容
    DebugLog(@"--------AAAAA圣经解析结束");
    _unBibleTextArr = epud.spineArray;
    if (_unBibleTextArr && _unBibleTextArr.count == KBibleVolumeNumber ) {
        NSMutableArray* bible = [[NSMutableArray alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             DebugLog(@"--------圣经解析开始");
            for (int i = 0; i < KBibleVolumeNumber; ++i) {
                ChristChapter* chapter = [_unBibleTextArr objectAtIndex:i];
                ChristChapterEpub* chapterText = [[ChristChapterEpub alloc] initWithPath:[chapter getText] title:[chapter getTitle] chapterIndex:[chapter getChapterIndex]];
                [bible addObject:chapterText];
                DebugLog(@"--------圣经解析 第%d章",i);
            }
            _bibleTextArr = [[NSArray alloc] initWithArray:bible];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_bibleTextArr && _bibleTextArr.count == KBibleVolumeNumber) {
                     _isbibleAll = YES;
                    DebugLog(@"--------圣经解析完成");
                }else{
                    DebugLog(@"--------圣经解析错误");
                }
               
            });
        });
    }

    return self;
}

@end
