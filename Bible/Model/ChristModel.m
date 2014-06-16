//
//  ChristModel.m
//  Bible
//
//  Created by yons on 14-6-5.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristModel.h"


@implementation ChristModel
static ChristModel* _sharedModel = nil;

@synthesize bibledata = _bibledata;
@synthesize notesData = _notesData;
@synthesize bibleTiltleArr = _bibleTiltleArr;

+(ChristModel*)shareModel{
	if (!_sharedModel) {
        _sharedModel = [[self alloc]init];
        _sharedModel.bibledata = [[ChristBibleData alloc] init];
	}
	return _sharedModel;
};

-(NSArray*)getBibleTiltleArr{
    if (_bibleTiltleArr == nil) {
        NSMutableDictionary* resdic = LOADDIC(@"christ", @"plist");
        _bibleTiltleArr = [resdic objectForKey:KPCutVolumeTitle];
    }
    return _bibleTiltleArr;
}

-(ChristManagedCoreDate*)getNatesData{
    if (_notesData == nil) {
        _notesData = [[ChristManagedCoreDate alloc] init];
    }
    return _notesData;
}

-(BOOL)getBibleParsState{
    return _bibledata.isbibleAll;
}

-(NSArray*)getBibleTextArr{
    if ([self getBibleParsState]) {
        return [_bibledata bibleTextArr];
    }else{
        return nil;
    }
}

-(NSArray*)getUnBibleTextArr{
    return _bibledata.unBibleTextArr;
}

-(ChristChapterEpub*)getBibleVolumeIndex:(int)index{
    if ([self getBibleParsState]) {
        return [[_bibledata bibleTextArr] objectAtIndex:index];
    }else{
        return nil;
    }
}

-(ChristViewModeType)getViewMode{
    NSString* vmtype = [ChristUtils getDataByKey:KUserViewMode];
    if (vmtype) {
        return [vmtype intValue];
    }else{
        return ChristViewDaytimeMode;
    }
}



-(UIColor*)getNavBackColor{
    UIColor* color = [UIColor grayColor];
    switch ([self getViewMode]) {
        case ChristViewDaytimeMode:
            color = [UIColor grayColor];
            break;
        case ChristViewNightMode:
            color = [UIColor grayColor];
            break;
        default:
            break;
    }
    return color;
}

-(UIColor*)getNavTitleTextColor{
    UIColor* color = [UIColor whiteColor];
    switch ([self getViewMode]) {
        case ChristViewDaytimeMode:
            color = [UIColor whiteColor];
            break;
        case ChristViewNightMode:
            color = [UIColor whiteColor];
            break;
        default:
            break;
    }
    return color;
}

-(UIColor*)getBodyBackColor{
    UIColor* color = [UIColor whiteColor];
    switch ([self getViewMode]) {
        case ChristViewDaytimeMode:
            color = [UIColor whiteColor];
            break;
        case ChristViewNightMode:
            color = [UIColor blackColor];
            break;
        default:
            break;
    }
    return color;

}

-(UIColor*)getBodyTextColor{
    UIColor* color = [UIColor blackColor];
    switch ([self getViewMode]) {
        case ChristViewDaytimeMode:
            color = [UIColor blackColor];
            break;
        case ChristViewNightMode:
            color = [UIColor whiteColor];
            break;
        default:
            break;
    }
    return color;
}

-(UIFont*)getBodyTextFont{
    NSString* sizestr = [ChristUtils getDataByKey:KUserFontSize];
    if (sizestr) {
        return [UIFont fontWithName:@"Arial" size:[sizestr intValue]];
    }else{
        return [UIFont fontWithName:@"Arial" size:15];
    }
}



@end
