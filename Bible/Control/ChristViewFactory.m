//
//  ChristViewFactory.m
//  Bible
//
//  Created by yons on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristViewFactory.h"


static ChristViewFactory* _shareViewFactory = nil;

@interface ChristViewFactory ()

@property(nonatomic, strong)NSMutableDictionary* viewDic;

@end

@implementation ChristViewFactory

+(ChristViewFactory*)shareViewFactory{
	if (!_shareViewFactory) {
        _shareViewFactory = [[self alloc]init];
	}
    
	return _shareViewFactory;
};

-(ChristViewBase*)viewWithType:(ChristViewType)type frame:(CGRect)frame{
    if (_viewDic == nil) {
        _viewDic = [[NSMutableDictionary alloc]init];
    }
    ChristViewBase* view = [_viewDic objectForKey:[ChristUtils getStringByInt:type]];
    if (view == nil) {
        switch (type) {
            case ChristViewTypeScripture:
                view = [[ChristViewScripture alloc] initWithFrame:frame];
                break;
            case ChristViewTypeNotes:
                view = [[ChristViewNotes alloc] initWithFrame:frame];
                break;
            case ChristViewTypeHighlighted:
                view = [[ChristViewHighlighted alloc] initWithFrame:frame];
                break;
            case ChristViewTypePlan:
                view = [[ChristViewPlan alloc] initWithFrame:frame];
                break;
            case ChristViewTypeSet:
                view = [[ChristViewSet alloc] initWithFrame:frame];
                break;
            case ChristViewTypeMenu:
                view = [[ChristViewMenu alloc] initWithFrame:frame];
                break;
            case ChristViewTypeShowDetails:
                view = [[ChristViewShowDetails alloc] initWithFrame:frame];
                break;
            case ChristViewTypeDirectory:
                view = [[ChristViewDirectory alloc] initWithFrame:frame];
                break;
            case ChristViewTypeSearch:
                view = [[ChristViewSearch alloc] initWithFrame:frame];
                break;
            case ChristViewTypeNotesEditor:
                view = [[ChristViewNotesEditor alloc] initWithFrame:frame];
                break;
                
            default:
                break;
        }
        if (view) {
            [_viewDic setObject:view forKey:[ChristUtils getStringByInt:type]];
        }
    }else{
        view.frame = frame;
    }
    return view;
}

@end
