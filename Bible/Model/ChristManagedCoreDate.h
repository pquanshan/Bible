//
//  ChristManagedCoreDate.h
//  Bible
//
//  Created by yons on 14-6-6.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristManagedNotes.h"
#import "ChristNotes.h"
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface ChristManagedCoreDate : NSObject

@property(strong,nonatomic,readonly)NSManagedObjectModel* managedObjectModel;
@property(strong,nonatomic,readonly)NSManagedObjectContext* managedObjectContext;
@property(strong,nonatomic,readonly)NSPersistentStoreCoordinator* persistentStoreCoordinator;

//- (BOOL)insertData:(ChristNotes*)notes;
- (NSArray*)findData:(NSNumber*)volumeIndex chapterIndex:(NSNumber*)chapterIndex;
- (NSArray*)findData:(NSNumber*)volumeIndex chapterIndex:(NSNumber*)chapterIndex sectionIndex:(NSNumber*)sectionIndex;
- (NSArray*)findData:(ChristNotes*)notes;
//笔记
- (NSArray*)findNotesData;
//高亮
- (NSArray*)findHighData;
- (BOOL)updateData:(ChristNotes*)notes;
- (BOOL)deleteData:(ChristNotes*)notes;

@end
