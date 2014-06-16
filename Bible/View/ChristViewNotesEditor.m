//
//  ChristViewNotesEditor.m
//  Bible
//
//  Created by yons on 14-6-7.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristConfig.h"
#import "ChristModel.h"
#import "ChristUtils.h"
#import "ChristViewNotesEditor.h"

@interface ChristViewNotesEditor(){
    UIView* navigationView;
    UIView* scriptureView;
    UITextView* textView;
    
    //书卷 章 节
    NSString* volume;
    NSString* chapter;
    NSString* section;
    
    NSString* contentText;
    
    UILabel* notesTitle;
}
@end

@implementation ChristViewNotesEditor

@synthesize dataInfoDic =_dataInfoDic;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:RGBCOLOR(200,200,30)];
        UILabel* lab = [ChristUtils labelWithTxt:@"ChristViewNotes" frame:self.frame font:[UIFont fontWithName:@"Arial" size:30] color:[UIColor blackColor]];
        [self addSubview:lab];
        [ChristUtils disableGestures:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [self initNavigation];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic{
    [self setDataInfoDic:dic];
}

#pragma mark - init
-(void)initNavigation{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, KNavigationHeight)];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:navigationView];
    
    UIButton* backButton = [ChristUtils buttonWithImg:@"取消" off:0 image:nil imagesec:nil target:self action:@selector(backButtonClick:)];
    backButton.frame = CGRectMake(KCellOff, 0, backButton.frame.size.width, KNavigationHeight);
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigationView addSubview:backButton];
    
    notesTitle = [ChristUtils labelWithTxt:@"                    "
                                      frame:CGRectMake(navigationView.frame.size.width/2 - 100, 0, 200, KNavigationHeight)
                                       font:[UIFont fontWithName:@"Arial" size:18]
                                      color:[UIColor blackColor]];
    [navigationView addSubview:notesTitle];
    
    UIButton* saveButton = [ChristUtils buttonWithImg:@"保存" off:0 image:nil imagesec:nil target:self action:@selector(saveButtonClick:)];
    saveButton.frame = CGRectMake(navigationView.frame.size.width - backButton.frame.size.width - KCellOff, 0, backButton.frame.size.width, KNavigationHeight);
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigationView addSubview:saveButton];
}

-(void)initScriptureView{
    [scriptureView removeFromSuperview];
    if (contentText == nil) {
        contentText = @"";
    }
    scriptureView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavigationHeight + KStatusBarHeight, self.frame.size.width, [self getScriptureHeight:contentText])];
    [scriptureView setBackgroundColor:RGBCOLOR(200, 200, 200)];
    [self addSubview:scriptureView];
    
    int lines = 0;
    NSMutableString* content = [[NSMutableString alloc] init];
    NSMutableString* source = [NSMutableString stringWithString:contentText];
    int height = 0;
    while ([source length] > 0) {
        int width = 0;
        content = [[NSMutableString alloc] init];
        while ([source length] > 0 && width < scriptureView.frame.size.width - 4 * KCellOff) {
            [content appendString:[source substringToIndex:1]];
            [source deleteCharactersInRange:NSMakeRange(0, 1)];
            
            width = [content sizeWithFont:[UIFont fontWithName:@"Arial" size:15]].width;
            height = [content sizeWithFont:[UIFont fontWithName:@"Arial" size:15]].height;
        }
        
        UILabel* label = [ChristUtils labelWithTxt:content
                                             frame:CGRectMake(KCellOff,
                                                              lines * height + KCellOff,
                                                              width ,
                                                              height)
                                              font:[UIFont fontWithName:@"Arial" size:15]
                                             color:[[ChristModel shareModel] getBodyTextColor]];
        label.textAlignment = UITextAlignmentLeft;
        [scriptureView addSubview:label];
        
        lines++;
    }
}

-(void)initTextView{
    NSArray * notesArr = [[[ChristModel shareModel] getNatesData] findData:[ChristUtils getNumberByInt:[volume intValue]]
                                                              chapterIndex:[ChristUtils getNumberByInt:[chapter intValue]]
                                                                sectionIndex:[ChristUtils getNumberByInt:[section intValue]]];
    NSString* text = @"请输入笔记内容";
    BOOL bl = NO;
    if (notesArr && notesArr.count == 1 && [[notesArr objectAtIndex:0] notes] && [[notesArr objectAtIndex:0] notes].length > 0) {
        text = [[notesArr objectAtIndex:0] notes];
        bl = YES;
    }
    
    float h = KNavigationHeight + KStatusBarHeight + scriptureView.frame.size.height;
    if (textView == nil) {
        textView = [[UITextView alloc]initWithFrame:CGRectMake(0, h, self.frame.size.width, self.frame.size.height - h)];
        textView.delegate = self;
        textView.text = text;
        [self addSubview: textView ];
    }else{
        textView.frame = CGRectMake(0, h, self.frame.size.width, self.frame.size.height - h);
        textView.text = text;
    }
    if (!bl) {
        textView.textColor = RGBCOLOR(200, 200, 200);
    }else{
        textView.textColor = [UIColor blackColor];
    }
}


