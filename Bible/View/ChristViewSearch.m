//
//  ChristViewSearch.m
//  Bible
//
//  Created by yons on 14-6-7.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//
#define KSearchTestament                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)


#import "ChristUtils.h"
#import "ChristModel.h"
#import "ChristViewSearch.h"

@interface ChristViewSearch(){
    UIView* navigationView;
    UIView* sRangeTitleView;
    UISearchBar* searchBarBible;
    UILabel* sRangeTitle;
    UILabel* numberResults;
    
    UITableView* sRangeTabview;
    UITableView* searchTabview;
    
    NSMutableArray* sRangeArr;
    NSArray* searchRangeArr;
    NSArray* searchArr;
    BOOL  isRange;
    
    NSString* volumeStr;
    NSString* chapterStr;
    
//    UIButton* backButton;
}
@end

@implementation ChristViewSearch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor orangeColor]];
        UILabel* lab = [ChristUtils labelWithTxt:@"ChristViewSearch" frame:self.frame font:[UIFont fontWithName:@"Arial" size:30] color:[UIColor blackColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
        sRangeArr = [[NSMutableArray alloc] initWithObjects:@"整本圣经",@"旧约",@"新约",@"摩西五经",@"历史书",@"诗歌、智慧书",@"大先知书",@"小先知书",@"四福音",@"教会历史",@"保罗书信",@"其他书信",@"启示录", nil];
        isRange = NO;

        [self addSubview:lab];
        [self initNavigation];
        [self initSRangeTitleView];
        [self initSearchTabview];
        [self initSRangeTabview];

        NSIndexPath  *first = [NSIndexPath indexPathForRow:0 inSection:0];
        [sRangeTabview selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionNone];
        sRangeTitle.text = [sRangeArr objectAtIndex:0];
        searchRangeArr = [self getSearchRangeArr:nil];
    }
    return self;
}

-(void)viewAppear{

}

-(void)setDic:(NSDictionary *)dic{
    volumeStr = [dic objectForKey:KUserSaveVolume];
    chapterStr = [dic objectForKey:KUserSaveChapter];
    BOOL bl = NO;
    if (volumeStr && chapterStr) {
        if (sRangeArr.count != 14) {
            bl = YES;
            sRangeArr = [[NSMutableArray alloc] initWithObjects:@"当前章节",@"整本圣经",@"旧约",@"新约",@"摩西五经",@"历史书",@"诗歌、智慧书",@"大先知书",@"小先知书",@"四福音",@"教会历史",@"保罗书信",@"其他书信",@"启示录", nil];
        }
    }else{
        if (sRangeArr.count != 13) {
            bl = YES;
            sRangeArr = [[NSMutableArray alloc] initWithObjects:@"整本圣经",@"旧约",@"新约",@"摩西五经",@"历史书",@"诗歌、智慧书",@"大先知书",@"小先知书",@"四福音",@"教会历史",@"保罗书信",@"其他书信",@"启示录", nil];
        }
    }
    //sRangeArr变化了的话
    if (bl) {
        [sRangeTabview reloadData];
        NSIndexPath  *first = [NSIndexPath indexPathForRow:0 inSection:0];
        [sRangeTabview selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionNone];
        sRangeTitle.text = [sRangeArr objectAtIndex:0];
        searchRangeArr = [self getSearchRangeArr:sRangeTitle.text];
    }
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchBarBible resignFirstResponder];
}

#pragma mark - init
-(void)initNavigation{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, KNavigationHeight)];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:navigationView];
    
    searchBarBible = [[UISearchBar alloc] init];
    searchBarBible.frame = CGRectMake(0, 0, self.frame.size.width, KNavigationHeight);
    searchBarBible.placeholder = @"请输入搜索关键字";
    searchBarBible.delegate = self;
    [navigationView addSubview:searchBarBible];
    
//    backButton = [ChristUtils buttonWithImg:@"取消" off:0 image:nil imagesec:nil target:self action:@selector(backButtonClick:)];
//    backButton.frame = CGRectMake(navigationView.frame.size.width - backButton.frame.size.width - KCellOff, 0, backButton.frame.size.width, KNavigationHeight);
//    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [navigationView addSubview:backButton];
}


