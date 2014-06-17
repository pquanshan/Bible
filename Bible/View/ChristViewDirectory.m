//
//  ChristViewDirectory.m
//  Bible
//
//  Created by apple on 14-6-4.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#define KLROff                  (5)
#define KUDOff                  (5)
#define KOldNewTextHeight       (30)

#define KVolumeArrBtnTag(i)         ((1000) + (i))
#define KVolumeArrBtnParsTag(i)     ((i) - (1000))

#define KChapterArrBtnTag(i)        ((2000) + (i))
#define KChapterArrBtnParsTag(i)    ((i) - (2000))


#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristModel.h"
#import "ChristViewDirectory.h"

@interface ChristViewDirectory(){
    UIView* navigationView;
    UIButton* volumeBtn;
    UIButton* chapterBtn;
    UILabel* dirLabTitle;
    
    float btnHwidth;
    float cbtnHwidth;
    int vLineNumber;
    int cLineNumber;
    NSArray* cutvolumTitleArr;
    
    int chapterCount;
    int chapterIndex;
}
@end

@implementation ChristViewDirectory

@synthesize volumeView = _volumeView;
@synthesize chapterView = _chapterView;
//@synthesize loadedEpub = _loadedEpub;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor grayColor]];
        UILabel* lab = [ChristUtils labelWithTxt:@"ChristViewDirectory" frame:self.frame font:[UIFont fontWithName:@"Arial" size:30] color:[UIColor blackColor]];
        [self addSubview:lab];
        vLineNumber = 5;
        cLineNumber = 5;
        chapterCount = 0;
        btnHwidth = (self.frame.size.width - KLROff*(vLineNumber + 1))/ vLineNumber;
        cbtnHwidth = (self.frame.size.width - KLROff*(cLineNumber + 1))/ cLineNumber;
        
        NSMutableDictionary* resdic = LOADDIC(@"christ", @"plist");
        cutvolumTitleArr = [resdic objectForKey:KPCutVolumeTitle];
        
        [self initNavigation];
        [self initVolumeChapterBtn];
        [self initVolumeView];
        //添加无效手势，禁用home页响应
        [ChristUtils disableGestures:self];
    }
    return self;
}

-(void)viewAppear{
    [self setLoadeData:nil];
}

#pragma mark - init
-(void)initNavigation{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, KNavigationHeight)];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:navigationView];
    
    dirLabTitle = [ChristUtils labelWithTxt:@"                    "
                                          frame:CGRectMake(navigationView.frame.size.width/2 - 50, 0, 100, KNavigationHeight)
                                           font:[UIFont fontWithName:@"Arial" size:18]
                                          color:[UIColor blackColor]];
    [navigationView addSubview:dirLabTitle];
    
    UIButton* backButton = [ChristUtils buttonWithImg:@"取消" off:0 image:nil imagesec:nil target:self action:@selector(backButtonClick:)];
    backButton.frame = CGRectMake(navigationView.frame.size.width - backButton.frame.size.width - KCellOff, 0, backButton.frame.size.width, KNavigationHeight);
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigationView addSubview:backButton];
}

