//
//  Header.h
//  Bible
//
//  Created by yons on 14-8-2.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#ifndef Bible_ChristModelDefine_h
#define Bible_ChristModelDefine_h

typedef enum {
    //界面模式
    ChristViewDaytimeMode = 0,
    ChristViewNightMode,
    
} ChristViewModeType;

typedef enum {
    ChristServerNetD = 100,
    ChristServerNetT,
    ChristServerNetR,
    
    ChristHttpRequest = 200,
    ChristHttpRequestFailed,
    ChristHttpRequestSuccessful,
    
    ChristEupdParsing = 300,
    ChristEupdParsFailed,
    ChristEupdParsSuccessful,

    
    JJHTypeBaiduMobLogEvent = 800,
    JJHTypeBaiduMobEventStart,
    JJHTypeBaiduMobEventEnd,
    JJHTypeBaiduMobPageStart,
    JJHTypeBaiduMobPageEnd,
} ChristMessageType;


#endif
