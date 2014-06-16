//
//  ChristViewHome.m
//  Bible
//
//  Created by yons on 14-5-27.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//


#define KPanelViewWidth (100)

#import "ChristViewSearch.h"
#import "ChristViewHome.h"
#import "ChristConfig.h"
#import "ChristUtils.h"
#import "ChristModel.h"
#import "ChristViewFactory.h"

@interface ChristViewHome (){
    float preTransX;
    UIPanGestureRecognizer *panRecognizer;
}

@end

@implementation ChristViewHome

@synthesize viewMenu = _viewMenu;
@synthesize viewShowDetails = _viewShowDetails;
@synthesize isMenuOpening = _isMenuOpening;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initViewMenu];
    [self initViewShowDetails];
    [self.view addSubview:_viewMenu];
    [self.view addSubview:_viewShowDetails];
    
    _isMenuOpening = NO;
    [self setupGestures];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void)initViewMenu{
    _viewMenu =  (ChristViewMenu*)[[ChristViewFactory shareViewFactory] viewWithType:ChristViewTypeMenu
                                                 frame:CGRectMake(-KPanelViewWidth, 0, KPanelViewWidth, self.view.frame.size.height)];
//    _viewMenu.delegate = self;
    
}

- (void)initViewShowDetails{
    _viewShowDetails = (ChristViewShowDetails*)[[ChristViewFactory shareViewFactory] viewWithType:ChristViewTypeShowDetails
                                                                                                frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - internal function
- (BOOL)getIsHide:(NSArray*)notsArr sindex:(int)sindex{
    BOOL bl = NO;
    if (notsArr && notsArr.count > 0) {
        for (ChristManagedNotes *notes in notsArr) {
            if ([notes.section intValue] == sindex && [notes.tag isEqualToString:@"YES"]) {
                bl = YES;
                break;
            }
        }
    }
    return bl;
}

//刷新界面模式
-(void)refreshSurrentView{
    if ([_viewShowDetails.currentView isKindOfClass:[ChristViewScripture class]]) {
        ChristViewScripture* scripture = (ChristViewScripture*)_viewShowDetails.currentView;
        [_viewShowDetails setBackgroundColor:[[ChristModel shareModel] getBodyBackColor]];
        [scripture setViewMode];
    }
}

#pragma mark - interface function
-(BOOL)getMenuOpening{
    return _isMenuOpening;
}

-(void)switchPage:(id)target dic:(NSDictionary *)dic animationType:(NSString *)animationType{
    if (dic == nil) {
        _isMenuOpening = YES;
        [self movePanelShowMenu:YES];
    }else{
        _isMenuOpening = NO;
        [self movePanelShowMenu:NO];
        //切换页面
        if ([dic objectForKey:KViewPageType]) {
            int viewtype = [[dic objectForKey:KViewPageType] intValue];
            ChristViewBase* nextView = [[ChristViewFactory shareViewFactory] viewWithType:viewtype frame:_viewShowDetails.frame];
            [_viewShowDetails switchPage:_viewShowDetails.currentView nextView:nextView dic:dic animationType:animationType];
        }else{
            return;
        }
        
    }
}

-(void)setRecognizerState:(BOOL)bl{
    panRecognizer.enabled = !bl;
}


#pragma mark - ChrisScriptureDelegate
-(void)singleTap:(id)target recognizer:(UITapGestureRecognizer *)recognizer bl:(BOOL)bl{
    panRecognizer.enabled = bl;
}

-(void)longPress:(id)target recognizer:(UITapGestureRecognizer *)recognizer bl:(BOOL)bl{

}

#pragma mark - ChristTextEditBarDelegate
-(void)editBarMessage:(id)target megtype:(int)megtype{
    ChristViewScripture* scripture = nil;
    if (![_viewShowDetails.currentView isKindOfClass:[ChristViewScripture class]]) {
        return;
    }else{
        scripture = (ChristViewScripture*)_viewShowDetails.currentView;
    }
    
    switch (megtype) {
        case 0://点击搜索
        {
            NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
            [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeSearch] forKey:KViewPageType];
            [mtDic setObject:[ChristUtils getStringByInt:[scripture getvolumeIndex]] forKey:KUserSaveVolume];
            [mtDic setObject:[ChristUtils getStringByInt:[scripture getChapterIndex]] forKey:KUserSaveChapter];
            [self switchPage:nil dic:mtDic animationType:kCATransitionFromBottom];
        }
            break;
        case 1:
        {
            [scripture.tableView  reloadData];
        }
            break;
        case 2:
        {
            [self refreshSurrentView];
        }
            break;
        case 3://阅读
        {
            [scripture setReadModel];
        }
            break;
        case 4://复制
        {
            if ([scripture getSectionIndex] == 0) {
                //没有选择第几行
                return;
            }else{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [scripture getSectionText];
                //复制到粘帖板 分享提示框
                [ChristUtils showAlertView:@"耶稣爱你" message:[scripture getSectionText] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:@"分享", nil];
            }
        }
            break;
        case 5://高亮
        {
            if ([scripture getSectionIndex] == 0) {
                //没有选择第几行
                return;
            }else{
                ChristNotes* notes = [[ChristNotes alloc] init];
                notes.volume =  [ChristUtils getNumberByInt:[scripture getvolumeIndex]];
                notes.chapter = [ChristUtils getNumberByInt:[scripture getChapterIndex]];
                notes.section = [ChristUtils getNumberByInt:[scripture getSectionIndex]];
                notes.scriptures = [scripture getSectionText];
                NSArray* notsArr = [[[ChristModel shareModel] getNatesData] findData:[ChristUtils getNumberByInt:[scripture getvolumeIndex]]
                                                                          chapterIndex:[ChristUtils getNumberByInt:[scripture getChapterIndex]]];
                if ([self getIsHide:notsArr sindex:[scripture getSectionIndex]]) {
                    notes.tag = @"NO";
                }else{
                    notes.tag = @"YES";
                }
                [[[ChristModel shareModel] getNatesData] updateData:notes];
                [scripture setNotsArr];
            }
        }
            break;
        case 6://笔记
        {
                if ([scripture getSectionIndex] == 0) {
                    //没有选择第几行
                    return;
                }else{
                    NSMutableDictionary *mtDic = [[NSMutableDictionary alloc] init];
                    [mtDic setObject:[ChristUtils getStringByInt:[scripture getvolumeIndex]] forKey:KUserSaveVolume];
                    [mtDic setObject:[ChristUtils getStringByInt:[scripture getChapterIndex]] forKey:KUserSaveChapter];
                    [mtDic setObject:[ChristUtils getStringByInt:[scripture getSectionIndex]] forKey:KUserSaveSection];
                    [mtDic setObject:[scripture getSectionText] forKey:KNotesContentText];
                    [mtDic setObject:[ChristUtils getNumberByInt:ChristViewTypeNotesEditor] forKey:KViewPageType];
                    [self switchPage:nil dic:mtDic animationType:kCATransitionFromTop];
                }
        }
            break;
        case 100:
        {
            [scripture statusChange];
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        DebugLog(@"我知道了");
    }else if (buttonIndex == 1){
        DebugLog(@"分享");
    }
}


#pragma mark - UIPanGestureRecognizer
-(void)setupGestures {
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
    [self.view setUserInteractionEnabled:YES];
	[self.view addGestureRecognizer:panRecognizer];
     panRecognizer.enabled = NO;
}

-(void)movePanel:(id)sender {
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        preTransX = 0;
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if ((translatedPoint.x > 0 && !_isMenuOpening) || (translatedPoint.x < 0 && _isMenuOpening)) {
            _isMenuOpening = !_isMenuOpening;
        }
        [self movePanelShowMenu:_isMenuOpening];
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        float offx = translatedPoint.x - preTransX;
        float x = _viewMenu.center.x + offx;
        if (x >= -KPanelViewWidth / 2 && x <= KPanelViewWidth / 2) {
            _viewMenu.center = CGPointMake(_viewMenu.center.x + offx, _viewMenu.center.y);
            _viewShowDetails.center = CGPointMake(_viewShowDetails.center.x + offx, _viewShowDetails.center.y);
            preTransX = translatedPoint.x;
        }
	}
}

-(void)movePanelShowMenu:(BOOL)bl{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (bl) {
            [_viewMenu setFrame:CGRectMake(0, 0, KPanelViewWidth, self.view.frame.size.height)];
            [_viewShowDetails setFrame:CGRectMake(KPanelViewWidth, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }else{
            [_viewMenu setFrame:CGRectMake(-KPanelViewWidth, 0, KPanelViewWidth, self.view.frame.size.height)];
            [_viewShowDetails setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }];
    
    
}


@end
