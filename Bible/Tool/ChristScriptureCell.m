//
//  ChristScriptureCell.m
//  Bible
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#define KTagChapterLab          (1001)
#define KTagContentLab          (1002)
#define KTagAnnotationBtn       (1003)
#define KTagContentView         (2000)

#define KContentTextItem(i)     ((3000) + (i))


#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristModel.h"
#import "ChristScriptureCell.h"
@interface ChristScriptureCell(){
    int lines;
//    UILabel* linelab;
}
@end

@implementation ChristScriptureCell
@synthesize volumeIndex = _volumeIndex;
@synthesize chapterIndex = _chapterIndex;
@synthesize sectionIndex = _sectionIndex;
@synthesize chaptertext = _chaptertext;
@synthesize contentText = _contentText;
@synthesize isHighlightedtext = _isHighlightedtext;
@synthesize isAnnotation = _isAnnotation;
@synthesize selectText = _selectText;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _isHighlightedtext = NO;
        _isAnnotation = NO;
        lines = 0;
    }
    return self;
}

-(void)setVCSIndex:(int)volume chapter:(int)chapter section:(int)section{
    _volumeIndex = volume;
    _chapterIndex = chapter;
    _sectionIndex = section;
}

- (void)setIsHighlightedtext:(BOOL)isHighlightedtext{
    _isHighlightedtext = isHighlightedtext;
    [self setContentTextColor];
}

-(void)setIsAnnotation:(BOOL)isAnnotation{
    _isAnnotation = isAnnotation;
    UIButton* btn = (UIButton *)[self.contentView viewWithTag:KTagAnnotationBtn];
    if (btn == nil) {
        btn = [ChristUtils buttonWithImg:@"笔记" off:0 image:nil imagesec:nil target:self action:@selector(annotationClick:)];
        btn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        btn.tag = KTagAnnotationBtn;
        [self.contentView addSubview:btn];
    }
    
    CGSize sizeChaptertext = [_chaptertext sizeWithFont:[UIFont fontWithName:@"Arial" size:12]];
    btn.frame = CGRectMake(2*KCellOff + sizeChaptertext.width, 0, btn.frame.size.width, KCellMarkHeight);
    
    if (!_isAnnotation) {//有备注（笔记）
        [btn setTitleColor:RGBCOLOR(200, 200, 200) forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:RGBCOLOR(50, 50, 250) forState:UIControlStateNormal];
    }
}

-(void)setChaptertext:(NSString *)chaptertext{
    if (chaptertext == nil) {
        chaptertext = @"";
        DebugLog(@"数据异常 chaptertext");
    }
    _chaptertext = chaptertext;
    CGSize sizeChaptertext = [_chaptertext sizeWithFont:[UIFont fontWithName:@"Arial" size:12]];
    
    UILabel* label = (UILabel*)[self.contentView viewWithTag:KTagChapterLab];
    if (label == nil) {
        label = [ChristUtils labelWithTxt:_chaptertext
                                    frame:CGRectMake(KCellOff, 0, sizeChaptertext.width + KCellOff, KCellMarkHeight)
                                     font:[UIFont fontWithName:@"Arial" size:12]
                                    color:[UIColor grayColor]];
        label.tag = KTagChapterLab;
        label.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:label];
    }else{
        label.text = _chaptertext;
        label.frame = CGRectMake(KCellOff, 0, sizeChaptertext.width + KCellOff, KCellMarkHeight);
    }
}

-(void)setContentText:(NSString *)contentText{
    if (contentText == nil) {
        contentText = @"";
        DebugLog(@"数据异常 contentText");
    }
    _contentText = contentText;
    lines = 0;
    UIView *contentView = (UIView*)[self.contentView viewWithTag:KTagContentView];
    if (contentView) {
        [contentView removeFromSuperview];
    }
    contentView = [[UIView alloc] initWithFrame:CGRectMake(KCellOff, KCellMarkHeight , self.contentView.frame.size.width - 2 * KCellOff, self.contentView.frame.size.height - KCellMarkHeight)];
    
    contentView.tag = KTagContentView;
    [self.contentView addSubview:contentView];

    NSMutableString* content = [[NSMutableString alloc] init];
    NSMutableString* source = [NSMutableString stringWithString:contentText];
    int height = 0;
    while ([source length] > 0) {
        int width = 0;
        content = [[NSMutableString alloc] init];
        while ([source length] > 0 && width < contentView.frame.size.width - 2 * KCellOff) {
            [content appendString:[source substringToIndex:1]];
            [source deleteCharactersInRange:NSMakeRange(0, 1)];
            
            width = [content sizeWithFont:[[ChristModel shareModel] getBodyTextFont]].width;
            height = [content sizeWithFont:[[ChristModel shareModel] getBodyTextFont]].height;
        }
        
        UILabel* label = [ChristUtils labelWithTxt:content
                                          frame:CGRectMake(0,
                                                           lines * height,
                                                           width,
                                                           height)
                                           font:[[ChristModel shareModel] getBodyTextFont]
                                          color:[[ChristModel shareModel] getBodyTextColor]];
        label.tag = KContentTextItem(lines);
        label.textAlignment = UITextAlignmentLeft;
        [contentView addSubview:label];
        lines++;
    }
}

-(void)setContentTextColor{
    UIView *contentView = (UIView*)[self.contentView viewWithTag:KTagContentView];
    UIColor* color = [[ChristModel shareModel] getBodyTextColor];
    if (_isHighlightedtext) {
        color = [UIColor orangeColor];
    }
    if (lines > 0 && contentView) {
        for (int i = 0; i < lines; ++i) {
            UILabel* lab = (UILabel*)[contentView viewWithTag:(KContentTextItem(i))];
            if (lab) {
                lab.textColor = color;
            }
        }
    }
}

-(void)annotationClick:(id)sender{
    if (![SysDelegate.viewHome isMenuOpening]) {
        NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
        [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeNotesEditor] forKey:KViewPageType];
        [mtDic setObject:[ChristUtils getStringByInt:_volumeIndex] forKey:KUserSaveVolume];
        [mtDic setObject:[ChristUtils getStringByInt:_chapterIndex] forKey:KUserSaveChapter];
        [mtDic setObject:[ChristUtils getStringByInt:_sectionIndex] forKey:KUserSaveSection];
        [mtDic setObject:_contentText forKey:KNotesContentText];
        [SysDelegate.viewHome switchPage:self dic:mtDic  animationType:kCATransitionFromTop];
    }
}

@end
