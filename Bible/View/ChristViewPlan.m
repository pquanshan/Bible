//
//  ChristViewPlan.m
//  Bible
//
//  Created by apple on 14-5-28.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristViewPlan.h"

@interface ChristViewPlan(){
    UIView* navigationView;
}
@end

@implementation ChristViewPlan

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:RGBCOLOR(130,130,230)];
        UILabel* lab = [ChristUtils labelWithTxt:@"ChristViewPlan" frame:self.frame font:[UIFont fontWithName:@"Arial" size:30] color:[UIColor blackColor]];
        [self addSubview:lab];
        [self initNavigation];
    }
    return self;
}

#pragma mark - init
-(void)initNavigation{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, self.frame.size.width, KNavigationHeight)];
    [navigationView setBackgroundColor:RGBCOLOR(220,230,210)];
    [self addSubview:navigationView];
    
    UILabel* title = [ChristUtils labelWithTxt:@"计划"
                                         frame:CGRectMake(navigationView.frame.size.width/2 - 100, 0, 200, KNavigationHeight)
                                          font:[UIFont fontWithName:@"Arial" size:18]
                                         color:[UIColor blackColor]];
    [navigationView addSubview:title];
}

@end
