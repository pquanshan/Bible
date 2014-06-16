//
//  ChristViewShowDetails.h
//  Bible
//
//  Created by yons on 14-5-27.
//
//

#import "ChristViewBase.h"
#import "ChristViewFactory.h"
#import <UIKit/UIKit.h>


@interface ChristViewShowDetails : ChristViewBase

@property(nonatomic,strong)ChristViewBase* currentView;//当前页面显示的视图
@property(assign) ChristViewType viewType;//当前显示页面视图类型

-(void)switchPage:(ChristViewBase*)currentView nextView:(ChristViewBase*)nextView  dic:(NSMutableDictionary*)dic  animationType:(NSString *)animationType;

@end
