//
//  ChristViewScripture.m
//  Bible
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristModel.h"
#import "ChristConfig.h"
#import "ChristTextEditBar.h"
#import "ChristViewScripture.h"
#import "ChristScriptureCell.h"

#import "ChristChapter.h"
#import "ChristChapterEpub.h"
#import "ChristManagedNotes.h"

@interface ChristViewScripture(){
    ChristChapterEpub *volumeNext;//显示的书卷
    NSArray* notsArr;
    
    //书卷、章、节
    int volumeIndex;
    int chapterIndex;
    int sectionIndex;
    int chapterCount;//某书卷的章节个数
    int sectionCount;//某章节的节个数
    
    UIButton* titleButton;
    UIButton* nextButton;
    UIButton* prevButton;
}

@property(nonatomic,strong)UIView* navigationView;
@property(nonatomic,strong)ChristTextEditBar* quickSetBar;
@property(nonatomic,strong)ChristTextEditBar* quickEditBar;


@end

@implementation ChristViewScripture
@synthesize delegate = _delegate;
@synthesize quickSetBar = _quickSetBar;
@synthesize quickEditBar = _quickEditBar;
@synthesize navigationView = _navigationView;
@synthesize tableView = _tableView;
@synthesize rightSwipeRecognizer = _rightSwipeRecognizer;
@synthesize leftSwipeRecognizer = _leftSwipeRecognizer;
@synthesize singleRecognizer = _singleRecognizer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:RGBCOLOR(220,230,210)];
        _delegate = SysDelegate.viewHome;
        [self setupGestures];
        [self initTableView];
        [self initNavigation];
        [self initEditBar];
        [self initNextPrevBtn];
        
        NSString* volumestr = [ChristUtils getDataByKey:KUserSaveVolume];
        NSString* chapterstr = [ChristUtils getDataByKey:KUserSaveChapter];
        if (volumestr && chapterstr) {
            volumeIndex = [volumestr intValue];
            chapterIndex = [chapterstr intValue];
        }else{
            volumeIndex = 1;
            chapterIndex = 1;
        }
        
        sectionIndex = 0;
        if ([[ChristModel shareModel] getBibleParsState]) {//圣经解析完成
            volumeNext = [[ChristModel shareModel] getBibleVolumeIndex:volumeIndex];
            chapterCount = [[volumeNext getSpineDic] count];
            sectionCount = [[volumeNext getSamllChapter:chapterIndex] count];
        }else{//自己解析当前的要显示页面内容
            [self getChristChapterVolume];
        }
        notsArr = [[[ChristModel shareModel] getNatesData] findData:[ChristUtils getNumberByInt:volumeIndex] chapterIndex:[ChristUtils getNumberByInt:chapterIndex]];
        [_tableView reloadData];
        [self setNavigationTitle];
    }
    return self;
}

-(void)viewAppear{
    NSString* volume = [ChristUtils getDataByKey:KUserSaveVolume];
    NSString* chapter = [ChristUtils getDataByKey:KUserSaveChapter];
    if (volume && chapter) {
        [self setEpubData:[volume intValue] cindex:[chapter intValue]];
    }else{
        [self setEpubData:1 cindex:1];
    }
}

#pragma mark - init
-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, self.frame.size.height - KStatusBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[[ChristModel shareModel] getBodyBackColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:_tableView];
}

-(void)initNavigation{
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, KNavigationHeight)];
    [_navigationView setBackgroundColor:[[ChristModel shareModel] getNavBackColor]];
    
    UIButton* menuButton = [ChristUtils buttonWithImg:@"菜单" off:0 image:nil imagesec:nil target:self action:@selector(menuButtonClick:)];
    [titleButton setTitleColor:[[ChristModel shareModel] getNavTitleTextColor] forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(KCellOff, 0, menuButton.frame.size.width, KNavigationHeight);
    [_navigationView addSubview:menuButton];
    
    titleButton = [ChristUtils buttonWithImg:@"                     " off:0 image:nil imagesec:nil target:self action:@selector(titleButtonClick:)];
    [titleButton setTitleColor:[[ChristModel shareModel] getNavTitleTextColor] forState:UIControlStateNormal];
    [_navigationView addSubview:titleButton];
    titleButton.center = CGPointMake(_navigationView.center.x, _navigationView.center.y - KStatusBarHeight);
    
    [_navigationView setHidden:YES];
    [self addSubview:_navigationView];
    
    //添加无效手势，禁用home页响应
    [ChristUtils disableGestures:_navigationView];


}

