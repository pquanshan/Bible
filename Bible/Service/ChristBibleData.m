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
#import "ChristUtils.h"
#import "ChristModel.h"

@implementation ChristBibleData

@synthesize unBibleTextArr = _unBibleTextArr;
@synthesize bibleTextArr= _bibleTextArr;
@synthesize isbibleAll = _isbibleAll;

@synthesize bibleTextDic = _bibleTextDic;

-(id)init{
    _isbibleAll = NO;
    _bibleTextDic = [[NSMutableDictionary alloc] init];
    
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

-(ChristChapterEpub*) getSheetChapter:(int)sheetIndex{
    ChristChapterEpub* chapterText = [_bibleTextDic objectForKey:[ChristUtils getNumberByInt:sheetIndex]];
    if (chapterText) {
//        [];
        
    }else{
        //开始解析了
        [self parsBible:sheetIndex];
    }
    return chapterText;
}

-(void) parsBible:(int)sheetIndex{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DebugLog(@"--------圣经解析 第%d章",sheetIndex);
        ChristChapter* chapter = [_unBibleTextArr objectAtIndex:sheetIndex];
        ChristChapterEpub* chapterText = [[ChristChapterEpub alloc] initWithPath:[chapter getText] title:[chapter getTitle] chapterIndex:[chapter getChapterIndex]];
        dispatch_async(dispatch_get_main_queue(), ^{//已经抛向主线程中了
            DebugLog(@"--------圣经解析完成");
            [self addBibleTextDic:chapterText sheetIndex:sheetIndex];
            
            //发送通知 数据解析成功
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[NSNumber numberWithInt:ChristEupdParsSuccessful] forKey:KType];
            [[NSNotificationCenter defaultCenter] postNotificationName:KServiceBack
                                                                object:[[ChristModel shareModel]getMeesageDic:dic type:ChristEupdParsing]];
            
        });
    });
}

-(void)addBibleTextDic:(ChristChapterEpub*)chapterText sheetIndex:(int)sheetIndex{
    if (chapterText && sheetIndex > 0  && sheetIndex < KBibleVolumeNumber) {
        if (_bibleTextDic.count >= KCacheCount) {
            [self delBibleTextDic:sheetIndex isAdjacent:YES];
        }
        [_bibleTextDic setObject:chapterText forKey:[ChristUtils getNumberByInt:sheetIndex]];
    }
}

-(void)delBibleTextDic:(int)sheetIndex isAdjacent:(BOOL)isAdjacent{
    if (isAdjacent) {
        NSArray* arr = [_bibleTextDic allKeys];
        NSNumber* delNumber = [NSNumber numberWithInt:0];
        int adjacent = 0;
        for (NSNumber* number in arr) {
            if (abs(sheetIndex - [number intValue]) > adjacent) {
                delNumber = number;
                adjacent = abs(sheetIndex - [number intValue]);
            }
        }
        [_bibleTextDic removeObjectForKey:delNumber];
    }else{
        [_bibleTextDic removeObjectForKey:[ChristUtils getNumberByInt:sheetIndex]];
    }
}


//-(NSString*) getSectionText:(int)schapterIndex sectionIndex:(int)sectionIndex{
//    
//}


@end