#pragma mark - internal function
-(void)setNavigationTitle{
    int ivolume = [[_dataInfoDic objectForKey:KUserSaveVolume] intValue];
    NSString* title = [[[ChristModel shareModel] getBibleTiltleArr] objectAtIndex:ivolume - 1];
    notesTitle.text = [[title componentsSeparatedByString:@","] objectAtIndex:1];
}

-(float)getScriptureHeight:(NSString *)str{
    if (str == nil) {
        return 0;
    }
    NSMutableString* source = [NSMutableString stringWithString:str];
    NSMutableString* content = [[NSMutableString alloc] init];
    int lines = 0;
    int height = 0;
    height = [source sizeWithFont:[UIFont fontWithName:@"Arial" size:15]].height;
    while ([source length] > 0) {
        int width = 0;
        content = [[NSMutableString alloc] init];
        while ([source length] > 0 && width < self.frame.size.width - 4 * KCellOff) {
            [content appendString:[source substringToIndex:1]];
            [source deleteCharactersInRange:NSMakeRange(0, 1)];
            
            width = [content sizeWithFont:[UIFont fontWithName:@"Arial" size:15]].width;
        }
        lines++;
    }
    return lines * height + 2 * KCellOff;
}

#pragma mark - interface function
-(void)setDataInfoDic:(NSDictionary *)dataInfoDic{
    _dataInfoDic = dataInfoDic;
    volume = [_dataInfoDic objectForKey:KUserSaveVolume];
    chapter = [_dataInfoDic objectForKey:KUserSaveChapter];
    section = [_dataInfoDic objectForKey:KUserSaveSection];
    contentText = [_dataInfoDic objectForKey:KNotesContentText];
    [self initScriptureView];
    [self setNavigationTitle];
    [self initTextView];
}

#pragma mark - UITextViewDelegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textview{
    if ([textview.text isEqualToString:@"请输入笔记内容"] ) {
        textview.text = @"";
        textview.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textview{

}


#pragma mark - UIButton Click
-(void)backButtonClick:(id)sender{
    NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
    [mtDic setObject:[_dataInfoDic objectForKey:KViewPrevPageType] forKey:KViewPageType];
    [SysDelegate.viewHome  switchPage:self dic:mtDic animationType:kCATransitionFromBottom];
}

-(void)saveButtonClick:(id)sender{
    //保存
    BOOL bl = NO;
    ChristNotes* notes = [[ChristNotes alloc] init];
    notes.volume = [ChristUtils getNumberByInt:[volume intValue]];
    notes.chapter = [ChristUtils getNumberByInt:[chapter intValue]];
    notes.section = [ChristUtils getNumberByInt:[section intValue]];
    
    notes.scriptures = contentText;
    notes.notes  = textView.text;
    if (textView.text == nil || textView.text.length < 1 || [textView.text isEqualToString:@"请输入笔记内容"]) {
        //删除
        bl = [[[ChristModel shareModel] getNatesData] deleteData:notes];
    }else{
        //插入或更新
        bl = [[[ChristModel shareModel] getNatesData] updateData:notes];
    
    }

    //跳转
    NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
    [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeScripture] forKey:KViewPageType];
    [SysDelegate.viewHome  switchPage:self dic:mtDic animationType:kCATransitionFromBottom];
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (textView.text == nil || textView.text.length < 1 || [textView.text isEqualToString:@"请输入笔记内容"]) {
        textView.text = @"请输入笔记内容";
        textView.textColor = RGBCOLOR(200, 200, 200);
    }
    [textView resignFirstResponder];
}

- (void)keyboardWasChange:(NSNotification *)aNotification {
    NSString *str=[[UITextInputMode currentInputMode] primaryLanguage];
    NSLog(@"shurufa--------------%@",str);
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // CGRect frame = self.search.frame;
    if (kbSize.height == 216) {
        NSLog(@"english");
//        ReplayView.frame = CGRectMake(0, HEIGHT.height-216-89, 320, 45);
    } else if(kbSize.height == 252){
        NSLog(@"中文");
//        ReplayView.frame = CGRectMake(0, HEIGHT.height-216-125, 320, 45);
    }
}

@end
