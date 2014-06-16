//
//  ChristTextEditBar.h
//  Bible
//
//  Created by yons on 14-5-29.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChristTextEditBarDelegate <NSObject>
-(void)editBarMessage:(id)target megtype:(int)megtype;
@end

@interface ChristTextEditBar : UIView

@property(nonatomic,strong) NSArray* btnArr;

@property(nonatomic,weak) id<ChristTextEditBarDelegate> delegate;

-(void)restoreHidden;

@end