- (void)initNextPrevBtn{
    UIImage * previmg = [UIImage imageNamed:@"prev_chapter.png"];
    prevButton = [ChristUtils buttonWithImg:nil off:0 image:previmg imagesec:[UIImage imageNamed:@"prev_chapter_on.png"] target:self action:@selector(prevButtonClick:)];
    prevButton.frame = CGRectMake(0, self.frame.size.height/2 - previmg.size.height/2, previmg.size.width, previmg.size.height);
    [prevButton addTarget:self action:@selector(prevButtonEnter:) forControlEvents:UIControlEventTouchDragExit];
    [self addSubview:prevButton];
    
    UIImage * nextimg = [UIImage imageNamed:@"next_chapter.png"];
    nextButton = [ChristUtils buttonWithImg:nil off:0 image:nextimg imagesec:[UIImage imageNamed:@"next_chapter_on.png"] target:self action:@selector(nextButtonClick:)];
    nextButton.frame = CGRectMake(self.frame.size.width - nextimg.size.width, self.frame.size.height/2 - nextimg.size.height/2, nextimg.size.width, nextimg.size.height);
    [self addSubview:nextButton];
    
    [self setNextPrevBtnHide:YES];
}

-(void)initEditBar{
    if (_quickSetBar == nil) {
        _quickSetBar = [[ChristTextEditBar alloc]initWithFrame:CGRectMake(0, self.frame.size.height - KDefaultHeight, self.frame.size.width, KDefaultHeight)];
        NSMutableDictionary* resdic = LOADDIC(@"christ", @"plist");
        [_quickSetBar setBtnArr:[resdic objectForKey:KPQuickSetMenu]];
        [_quickSetBar setBackgroundColor:[[ChristModel shareModel] getNavBackColor]];
        [self addSubview:_quickSetBar];
        [_quickSetBar setHidden:YES];
    }
    
    if (_quickEditBar == nil) {
        _quickEditBar = [[ChristTextEditBar alloc]initWithFrame:CGRectMake(0, self.frame.size.height - KTabButtonHeight1, self.frame.size.width, KTabButtonHeight1)];
        NSMutableDictionary* resdic = LOADDIC(@"christ", @"plist");
        [_quickEditBar setBtnArr:[resdic objectForKey:KPQuickEditMenu]];
        [_quickEditBar setBackgroundColor:RGBCOLOR(30,30,30)];
        [self addSubview:_quickEditBar];
        [_quickEditBar setHidden:YES];
    }
}

#pragma mark - internal function
- (void)getEpubData:(BOOL)bl{
    if ([[ChristModel shareModel] getBibleParsState]) {
        volumeNext = [[ChristModel shareModel] getBibleVolumeIndex:volumeIndex];
        chapterCount = [[volumeNext getSpineDic] count];//章数
    }else{//自己解析
        [self getChristChapterVolume];
    }
    if (bl) {
        chapterIndex = 1;
    }else{
        chapterIndex = chapterCount - 1;
    }
    sectionCount = [[volumeNext getSamllChapter:chapterIndex] count];
    notsArr = [[[ChristModel shareModel] getNatesData] findData:[ChristUtils getNumberByInt:volumeIndex] chapterIndex:[ChristUtils getNumberByInt:chapterIndex]];
    [self setNavigationTitle];
}

-(void)getChristChapterVolume{
    ChristChapter *chapter = [[[ChristModel shareModel] getUnBibleTextArr] objectAtIndex:volumeIndex];
    volumeNext = [[ChristChapterEpub alloc] initWithPath:[chapter getText] title:[chapter getTitle] chapterIndex:[chapter getChapterIndex]];
    chapterCount = [[volumeNext getSpineDic] count];
    sectionCount = [[volumeNext getSamllChapter:chapterIndex] count];
}

-(void)saveVolumeChapter{
    [ChristUtils setDataByKey:[ChristUtils getStringByInt:volumeIndex] forkey:KUserSaveVolume];
    [ChristUtils setDataByKey:[ChristUtils getStringByInt:chapterIndex] forkey:KUserSaveChapter];
    sectionIndex = 0;
    _tableView.contentOffset  = CGPointMake(0, 0);
}

-(void)setNavigationTitle{
    NSString* title = [volumeNext getTitle];
    title = [title stringByReplacingOccurrencesOfString:[ChristUtils getStringByInt:[volumeNext getChapterIndex]] withString:@""];
    [titleButton setTitle:title forState:UIControlStateNormal];
}

-(void)setNextPrevBtnHide:(BOOL)bl{
    [prevButton setHidden:bl];
    [nextButton setHidden:bl];
}

- (BOOL)getIsNotes:(int)cindex sindex:(int)sindex{
    BOOL bl = NO;
    if (notsArr && notsArr.count > 0) {
        for (ChristManagedNotes *notes in notsArr) {
            if ([notes.chapter intValue] == cindex && [notes.section intValue] == sindex && //此条有记录
                notes.notes && notes.notes.length > 0) {
                bl = YES;
                break;
            }
        }
    }
    return bl;
}

