//
//  ChristViewNotes.m
//  Bible
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristModel.h"
#import "ChristConfig.h"
#import "ChristViewNotes.h"

@interface ChristViewNotes(){
    UIView* navigationView;
}
@end

@implementation ChristViewNotes
@synthesize arrNotes = _arrNotes;
@synthesize tableView = _tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:RGBCOLOR(30,330,130)];
        UILabel* lab = [ChristUtils labelWithTxt:@"ChristViewNotes" frame:self.frame font:[UIFont fontWithName:@"Arial" size:30] color:[UIColor blackColor]];
        [self addSubview:lab];
        _arrNotes = [[[ChristModel shareModel] getNatesData] findNotesData];
        [self initNavigation];
        [self initTableView];
    }
    return self;
}

-(void)viewAppear{
    [self setArrNotes:nil];
}

#pragma mark - init
-(void)initNavigation{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, KNavigationHeight)];
    [navigationView setBackgroundColor:RGBCOLOR(220,230,210)];
    [self addSubview:navigationView];
    
     UILabel* title = [ChristUtils labelWithTxt:@"笔记"
                                     frame:CGRectMake(navigationView.frame.size.width/2 - 100, 0, 200, KNavigationHeight)
                                      font:[UIFont fontWithName:@"Arial" size:18]
                                     color:[UIColor blackColor]];
    [navigationView addSubview:title];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight + KNavigationHeight, self.frame.size.width, self.frame.size.height - KStatusBarHeight - KNavigationHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

#pragma mark - internal function
- (NSString*)getDetailText:(ChristManagedNotes*)managrdNotes{
    NSString* volume = [ChristUtils getStringByInt:[[managrdNotes volume] intValue]];
    NSString* chapter = [ChristUtils getStringByInt:[[managrdNotes chapter] intValue]];
    NSString* section = [ChristUtils getStringByInt:[[managrdNotes section] intValue]];
    NSString* title = [[[ChristModel shareModel] getBibleTiltleArr] objectAtIndex:([volume intValue] - 1)];
    title = [[title componentsSeparatedByString:@","] objectAtIndex:1];
    title = [title stringByAppendingString:@" "];
    title = [title stringByAppendingString:chapter];
    title = [title stringByAppendingString:@":"];
    title = [title stringByAppendingString:section];
    return title;
}

#pragma mark - interface function
-(void)setArrNotes:(NSArray *)arrNotes{
    if (arrNotes == nil) {
        _arrNotes = [[[ChristModel shareModel] getNatesData] findNotesData];
    }else{
        _arrNotes = arrNotes;
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![SysDelegate.viewHome isMenuOpening]) {
        ChristManagedNotes* managrdNotes = [_arrNotes objectAtIndex:indexPath.row];
        NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
        [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeNotesEditor] forKey:KViewPageType];
        [mtDic setObject:[managrdNotes volume] forKey:KUserSaveVolume];
        [mtDic setObject:[managrdNotes chapter] forKey:KUserSaveChapter];
        [mtDic setObject:[managrdNotes section] forKey:KUserSaveSection];
        [mtDic setObject:[managrdNotes scriptures] forKey:KNotesContentText];
        
        [SysDelegate.viewHome switchPage:self dic:mtDic animationType:kCATransitionFromTop];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrNotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:RGBCOLOR(240,240,240)];
    }
    
    ChristManagedNotes* managrdNotes = [_arrNotes objectAtIndex:indexPath.row];
    cell.textLabel.text = [managrdNotes notes];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    
    cell.detailTextLabel.text  = [self getDetailText:managrdNotes];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:13];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    
    
    UILabel* labline = (UILabel*)[cell.contentView viewWithTag:1000];
    if (labline == nil) {
        labline =  [ChristUtils labelWithTxt:nil frame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, 320, 0.5) font:nil color:nil];
        labline.backgroundColor = RGBCOLOR(30,330,130);
        labline.tag = 1000;
        [cell.contentView addSubview:labline];
    }
    return cell;
}

@end
