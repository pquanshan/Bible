//
//  ChristViewNotesEditor.h
//  Bible
//
//  Created by yons on 14-6-7.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristViewBase.h"
#import <UIKit/UIKit.h>

@interface ChristViewNotesEditor : ChristViewBase<UITextViewDelegate>

@property(nonatomic,strong) NSDictionary* dataInfoDic;

@end