-(void)initSRangeTitleView{
    sRangeTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight + KNavigationHeight, self.frame.size.width, KTabButtonHeight1)];
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [sRangeTitleView addGestureRecognizer:singleRecognizer];//给self.view添加一个手势监测；
    [self addSubview:sRangeTitleView];
    
    UILabel * sRange = [ChristUtils labelWithTxt:@"搜索范围:"
                                           frame:CGRectMake(0, 0, self.frame.size.width/4, KTabButtonHeight1)
                                            font:[UIFont fontWithName:@"Arial" size:15]
                                           color: [UIColor whiteColor]];
    [sRangeTitleView addSubview:sRange];
   
    sRangeTitle = [ChristUtils labelWithTxt:@""
                                      frame:CGRectMake(self.frame.size.width/4, 0, self.frame.size.width*3/8, KTabButtonHeight1)
                                       font:[UIFont fontWithName:@"Arial" size:15]
                                      color: [UIColor whiteColor]];
    sRangeTitle.textAlignment = UITextAlignmentLeft;
    [sRangeTitleView addSubview:sRangeTitle];
    
    
    numberResults = [ChristUtils labelWithTxt:@""
                                      frame:CGRectMake(self.frame.size.width* 5/8, 0, self.frame.size.width*3/8, KTabButtonHeight1)
                                       font:[UIFont fontWithName:@"Arial" size:12]
                                      color: [UIColor grayColor]];
    numberResults.textAlignment = UITextAlignmentRight;
    [sRangeTitleView addSubview:numberResults];
}

-(void)initSRangeTabview{
    float h =  KStatusBarHeight + KNavigationHeight + KTabButtonHeight1;
    sRangeTabview = [[UITableView alloc] initWithFrame:CGRectMake(0, h, self.frame.size.width, 0)
                                              style:UITableViewStylePlain] ;
    sRangeTabview.dataSource = self;
    sRangeTabview.delegate = self;
    sRangeTabview.rowHeight = KTabButtonHeight1;
    sRangeTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:sRangeTabview];
}

-(void)initSearchTabview{
    float h =  KStatusBarHeight + KNavigationHeight + KTabButtonHeight1;
    searchTabview = [[UITableView alloc] initWithFrame:CGRectMake(0, h, self.frame.size.width, self.frame.size.height - h)
                                                 style:UITableViewStylePlain] ;
    searchTabview.dataSource = self;
    searchTabview.delegate = self;
    searchTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:searchTabview];
}

#pragma mark - internal function
-(NSArray*)searchVolume:(NSArray*)volArr strSearch:(NSString*)strSearch{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    int volume = 1;
    int chapter = 1;
    int section = 1;
    if (volArr) {
        for (int i = 0; i < volArr.count; ++i) {
            volume = [[volArr objectAtIndex:i] intValue];
            ChristChapterEpub* volumeNext = [[ChristModel shareModel] getBibleVolumeIndex:volume];
            NSString* str = @"";
            if (volumeNext && [volumeNext getSpineDic] ) {
                for (chapter = 1; chapter <= [[volumeNext getSpineDic] count]; ++chapter) {
                    NSDictionary * dic = [volumeNext getSamllChapter:chapter];
                    if (dic) {
                        for (section = 1; section <= dic.count; ++section) {
                            str = [volumeNext getSectionText:chapter sectionIndex:section];
                            if(str && [str rangeOfString:strSearch options:NSCaseInsensitiveSearch].location != NSNotFound ){
                                [arr addObject:[NSNumber numberWithInt:(volume * 1000000 + chapter * 1000 + section)]];
                            }
                        }
                    }
                }
            }
        }
    }
    return arr;
}

