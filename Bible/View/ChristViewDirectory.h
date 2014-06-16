//
//  ChristViewDirectory.h
//  Bible
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristViewBase.h"
#import "ChristEpub.h"
#import "ChristChapter.h"
#import "ChristChapterEpub.h"
#import <UIKit/UIKit.h>

@interface ChristViewDirectory : ChristViewBase

@property(nonatomic,strong) UIScrollView*  volumeView;//书卷
@property(nonatomic,strong) UIScrollView*  chapterView;//章

@end
