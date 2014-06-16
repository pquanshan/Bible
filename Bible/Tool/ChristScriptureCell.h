//
//  ChristScriptureCell.h
//  Bible
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristConfig.h"
#import <UIKit/UIKit.h>

@interface ChristScriptureCell : UITableViewCell

@property (nonatomic) int volumeIndex;
@property (nonatomic) int chapterIndex;
@property (nonatomic) int sectionIndex;
@property (nonatomic,strong) NSString* chaptertext;//章节文本
@property (nonatomic,strong) NSString* contentText;//内容文本
@property (nonatomic) BOOL isHighlightedtext;//文本是否高亮
@property (nonatomic) BOOL isAnnotation;//有没有注释按钮（笔记）
@property (nonatomic,strong) NSString* selectText;//搜索选择文本需要加黑加粗显示

-(void)setVCSIndex:(int)volume chapter:(int)chapter section:(int)section;

@end
