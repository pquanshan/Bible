//
//  ChristViewSet.m
//  Bible
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristModel.h"
#import "ChristViewSet.h"

@interface ChristViewSet(){
    UIView* navigationView;
}
@end

@implementation ChristViewSet
@synthesize arrSetMenu = _arrSetMenu;
@synthesize tabView = _tabView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:RGBCOLOR(230,130,130)];
        UILabel* lab = [ChristUtils labelWithTxt:@"ChristViewSet" frame:self.frame font:[UIFont fontWithName:@"Arial" size:30] color:[UIColor blackColor]];
        [self addSubview:lab];
        
        NSMutableDictionary* resdic = LOADDIC(@"christ", @"plist");
        _arrSetMenu = [resdic objectForKey:KPChrisSetMenu];
        [self initTabView];
        [self initNavigation];
    }
    return self;
}

#pragma mark - init
-(void)initNavigation{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, KNavigationHeight)];
    [navigationView setBackgroundColor:RGBCOLOR(220,230,210)];
    [self addSubview:navigationView];
    
    UILabel* title = [ChristUtils labelWithTxt:@"设置"
                                         frame:CGRectMake(navigationView.frame.size.width/2 - 100, 0, 200, KNavigationHeight)
                                          font:[UIFont fontWithName:@"Arial" size:18]
                                         color:[UIColor blackColor]];
    [navigationView addSubview:title];
}

-(void)initTabView{
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                             KStatusBarHeight + KNavigationHeight + navigationView.frame.size.height,
                                                             self.frame.size.width,
                                                             self.frame.size.height - KStatusBarHeight - navigationView.frame.size.height - KNavigationHeight)
                                            style:UITableViewStyleGrouped];
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.rowHeight = 40;
    [_tabView setBackgroundColor:RGBCOLOR(230,220,210)];
    _tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:_tabView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_arrSetMenu objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrSetMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[_arrSetMenu objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    return cell;
}

@end
