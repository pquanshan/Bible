//
//  ChristViewHome.h
//  Bible
//
//  Created by yons on 14-5-27.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristViewMenu.h"
#import "ChristViewShowDetails.h"
#import "ChristViewScripture.h"
#import "ChristTextEditBar.h"
#import "ChristViewDirectory.h"
#import "ChristScriptureCell.h"
#import "ChristViewSearch.h"
#import <UIKit/UIKit.h>

@interface ChristViewHome : UIViewController<ChrisScriptureDelegate,ChristTextEditBarDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) ChristViewMenu* viewMenu;
@property(nonatomic,strong) ChristViewShowDetails* viewShowDetails;

@property(assign) BOOL isMenuOpening;

-(void)switchPage:(id)target dic:(NSDictionary*)dic animationType:(NSString*)animationType;
-(void)setRecognizerState:(BOOL)bl;


@end
