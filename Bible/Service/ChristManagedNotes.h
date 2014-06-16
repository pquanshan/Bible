//
//  ChristManagedNotes.h
//  Bible
//
//  Created by yons on 14-6-6.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ChristManagedNotes : NSManagedObject

@property(nonatomic)NSNumber* volume;//书卷
@property(nonatomic)NSNumber* chapter;//章
@property(nonatomic)NSNumber* section;//节
@property(nonatomic)NSString* scriptures;//经文
@property(nonatomic)NSString* notes;//笔记
@property(nonatomic)NSString* tag;//高亮

@end
