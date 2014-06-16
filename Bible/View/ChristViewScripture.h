//
//  ChristViewScripture.h
//  Bible
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristViewBase.h"
#import <UIKit/UIKit.h>

@protocol ChrisScriptureDelegate <NSObject>
-(void)singleTap:(id)target recognizer:(UITapGestureRecognizer*)recognizer bl:(BOOL)bl;
-(void)longPress:(id)target recognizer:(UITapGestureRecognizer*)recognizer bl:(BOOL)bl;
@end

@interface ChristViewScripture : ChristViewBase<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) id<ChrisScriptureDelegate> delegate;

@property(nonatomic,strong) UITableView* tableView;

@property (nonatomic,strong) UISwipeGestureRecognizer* rightSwipeRecognizer;//右拖
@property (nonatomic,strong) UISwipeGestureRecognizer* leftSwipeRecognizer;//左拖
@property (nonatomic,strong) UITapGestureRecognizer* singleRecognizer;//点击

-(void)statusChange;

-(void)setViewMode;
-(void)setNotsArr;
-(int)getvolumeIndex;
-(int)getChapterIndex;
-(int)getSectionIndex;
-(NSString*)getSectionText;

-(void)setReadModel;

@end