-(void)initVolumeChapterBtn{
    volumeBtn = [ChristUtils buttonWithImg:@"书卷" off:0 image:nil imagesec:nil target:self action:@selector(volumeButtonClick:)];
    volumeBtn.frame = CGRectMake(0, KStatusBarHeight +  KNavigationHeight, self.frame.size.width/2, KTabButtonHeight1);
    [volumeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [self addSubview:volumeBtn];
    chapterBtn = [ChristUtils buttonWithImg:@"章" off:0 image:nil imagesec:nil target:self action:@selector(chapterButtonClick:)];
    [chapterBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    chapterBtn.frame = CGRectMake(self.frame.size.width/2, KStatusBarHeight +  KNavigationHeight, self.frame.size.width/2, KTabButtonHeight1);
    [self addSubview:chapterBtn];
}

-(void)initVolumeView{
    float height = KStatusBarHeight +  KNavigationHeight + volumeBtn.frame.size.height;
    if (_volumeView == nil) {
        _volumeView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,height,self.frame.size.width,self.frame.size.height - height)];
        [_volumeView setBackgroundColor:RGBCOLOR(130,230,190)];
        [self addSubview:_volumeView];
        //添加按钮
        float svheight = 0;
        int count = KBibleOldVolumeNumber/vLineNumber;
        count = (KBibleOldVolumeNumber%vLineNumber == 0) ? count : count + 1;
        svheight += KOldNewTextHeight;
        svheight += btnHwidth*count;
        svheight += KUDOff*(count + 1);
        
        count = KBibleNewVolumeNumber/vLineNumber;
        count = (KBibleNewVolumeNumber%vLineNumber == 0) ? count : count + 1;
        
        svheight += KOldNewTextHeight;
        svheight += btnHwidth*count;
        svheight += KUDOff*(count + 1);
        
        _volumeView.contentSize  = CGSizeMake(self.frame.size.width, svheight);
        _volumeView.contentOffset  = CGPointMake(0, 0);
     
        //添加按钮及界线
        UILabel* oldLabel = [ChristUtils labelWithTxt:@"旧约"
                                                frame:CGRectMake(KUDOff, 0, _volumeView.frame.size.width - KUDOff, KOldNewTextHeight)
                                                 font:[UIFont fontWithName:@"Arial" size:13]
                                                color:[UIColor grayColor]];
        [_volumeView addSubview:oldLabel];
        
        float hy = KOldNewTextHeight;
        float y = 0;
        float x = 0;
        for (int i = 0; i < KBibleOldVolumeNumber; i++) {
            x = btnHwidth*(i%vLineNumber) + KLROff + (i%vLineNumber)*KLROff;
            y = hy + btnHwidth*(i/vLineNumber) + KUDOff + (i/vLineNumber)*KUDOff;
            UIButton* btn = [ChristUtils buttonWithImg:nil off:0 image:nil imagesec:nil target:self action:@selector(volumeArrBtnClick:)];
            btn.frame = CGRectMake(x, y, btnHwidth, btnHwidth);
            [btn setBackgroundImage:[ChristUtils imageWithColor:[UIColor grayColor] andSize:btn.frame.size] forState:UIControlStateNormal];
            [btn setBackgroundImage:[ChristUtils imageWithColor:[UIColor orangeColor] andSize:btn.frame.size] forState:UIControlStateSelected];
            btn.tag = KVolumeArrBtnTag(i);
            [_volumeView addSubview:btn];
            
            //添加文本
            UILabel* cutTitle = [ChristUtils labelWithTxt:[self getbtnCutTitle:i]
                                                    frame:CGRectMake(KLROff/2, 0, btn.frame.size.width - KLROff, btn.frame.size.height*2/3)
                                                     font:[UIFont fontWithName:@"Arial" size:18]
                                                    color:[UIColor whiteColor]];
            cutTitle.textAlignment = UITextAlignmentLeft;
            [btn addSubview:cutTitle];
            
            UILabel* title = [ChristUtils labelWithTxt:[self getbtnTitle:i]
                                                    frame:CGRectMake(KLROff/2, btn.frame.size.height*2/3, btn.frame.size.width - KLROff, btn.frame.size.height/3)
                                                     font:[UIFont fontWithName:@"Arial" size:10]
                                                    color:[UIColor whiteColor]];
            title.textAlignment = UITextAlignmentLeft;
            [btn addSubview:title];
            
            
        }
        
        hy = y + btnHwidth + KUDOff;
        UILabel* newLabel = [ChristUtils labelWithTxt:@"新约"
                                                frame:CGRectMake(KUDOff, hy, _volumeView.frame.size.width - KUDOff, KOldNewTextHeight)
                                                 font:[UIFont fontWithName:@"Arial" size:13]
                                                color:[UIColor grayColor]];
        [_volumeView addSubview:newLabel];
        hy += KOldNewTextHeight;
        
        for (int i = 0; i < KBibleNewVolumeNumber; i++) {
            x = btnHwidth*(i%vLineNumber) + KLROff + (i%vLineNumber)*KLROff;
            y = hy + btnHwidth*(i/vLineNumber) + KUDOff + (i/vLineNumber)*KUDOff;
            UIButton* btn = [ChristUtils buttonWithImg:nil off:0 image:nil imagesec:nil target:self action:@selector(volumeArrBtnClick:)];
            btn.frame = CGRectMake(x, y, btnHwidth, btnHwidth);
            [btn setBackgroundImage:[ChristUtils imageWithColor:[UIColor grayColor] andSize:btn.frame.size] forState:UIControlStateNormal];
            [btn setBackgroundImage:[ChristUtils imageWithColor:[UIColor orangeColor] andSize:btn.frame.size] forState:UIControlStateSelected];
            btn.tag = KVolumeArrBtnTag(i + KBibleOldVolumeNumber);
            [_volumeView addSubview:btn];
            
            //添加文本
            UILabel* cutTitle = [ChristUtils labelWithTxt:[self getbtnCutTitle:(i + KBibleOldVolumeNumber)]
                                                    frame:CGRectMake(KLROff/2, 0, btn.frame.size.width - KLROff, btn.frame.size.height*2/3)
                                                     font:[UIFont fontWithName:@"Arial" size:18]
                                                    color:[UIColor whiteColor]];
            cutTitle.textAlignment = UITextAlignmentLeft;
            [btn addSubview:cutTitle];
            
            UILabel* title = [ChristUtils labelWithTxt:[self getbtnTitle:(i + KBibleOldVolumeNumber)]
                                                 frame:CGRectMake(KLROff/2, btn.frame.size.height*2/3, btn.frame.size.width - KLROff, btn.frame.size.height/3)
                                                  font:[UIFont fontWithName:@"Arial" size:10]
                                                 color:[UIColor whiteColor]];
            title.textAlignment = UITextAlignmentLeft;
            [btn addSubview:title];
        }

    }
}

