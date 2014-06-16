//
//  ChristViewMenu.h
//  Bible
//
//  Created by yons on 14-5-27.
//
//

#import "ChristViewBase.h"
#import <UIKit/UIKit.h>

@interface ChristViewMenu : ChristViewBase<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIButton* searchBtn;
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) NSArray* menuArray;

@end
