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
#import "ChristMessageContronl.h"


@implementation ChristModel
static ChristModel* _sharedModel = nil;

@synthesize bibledata = _bibledata;
@synthesize notesData = _notesData;
@synthesize bibleTiltleArr = _bibleTiltleArr;

@synthesize messageArray = _messageArray;

+(ChristModel*)shareModel{
	if (!_sharedModel) {
        _sharedModel = [[self alloc]init];
        _sharedModel.bibledata = [[ChristBibleData alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(serviceBack:)
                                                     name:KServiceBack
                                                   object:NULL];
	}
	return _sharedModel;
};

//+(ChristModel*)shareModel{
//    static ChristModel* sharedModel = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        sharedModel = [[self alloc] init];
//    });
//    return sharedModel;
//};
//
//
//-(id)init{
//    self = [super init];
//    if (self) {
//        _sharedModel.bibledata = [[ChristBibleData alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(serviceBack:)
//                                                     name:KServiceBack
//                                                   object:NULL];
//    }
//    return self;
//}

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

- (int)getDetailsViewType{
    return [[SysDelegate.viewHome viewShowDetails] viewType];
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

#pragma mark - service back
- (void)serviceBack:(NSNotification*)inNotification{
    NSMutableDictionary* dic = [inNotification object];
    if(dic){
        int type = [[dic objectForKey:KType]intValue];
        
        for (ChristMessageContronl* message in _messageArray) {
            if ([message messageType] == type) {
                DebugLog(@"serviceBack type = %d", type);
                [message sendMessage:dic];
                return;
            }
        }
        if (_messageArray == nil) {
            _messageArray = [[NSMutableArray alloc]init];
        }
    }
}

-(NSMutableDictionary*)getMeesageDic:(NSDictionary*)valueDic type:(ChristMessageType)type{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];

    [dic setObject:[NSNumber numberWithInt:type] forKey:KType];
    if (valueDic) {
        [dic setObject:valueDic forKey:KValue];
    }
    
    return dic;
}

-(void)subscribeMessage:(ChristMessageType)type delegate:(id)delegate{
    if (_messageArray == nil) {
        _messageArray = [[NSMutableArray alloc]init];
    }
    
    for (ChristMessageContronl* message in _messageArray) {
        if ([message messageType] == type) {
            [message addDelegate:delegate];
            return;
        }
    }
    
    ChristMessageContronl* messageControl = [[ChristMessageContronl alloc]init];
    [messageControl setMessageType:type];
    [messageControl addDelegate:delegate];
    
    [_messageArray addObject:messageControl];
    
}

-(void)unSubscribeMessage:(ChristMessageType)type delegate:(id)delegate{
    if (_messageArray) {
        for (ChristMessageContronl* message in _messageArray) {
            if ([message messageType] == type) {
                if ([message delDelegate:delegate] == 0) {
                }
                return;
            }
        }
    }
}

-(BOOL)isSubscribeMessage:(ChristMessageType)type delegate:(id)delegate{
    if (_messageArray) {
        for (ChristMessageContronl* message in _messageArray) {
            if ([message messageType] == type && [message haveDelegate:delegate]) {
                return YES;
                break;
            }
        }
    }
    return NO;
}



@end
