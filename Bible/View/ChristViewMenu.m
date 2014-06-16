//
//  ChristViewMenu.m
//  Bible
//
//  Created by yons on 14-5-27.
//
//

#import "ChristViewMenu.h"
#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristViewFactory.h"

@implementation ChristViewMenu

@synthesize searchBtn = _searchBtn;
@synthesize tableView = _tableView;
@synthesize menuArray = _menuArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor redColor]];
        [self initView];
    }
    return self;
}

#pragma mark - init
- (void)initView{
    [self initSearcBtn];
    [self initTableView];
    [self initMenuArray];
}

-(void)initSearcBtn{
    _searchBtn = [ChristUtils buttonWithImg:@"搜索" off:0 image:nil imagesec:nil target:self action:@selector(searchBtnClicked:)];
    _searchBtn.frame = CGRectMake(0, KStatusBarHeight, self.frame.size.width, KDefaultHeight);
    [self addSubview:_searchBtn];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight + _searchBtn.frame.size.height, self.frame.size.width, self.frame.size.height - _searchBtn.frame.size.height)
                                              style:UITableViewStylePlain] ;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setBackgroundColor:RGBCOLOR(230,230,230)];
    [self addSubview:_tableView];
}

-(void)initMenuArray{
    NSMutableDictionary* resdic = LOADDIC(@"christ", @"plist");
    _menuArray = [resdic objectForKey:KPListChristMenu];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
    
    int type = [[[_menuArray objectAtIndex:indexPath.row] objectForKey:KPListMemuPageType] intValue];
    type += ChristViewTypeNull;
    
    [mtDic setObject:[ChristUtils getNumberByInt:type] forKey:KViewPageType];
    
    [SysDelegate.viewHome switchPage:self dic:mtDic animationType:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setBackgroundColor:RGBCOLOR(230,230,230)];
    }
    cell.textLabel.text = [[_menuArray objectAtIndex:indexPath.row] objectForKey:KPListMemuTitle];
    return cell;
}

#pragma mark - btn clicked
-(void)searchBtnClicked:(id)sender{
    NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
    [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeSearch] forKey:KViewPageType];
    [SysDelegate.viewHome  switchPage:self dic:mtDic animationType:nil];
}

@end
