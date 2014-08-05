//
//  ChristConfig.h
//  Bible
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#ifndef Bible_ChristConfig_h
#define Bible_ChristConfig_h

#define IsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //是否为pad判断
#define MyLocal(x, ...) NSLocalizedString(x, nil)       //定义国际化使用

//日志输出定义
#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif

#define KSafeRelease(a)     if(a){delete a;a = nil;}
#define KRelease(a)     if(a){a = nil;}

//颜色取值宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//document地址
#define GetDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask , YES) objectAtIndex:0]

//取图片宏
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//取字典宏
#define LOADDIC(file,ext) [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//系统版本判断
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//判断设备是否为长屏，即640 * 1136
#define isIPhone5Size ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


//Plist键值
#define KPListChristMenu            @"pchristmenu"
#define KPListMemuTitle             @"memutitle"
#define KPListMemuPageType          @"memupagetype"
#define KPChrisSetMenu              @"pchrissetmenu"

#define KPCutVolumeTitle            @"pchriscutvolumetitle"

#define KPQuickSetMenu              @"pchristquicksetmenu"
#define KPQuickEditMenu             @"pchristquickeditmenu"
#define KPQuickSetMenuTitle         @"quickmemutitle"
#define KPQuickSetMenuType          @"quickmemutype"

#define KSmallChapter               @"smallchapter%d"
#define KSChapterSection            @"%d:%d"


//NSNotificationCenter
#define KServiceBack                @"service_back"

//
#define KViewPrevPageType           @"viewprevpagetype"
#define KViewPageType               @"viewpagetype"
#define KViewData                   @"viewdata"

//保存的书卷，章节
#define KUserSaveVolume             @"usersavevolume"
#define KUserSaveChapter            @"usersavechapter"
#define KUserSaveSection            @"usersavesection"
#define KNotesContentText           @"notescontenttext"
//保存页面模式
#define KUserViewMode               @"userviewmode"
//用户设置的字体
#define KUserFontSize               @"userfontsize"


#define KNavigationHeight           (44)
#define KStatusBarHeight            (20)
#define KTabButtonHeight            (44)
#define KTabButtonHeight1           (36)
#define KDefaultHeight              (44)

#define KCellOff                    (8)
#define KCellMarkHeight             (20)
#define KCellDefaultHeight          (40)

#define KBibleVolumeNumber          (67)//实际圣经总共66卷，解析过后第一卷是空的
#define KBibleOldVolumeNumber       (39)//旧约
#define KBibleNewVolumeNumber       (27)//新约

//资源Key值宏定义
#define KValue                  @"value"
#define KType                   @"type"

#endif
