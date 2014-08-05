//
//  ChristViewShowDetails.m
//  Bible
//
//  Created by yons on 14-5-27.
//
//

#import "ChristConfig.h"
#import "ChristModel.h"
#import "ChristUtils.h"

@implementation ChristViewShowDetails

@synthesize currentView = _currentView;
@synthesize viewType = _viewType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[[ChristModel shareModel] getBodyBackColor]];
        [self initView];
    }
    return self;
}

#pragma mark - init
-(void)initView{
    _viewType = ChristViewTypeScripture;
    _currentView = [[ChristViewFactory shareViewFactory] viewWithType:_viewType frame:self.frame];
    [self addSubview:_currentView];
}

#pragma mark - interface function
-(void)switchPage:(ChristViewBase*)currentView nextView:(ChristViewBase*)nextView  dic:(NSMutableDictionary*)dic  animationType:(NSString *)animationType{
    //先设置之前页面类型
    [dic setObject:[ChristUtils getNumberByInt:[[ChristModel shareModel] getDetailsViewType]] forKey:KViewPrevPageType];
    
    int viewtype = [[dic objectForKey:KViewPageType] intValue];
    [_currentView viewDisappear];
    [_currentView removeFromSuperview];
    _currentView = nextView;
    [self addSubview:_currentView];
    [_currentView viewAppear];
    [_currentView setDic:dic];
    _viewType = viewtype;
    
    //页面跳转与动画
    if (animationType) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = animationType;
        [self exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
        [self.layer addAnimation:transition forKey:@"animation"];
    }
}


@end
