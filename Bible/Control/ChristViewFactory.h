//
//  ChristViewFactory.h
//  Bible
//
//  Created by yons on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristViewScripture.h"
#import "ChristViewNotes.h"
#import "ChristViewHighlighted.h"
#import "ChristViewPlan.h"
#import "ChristViewSet.h"
#import "ChristViewMenu.h"
#import "ChristViewShowDetails.h"
#import "ChristViewDirectory.h"
#import "ChristViewSearch.h"
#import "ChristViewNotesEditor.h"
#import <Foundation/Foundation.h>

typedef enum {
    ChristViewTypeNull = 100,
    //这个顺序和菜单中页面顺序一直，创建的时候会用到
    ChristViewTypeScripture,
    ChristViewTypeNotes,
    ChristViewTypeHighlighted,
    ChristViewTypePlan,
    ChristViewTypeSet,
    
    //以下页面可以不一致
    ChristViewTypeSearch,
    ChristViewTypeMenu,
    ChristViewTypeShowDetails,
    ChristViewTypeDirectory,
    ChristViewTypeNotesEditor,
    
} ChristViewType;

@interface ChristViewFactory : NSObject

+(ChristViewFactory*)shareViewFactory;

-(ChristViewBase*)viewWithType:(ChristViewType)type frame:(CGRect)frame;

@end
