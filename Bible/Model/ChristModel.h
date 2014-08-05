//
//  ChristModel.h
//  Bible
//
//  Created by yons on 14-6-5.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristBibleData.h"
#import "ChristManagedCoreDate.h"
#import "ChristModelDefine.h"
#import <Foundation/Foundation.h>

@interface ChristModel : NSObject

+(ChristModel*)shareModel;

@property(nonatomic) ChristBibleData*  bibledata;
@property(nonatomic) ChristManagedCoreDate* notesData;
@property(nonatomic) NSArray* bibleTiltleArr;

@property(nonatomic, strong)NSMutableArray* messageArray;

//plist中圣经标题信息
-(NSArray*)getBibleTiltleArr;
//获取数据库
-(ChristManagedCoreDate*)getNatesData;
//获取圣经解析状态
-(BOOL)getBibleParsState;
//获取未完全解析的圣经
-(NSArray*)getUnBibleTextArr;
//获取一个书卷的解析内容
-(ChristChapterEpub*)getBibleVolumeIndex:(int)index;
//获取界面模式
-(ChristViewModeType)getViewMode;
//获取导航栏背景颜色
-(UIColor*)getNavBackColor;
//获取导航栏上标题文本颜色
-(UIColor*)getNavTitleTextColor;
//获取正文背景颜色
-(UIColor*)getBodyBackColor;
//获取正文文本颜色
-(UIColor*)getBodyTextColor;
//获取正文字体大小
-(UIFont*)getBodyTextFont;

//获取显示view类型
- (int)getDetailsViewType;

//消息订阅相关
-(void)subscribeMessage:(ChristMessageType)type delegate:(id)delegate;
-(void)unSubscribeMessage:(ChristMessageType)type delegate:(id)delegate;
-(BOOL)isSubscribeMessage:(ChristMessageType)type delegate:(id)delegate;
-(NSMutableDictionary*)getMeesageDic:(NSDictionary*)valueDic type:(ChristMessageType)type;





@end