-(NSArray*)getSearchRangeArr:(NSString*)strtitle{
    if (strtitle == nil || [strtitle isEqualToString:@"整本圣经"]) {
        return [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",
                                                @"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",
                                                @"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",
                                                @"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",
                                                @"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",
                                                @"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",nil];
    }else if ([strtitle isEqualToString:@"旧约"]){
        return [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",
                                                @"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",
                                                @"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",
                                                @"34",@"35",@"36",@"37",@"38",@"39",nil];
    }else if ([strtitle isEqualToString:@"新约"]){
        return [[NSArray alloc] initWithObjects:@"40",@"41",@"42",@"43",@"44",
                                                @"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",
                                                @"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",nil];
    }else if ([strtitle isEqualToString:@"摩西五经"]){
        return [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];//摩西五经
    }else if ([strtitle isEqualToString:@"历史书"]){
        return [[NSArray alloc] initWithObjects:@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17", nil];//历史书
    }else if ([strtitle isEqualToString:@"诗歌、智慧书"]){
        return [[NSArray alloc] initWithObjects:@"18",@"19",@"20",@"21",@"22", nil];//诗歌智慧书
    }else if ([strtitle isEqualToString:@"大先知书"]){
        return [[NSArray alloc] initWithObjects:@"23",@"24",@"25",@"26",@"27", nil];//大先知书
    }else if ([strtitle isEqualToString:@"小先知书"]){
        return [[NSArray alloc] initWithObjects:@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39", nil];//小先知书
    }else if ([strtitle isEqualToString:@"四福音"]){
        return [[NSArray alloc] initWithObjects:@"40",@"41",@"42",@"43", nil];//四福音
    }else if ([strtitle isEqualToString:@"教会历史"]){
        return [[NSArray alloc] initWithObjects:@"44", nil];//教会历史
    }else if ([strtitle isEqualToString:@"保罗书信"]){
        return [[NSArray alloc] initWithObjects:@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57", nil];//保罗书信
    }else if ([strtitle isEqualToString:@"其他书信"]){
        return [[NSArray alloc] initWithObjects:@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65", nil];//其他书信
    }else if ([strtitle isEqualToString:@"启示录"]){
        return  [[NSArray alloc] initWithObjects:@"66", nil];//启示录
    }else if ([strtitle isEqualToString:@"当前章节"]){
        return  [[NSArray alloc] initWithObjects:volumeStr, nil];//启示录
    }
    return nil;
}

-(void)movePanelsRangeTabview:(BOOL)bl{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (bl) {
            float h =  KStatusBarHeight + KNavigationHeight + KTabButtonHeight1;
            sRangeTabview.frame =  CGRectMake(0, h, self.frame.size.width, self.frame.size.height - h);
        }else{
            float h =  KStatusBarHeight + KNavigationHeight + KTabButtonHeight1;
            sRangeTabview.frame =  CGRectMake(0, h, self.frame.size.width, 0);
        }
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             isRange = bl;
                         }
                     }];
    
    
}

#pragma mark - UIButton Click
-(void)singleTap:(UITapGestureRecognizer*)recognizer{
     [self movePanelsRangeTabview:!isRange];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (SysDelegate.viewHome.isMenuOpening) {
        return NO;
    }else{
        return YES;
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [SysDelegate.viewHome setRecognizerState:YES];
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchArr = [self searchVolume:searchRangeArr strSearch:searchBar.text];
    [SysDelegate.viewHome setRecognizerState:NO];
    [searchBarBible resignFirstResponder];//隐藏输入键盘
    [self movePanelsRangeTabview:NO];
    
    NSString* str = [[NSString alloc] initWithFormat:@"找到 %d 个结果",searchArr.count];
    NSMutableAttributedString *numberStr =  [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:[ChristUtils getStringByInt:searchArr.count]];
    [numberStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    numberResults.attributedText = numberStr;
    [searchTabview reloadData];
}

- (void)keyboardDidShow:(NSNotification *)aNotification {
    [SysDelegate.viewHome setRecognizerState:YES];
}

- (void)keyboardDidHide:(NSNotification *)aNotification {
    [SysDelegate.viewHome setRecognizerState:NO];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [searchBarBible resignFirstResponder];
    [SysDelegate.viewHome setRecognizerState:NO];
    
    if (tableView == sRangeTabview) {
        [self movePanelsRangeTabview:NO];
        sRangeTitle.text = [sRangeArr objectAtIndex:indexPath.row];
        searchRangeArr = [self getSearchRangeArr:sRangeTitle.text];
        
        if (searchBarBible.text && searchBarBible.text.length > 0) {
            searchArr = [self searchVolume:searchRangeArr strSearch:searchBarBible.text];
          
            NSString* str = [[NSString alloc] initWithFormat:@"找到 %d 个结果",searchArr.count];
            NSMutableAttributedString *numberStr =  [[NSMutableAttributedString alloc] initWithString:str];
            NSRange range = [str rangeOfString:[ChristUtils getStringByInt:searchArr.count]];
            [numberStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            numberResults.attributedText = numberStr;
            [searchTabview reloadData];
        }else{
            searchArr = nil;
            numberResults.attributedText = nil;
            [searchTabview reloadData];   
        }
    }else if (tableView == searchTabview){
        //跳转到圣经阅读页面
        int VCS = [[searchArr objectAtIndex:indexPath.row] intValue];
        int volume = VCS/1000000;
        int chapter = (VCS - volume*1000000)/1000;
        int section = VCS - volume*1000000 - chapter*1000;
        
//        [SysDelegate.viewHome switchPage:<#(id)#> dic:<#(NSDictionary *)#> animationType:<#(NSString *)#>]
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == sRangeTabview) {
        return sRangeArr.count;
    } else if (tableView == searchTabview){
        return searchArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (tableView == sRangeTabview) {
        UILabel* labtitle = (UILabel*)[cell.contentView viewWithTag:1000];
        if (labtitle == nil) {
            labtitle = [ChristUtils labelWithTxt:[sRangeArr objectAtIndex:indexPath.row]
                                                    frame:cell.contentView.frame
                                                     font:[UIFont fontWithName:@"Arial" size:15]
                                                    color: [UIColor blackColor]];
            labtitle.tag = 1000;
            [cell.contentView addSubview:labtitle];
        }else{
            labtitle.text = [sRangeArr objectAtIndex:indexPath.row];
        }
        
        UILabel* labline = (UILabel*)[cell.contentView viewWithTag:1001];
        if (labline == nil) {
            UILabel *labline =  [ChristUtils labelWithTxt:nil frame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, 320, 0.5) font:nil color:nil];
            labline.backgroundColor = [UIColor orangeColor];
            labline.tag = 1001;
            [cell.contentView addSubview:labline];
        }
    }else if (tableView == searchTabview){
        int VCS = [[searchArr objectAtIndex:indexPath.row] intValue];
        int volume = VCS/1000000;
        int chapter = (VCS - volume*1000000)/1000;
        int section = VCS - volume*1000000 - chapter*1000;
        
        NSString* title = [[[ChristModel shareModel] getBibleTiltleArr] objectAtIndex:(volume - 1)];
        title = [[title componentsSeparatedByString:@","] objectAtIndex:0];
        NSString* str = [[NSString alloc] initWithFormat:@"%d:%d",chapter,section];
        NSString* text = [[[ChristModel shareModel] getBibleVolumeIndex:volume] getSectionText:chapter sectionIndex:section];
        title = [title stringByAppendingString:@" "];
        title = [title stringByAppendingString:str];
 
        
        cell.textLabel.text = title;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:10];
        [cell.textLabel setTextColor:[UIColor grayColor]];
        

        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
        cell.detailTextLabel.numberOfLines = 2;
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
        NSMutableAttributedString *attStr =  [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [text rangeOfString:searchBarBible.text];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        cell.detailTextLabel.attributedText = attStr;

        UILabel* labline = (UILabel*)[cell.contentView viewWithTag:1002];
        if (labline == nil) {
            UILabel *labline =  [ChristUtils labelWithTxt:nil frame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, 320, 0.5) font:nil color:nil];
            labline.backgroundColor = [UIColor orangeColor];
            labline.tag = 1002;
            [cell.contentView addSubview:labline];
        }
    }

    return cell;
}

@end
