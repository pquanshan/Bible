//
//  ChristViewHighlighted.h
//  Bible
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristViewBase.h"
#import <UIKit/UIKit.h>

@interface ChristViewHighlighted : ChristViewBase<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray* arrHighlighted;
@property(nonatomic,strong) UITableView* tableView;

@end
