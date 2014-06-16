//
//  ChristChapterEpub.m
//  Bible
//
//  Created by apple on 14-6-3.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristChapterEpub.h"

@implementation ChristChapterEpub

- (id) initWithPath:(NSString*)text title:(NSString*)theTitle chapterIndex:(int) theIndex{
    if((self=[super init])){
        title = theTitle;
        chapterIndex = theIndex;
        spineDic = [self getSpineArray:text];
    }
    return self;
}

-(NSDictionary*)getSpineArray:(NSString*)text{
    NSMutableDictionary *chapterDic = [[NSMutableDictionary alloc] init];
    NSArray *schapterArr = [text componentsSeparatedByString:@" "];
    if (schapterArr) {
        int schapterIndex = 0;
        int arrCount = schapterArr.count;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < arrCount;++i) {
            NSString* str = [schapterArr objectAtIndex:i];

            if ([self isChapterSection:str] && i+1 < arrCount) {
                NSRange range = [str rangeOfString:@":"];
                int curschapterIndex = [[str substringToIndex:range.location] intValue];
                if (curschapterIndex != schapterIndex) {
                    if (dic !=nil) {
                        [chapterDic setObject:dic forKey:[self getSChapterKey:schapterIndex]];
                    }
                    schapterIndex  = curschapterIndex;
                    dic = [[NSMutableDictionary alloc] init];
                }
                
                if([self isChapterSection:[schapterArr objectAtIndex:i+1]]){
                    [dic setObject:@"" forKey:str];
                }else{
                    [dic setObject:[schapterArr objectAtIndex:i+1] forKey:str];
                    ++i;
                }
            }
        }
        [chapterDic setObject:dic forKey:[self getSChapterKey:schapterIndex]];
    }
    return chapterDic;
}

-(BOOL)isChapterSection:(NSString*)str{
    NSError *error;
    //[\\d+]+:[\\d+] 这是检测章节的正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\d+]+:[\\d+]" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        if (firstMatch) {
            return YES;
        }
    }
    return NO;
}

-(NSString*)getSChapterKey:(int)schapteIndex{
    return [[NSString alloc]initWithFormat:KSmallChapter,schapteIndex];;
}

-(NSString*)getChapterSectionKey:(int)schapteIndex sectionIndex:(int)sectionIndex{
    return [[NSString alloc]initWithFormat:KSChapterSection,schapteIndex,sectionIndex];
}

-(NSDictionary*) getSpineDic{
    return spineDic;
}

-(NSString*) getTitle{
    return [title stringByReplacingOccurrencesOfString:[ChristUtils getStringByInt:[self getChapterIndex]] withString:@""];
}

-(int) getChapterIndex{
    return chapterIndex;
}


-(NSDictionary*) getSamllChapter:(int)schapterIndex{
    return [spineDic objectForKey:[self getSChapterKey:schapterIndex]];
}

-(NSString*) getSectionText:(int)schapterIndex sectionIndex:(int)sectionIndex{
    NSDictionary* dic = [self getSamllChapter:schapterIndex];
    return [dic objectForKey:[self getChapterSectionKey:schapterIndex sectionIndex:sectionIndex]];
}

@end
