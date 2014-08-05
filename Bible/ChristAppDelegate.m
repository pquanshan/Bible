//
//  ChristAppDelegate.m
//  Bible
//
//  Created by yons on 14-5-27.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#import <Frontia/FrontiaPush.h>
#import <Frontia/Frontia.h>

#import "ChristModel.h"
#import "ChristAppDelegate.h"

@implementation ChristAppDelegate
@synthesize viewHome =_viewHome;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化百度 Frontia
    [self initFrontia:launchOptions];
    [ChristModel shareModel];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _viewHome = [[ChristViewHome alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_viewHome];
    _viewHome.navigationController.navigationBarHidden = YES;

    [self.window addSubview:_navigationController.view];
    return YES;
}

#pragma mark - baidu mob stat
-(void)initFrontia:(NSDictionary *)launchOptions{
    //初始化Frontia
    NSString* path = [[NSBundle mainBundle]pathForResource:@"BPushConfig" ofType:@"plist"];
    NSMutableDictionary *infolist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path] mutableCopy];
    NSString* stat_app_key = [infolist objectForKey:@"STAT_APP_KEY"];
    NSString* api_key = [infolist objectForKey:@"API_KEY"];
    
    [Frontia initWithApiKey:api_key];
    [Frontia getPush];
    [FrontiaPush setupChannel:launchOptions];
    
    FrontiaStatistics* statTracker = [Frontia getStatistics];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    //    statTracker.channelId = @"this_is_a_invalid_channel_ID";//设置您的app的发布渠道
    statTracker.logStrategy = FrontiaStatLogStrategyCustom;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 35;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    statTracker.channelId = @"AppStore";
    
    //百度推送前根据版本网络信息设置app_key
    [statTracker startWithReportId:stat_app_key];//设置您在mtj网站上添加的app的appkey
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