- (BOOL)getIsHide:(int)cindex sindex:(int)sindex{
    BOOL bl = NO;
    if (notsArr && notsArr.count > 0) {
        for (ChristManagedNotes *notes in notsArr) {
            if ([notes.chapter intValue] == cindex && [notes.section intValue] == sindex && //此条有记录
                [notes.tag isEqualToString:@"YES"]) {
                bl = YES;
                break;
            }
        }
    }
    return bl;
}

#pragma mark - interface function
- (void)setEpubData:(int)vindex cindex:(int)cindex{//书卷、章
    volumeIndex = vindex;
    chapterIndex = cindex;
    sectionIndex = 0;
    if ([[ChristModel shareModel] getBibleParsState]) {
        volumeNext = [[ChristModel shareModel] getBibleVolumeIndex:vindex];
        chapterCount = [[volumeNext getSpineDic] count];//章数
        sectionCount = [[volumeNext getSamllChapter:cindex] count];
    }else{//自己解析
        [self getChristChapterVolume];
    }
    notsArr = [[[ChristModel shareModel] getNatesData] findData:[ChristUtils getNumberByInt:volumeIndex] chapterIndex:[ChristUtils getNumberByInt:chapterIndex]];
    [self setNavigationTitle];
     _tableView.contentOffset  = CGPointMake(0, 0);
    [_tableView reloadData];
}

-(void)setNotsArr{
    NSIndexPath *path = [NSIndexPath indexPathForRow:(sectionIndex - 1) inSection:0];
    notsArr = [[[ChristModel shareModel] getNatesData] findData:[ChristUtils getNumberByInt:volumeIndex] chapterIndex:[ChristUtils getNumberByInt:chapterIndex]];

    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:path  animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)setViewMode{
    [_navigationView setBackgroundColor:[[ChristModel shareModel] getNavBackColor]];
    [_quickSetBar setBackgroundColor:[[ChristModel shareModel] getNavBackColor]];
    [titleButton setTitleColor:[[ChristModel shareModel] getNavTitleTextColor] forState:UIControlStateNormal];
    [_tableView setBackgroundColor:[[ChristModel shareModel] getBodyBackColor]];
    [_tableView reloadData];
}

-(int)getvolumeIndex{
    return volumeIndex;
}

-(int)getChapterIndex{
    return chapterIndex;
}

-(int)getSectionIndex{
    return sectionIndex;
}

-(NSString*)getSectionText{
    return [volumeNext getSectionText:chapterIndex sectionIndex:sectionIndex];
}

#pragma mark - UIButton Click
-(void)menuButtonClick:(id)sender{
    if (!SysDelegate.viewHome.isMenuOpening ){
        [SysDelegate.viewHome switchPage:self dic:nil animationType:nil];
    }
}

-(void)titleButtonClick:(id)sender{
    if (!SysDelegate.viewHome.isMenuOpening ){
        NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
        [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeDirectory] forKey:KViewPageType];
        [SysDelegate.viewHome  switchPage:self dic:mtDic animationType:kCATransitionFromBottom];
    }
}

-(void)prevButtonClick:(id)sender{
    if (!SysDelegate.viewHome.isMenuOpening ){
        [self gotoPrevPage];
    }
}

-(void)prevButtonEnter:(id)sender{

}

-(void)nextButtonClick:(id)sender{
    if (!SysDelegate.viewHome.isMenuOpening ){
        [self gotoNextPage];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    sectionIndex  = indexPath.row + 1;//选择的节数
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [volumeNext getSectionText:chapterIndex sectionIndex:(indexPath.row + 1)];
    if (str == nil) {
        str = @"";
    }
    
    NSMutableString* source = [NSMutableString stringWithString:str];
    NSMutableString* content = [[NSMutableString alloc] init];
    int lines = 0;
    int height = 0;
    height = [source sizeWithFont:[[ChristModel shareModel] getBodyTextFont]].height;
    while ([source length] > 0) {
        int width = 0;
        content = [[NSMutableString alloc] init];
        while ([source length] > 0 && width < self.frame.size.width - 4 * KCellOff) {
            [content appendString:[source substringToIndex:1]];
            [source deleteCharactersInRange:NSMakeRange(0, 1)];
            
            width = [content sizeWithFont:[[ChristModel shareModel] getBodyTextFont]].width;
        }
        lines++;
    }
    return (lines + 1) * height + KCellMarkHeight/2;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ChristScriptureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChristScriptureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [[ChristModel shareModel]getBodyBackColor];
    
    NSString* title = [[[ChristModel shareModel] getBibleTiltleArr] objectAtIndex:(volumeIndex - 1)];
    title = [[title componentsSeparatedByString:@","] objectAtIndex:0];
    NSString* str = [[NSString alloc] initWithFormat:@"%d:%d",chapterIndex,(indexPath.row + 1)];
    NSString* text = [volumeNext getSectionText:chapterIndex sectionIndex:(indexPath.row + 1)];

    if (_quickSetBar.hidden == YES) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        title = [title stringByAppendingString:@" "];
        title = [title stringByAppendingString:str];
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        title = str;
    }
    
    //高亮与笔记
    BOOL isHide = [self getIsHide:chapterIndex sindex:(indexPath.row + 1)];
    BOOL isNotes = [self getIsNotes:chapterIndex sindex:(indexPath.row + 1)];
    [cell setVCSIndex:volumeIndex chapter:chapterIndex section:(indexPath.row + 1)];
    [cell setChaptertext:title];
    [cell setContentText:text];
    [cell setIsAnnotation:isNotes];
    [cell setIsHighlightedtext:isHide];
//    [cell setline:RGBCOLOR(220,230,210)];
    
    return cell;
}