-(void)initChapterView{
    float height = KStatusBarHeight +  KNavigationHeight + volumeBtn.frame.size.height;
    [_chapterView removeFromSuperview];
    
    _chapterView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,height,self.frame.size.width,self.frame.size.height - height)];
    [_chapterView setBackgroundColor:RGBCOLOR(170,220,140)];
    [self addSubview:_chapterView];
    
    if (chapterCount > 0) {
 
        //添加按钮
        float scheight = 0;
        float cheight = cbtnHwidth*2/3;
        int count = chapterCount/cLineNumber;
        count = (chapterCount%cLineNumber == 0) ? count : count + 1;
        scheight += KOldNewTextHeight;
        scheight += cheight*count;
        scheight += KUDOff*(count + 1);
        _chapterView.contentSize  = CGSizeMake(self.frame.size.width, scheight);
        _chapterView.contentOffset  = CGPointMake(0, 0);
        
        float y = 0;
        float x = 0;
        for (int i = 0; i < chapterCount; i++) {
            x = btnHwidth*(i%cLineNumber) + KLROff + (i%cLineNumber)*KLROff;
            y = cheight*(i/cLineNumber) + KUDOff + (i/cLineNumber)*KUDOff;
            UIButton* btn = [ChristUtils buttonWithImg:[ChristUtils getStringByInt:(i+1)] off:0 image:nil imagesec:nil target:self action:@selector(chapterArrBtnClick:)];
            btn.frame = CGRectMake(x, y, btnHwidth, cheight);
            [btn setBackgroundImage:[ChristUtils imageWithColor:[UIColor grayColor] andSize:btn.frame.size] forState:UIControlStateNormal];
            [btn setBackgroundImage:[ChristUtils imageWithColor:[UIColor orangeColor] andSize:btn.frame.size] forState:UIControlStateSelected];
            btn.tag = KChapterArrBtnTag(i);
            [_chapterView addSubview:btn];
        }
    }else{
        UILabel* lab = [ChristUtils labelWithTxt:@"正在解析圣经......"
                                           frame:CGRectMake(0, KNavigationHeight, self.frame.size.width, KNavigationHeight)
                                            font:[UIFont fontWithName:@"Arial" size:20]
                                           color:[UIColor blackColor]];
        [_chapterView addSubview:lab];
    }
}

#pragma mark - internal function
-(NSString*)getbtnTitle:(int)index{
    NSString* title = [[[ChristModel shareModel] getBibleTiltleArr] objectAtIndex:index];
    title = [[title componentsSeparatedByString:@","] objectAtIndex:1];
    return title;
}

-(NSString*)getbtnCutTitle:(int)index{
    NSString* title = [[[ChristModel shareModel] getBibleTiltleArr] objectAtIndex:index];
    title = [[title componentsSeparatedByString:@","] objectAtIndex:0];
    return title;
}

- (void)setSelectState:(BOOL)bl{
    volumeBtn.selected = bl;
    chapterBtn.selected = !bl;
    [_volumeView setHidden:!bl];
    [_chapterView setHidden:bl];
    if (!bl) {
        dirLabTitle.text = [self getbtnTitle:(chapterIndex - 1)];
    }else{
        dirLabTitle.text = @"目录";
    }
}

#pragma mark - interface function
-(void)setLoadeData:(id)sender{
    [self setSelectState:YES];
}

#pragma mark - UIButton Click
-(void)volumeArrBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = KVolumeArrBtnParsTag(btn.tag);
    ChristChapterEpub *chapterEpub = [[ChristModel shareModel] getBibleVolumeIndex:(index + 1)];
    chapterCount = [[chapterEpub getSpineDic] count] - 1;
    //设置章节
    chapterIndex = index +1;
    [self initChapterView];
    [self setSelectState:NO];
}

-(void)chapterArrBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = KChapterArrBtnParsTag(btn.tag);
    [ChristUtils setDataByKey:[ChristUtils getStringByInt:chapterIndex] forkey:KUserSaveVolume];
    [ChristUtils setDataByKey:[ChristUtils getStringByInt:(index + 1)] forkey:KUserSaveChapter];
    [self backButtonClick:nil];
}

-(void)backButtonClick:(id)sender{
    NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
    [mtDic setObject:[ChristUtils getDataByKey:KUserSaveVolume] forKey:KUserSaveVolume];
    [mtDic setObject:[ChristUtils getDataByKey:KUserSaveChapter] forKey:KUserSaveChapter];
    [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeScripture] forKey:KViewPageType];
    [SysDelegate.viewHome switchPage:self dic:mtDic animationType:kCATransitionFromTop];
}

-(void)volumeButtonClick:(id)sender{
    [self setSelectState:YES];
}

-(void)chapterButtonClick:(id)sender{
}

@end
