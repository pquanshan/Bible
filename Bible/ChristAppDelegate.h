//
//  ChristAppDelegate.h
//  Bible
//
//  Created by yons on 14-5-27.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristViewHome.h"
#import <UIKit/UIKit.h>

@interface ChristAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ChristViewHome *viewHome;
@property (nonatomic, strong) UINavigationController *navigationController;

@end