#pragma mark - UIGestureRecognizer
-(void)setupGestures {
    _singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    _singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:_singleRecognizer];//给self.view添加一个手势监测；
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPressRecognizer];
    
    _rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)];
	[_rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
	
	_leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)];
	[_leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
	
	[self addGestureRecognizer:_rightSwipeRecognizer];
	[self addGestureRecognizer:_leftSwipeRecognizer];
}

-(void)singleTap:(UITapGestureRecognizer*)recognizer{
    if (_quickEditBar.hidden) {
        if (!SysDelegate.viewHome.isMenuOpening) {
            BOOL bl = _quickSetBar.hidden;
            [self setReadModel];
            [_delegate singleTap:self recognizer:recognizer bl:bl];
        }
    }
}

-(void)longPress:(UITapGestureRecognizer*)recognizer{
    if (_quickSetBar.hidden) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            if (!SysDelegate.viewHome.isMenuOpening) {
                BOOL bl = _quickEditBar.hidden;
                if (bl) {
                    [_quickEditBar restoreHidden];
                }
                [_quickEditBar setHidden:!bl];
                [self statusChange];
                [_delegate longPress:self recognizer:recognizer bl:bl];
            }
        }
    }
}

-(void)setReadModel{
    BOOL bl = _quickSetBar.hidden;
    if (bl) {
        [_quickSetBar restoreHidden];
    }
    [_quickSetBar setHidden:!bl];
    [_navigationView setHidden:!bl];
    [self setNextPrevBtnHide:!bl];
    [self statusChange];
}

-(void)statusChange{
    if ( _navigationView.hidden == YES) {//导航栏隐藏时，全屏幕显示
        _tableView.frame = CGRectMake(0, KStatusBarHeight, self.frame.size.width, self.frame.size.height - KStatusBarHeight);
        _singleRecognizer.enabled = YES;
    }
    if ( _navigationView.hidden == YES && _quickEditBar.hidden == NO) {//长按后
        _tableView.frame = CGRectMake(0, KStatusBarHeight, self.frame.size.width, self.frame.size.height - KStatusBarHeight - _quickEditBar.frame.size.height);
        _singleRecognizer.enabled = NO;
    }
    if (_navigationView.hidden == NO) {//单击后
         _tableView.frame = CGRectMake(0, KStatusBarHeight + KNavigationHeight, self.frame.size.width, self.frame.size.height - KNavigationHeight - KStatusBarHeight - _quickSetBar.frame.size.height);
        _singleRecognizer.enabled = YES;
    }
}

- (void) gotoNextPage {
    ++chapterIndex;//下一章
    if (chapterIndex < chapterCount ) {
        sectionCount = [[volumeNext getSamllChapter:chapterIndex] count];
    }else{
        ++volumeIndex;
        if (volumeIndex < [[[ChristModel shareModel] getUnBibleTextArr] count]) {
            [self getEpubData:YES];
        }else{
            --chapterIndex;
            --volumeIndex;
            return;
        }
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [_tableView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [_tableView.layer addAnimation:transition forKey:@"animation"];
    
    [_tableView reloadData];
    [self saveVolumeChapter];

}

- (void) gotoPrevPage {
    --chapterIndex;//上一章
    if (chapterIndex > 0 ) {
        sectionCount = [[volumeNext getSamllChapter:chapterIndex] count];
    }else{
        --volumeIndex;
        if (volumeIndex > 0) {
            [self getEpubData:NO];
        }else{
            ++volumeIndex;
            chapterIndex = 1;
            return;
        }
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [_tableView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [_tableView.layer addAnimation:transition forKey:@"animation"];
    
    [_tableView reloadData];
    [self saveVolumeChapter];
}


//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:1.0f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
//    [UIView commitAnimations];

@end
