//
//  ChristManagedCoreDate.m
//  Bible
//
//  Created by yons on 14-6-6.
//  Copyright (c) 2014年 pquanshan. All rights reserved.
//

#import "ChristUtils.h"
#import "ChristConfig.h"
#import "ChristManagedCoreDate.h"

@implementation ChristManagedCoreDate
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(id)init{
    [self managedObjectModel];
    [self managedObjectContext];
    [self persistentStoreCoordinator];
    return self;
}

//托管对象
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel!=nil) {
        return _managedObjectModel;
    }
    //    NSURL* modelURL=[[NSBundle mainBundle] URLForResource:@"CoreDataExample" withExtension:@"momd"];
    //    _managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _managedObjectModel=[NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

//托管对象上下文
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext!=nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator* coordinator=[self persistentStoreCoordinator];
    if (coordinator!=nil) {
        _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

//持久化存储协调器
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator!=nil) {
        return _persistentStoreCoordinator;
    }
    //    NSURL* storeURL=[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreaDataExample.CDBStore"];
    //    NSFileManager* fileManager=[NSFileManager defaultManager];
    //    if(![fileManager fileExistsAtPath:[storeURL path]])
    //    {
    //        NSURL* defaultStoreURL=[[NSBundle mainBundle] URLForResource:@"CoreDataExample" withExtension:@"CDBStore"];
    //        if (defaultStoreURL) {
    //            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
    //        }
    //    }
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL* storeURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"christbible_note_data.sqlite"]];
    DebugLog(@"path is %@",storeURL);
    NSError* error=nil;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        DebugLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}

//插入数据 不对外提供的接口
- (BOOL)insertData:(ChristNotes*)notes{
    if (notes == nil || notes.volume == nil || notes.chapter == nil || notes.section ==nil || notes.scriptures == nil) {
        return NO;
    }
    ChristManagedNotes* uNotes =(ChristManagedNotes*)[NSEntityDescription insertNewObjectForEntityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [uNotes setVolume:[notes volume]];
    [uNotes setChapter:[notes chapter]];
    [uNotes setSection:[notes section]];
    [uNotes setScriptures:[notes scriptures]];
    
    if ([notes notes]) {
        [uNotes setNotes:[notes notes]];
    }
    if ([notes tag]) {
        [uNotes setTag:[notes tag]];
    }
    
    NSError* error;
    BOOL isSaveSuccess=[_managedObjectContext save:&error];
    if (!isSaveSuccess) {
        DebugLog(@"Error:%@",error);
        return NO;
    }else{
        DebugLog(@"Save successful!");
        return YES;
    }
}

//查询 notes为空时返回所有数据
-(NSArray*)findData:(ChristNotes*)notes{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [request setEntity:user];
    if (notes && notes.volume && notes.chapter && notes.section) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(volume = %@) AND (chapter = %@) AND (section = %@)",notes.volume,notes.chapter,notes.section];
        [request setPredicate:predicate];
    }

    NSError* error = nil;
    NSMutableArray* mutableFetchResult = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        return nil;
    }else{
        return mutableFetchResult;
    }
}

//查询某一章所有的记录
- (NSArray*)findData:(NSNumber*)volumeIndex chapterIndex:(NSNumber*)chapterIndex{
    if (volumeIndex == nil || chapterIndex ==nil) {
        return nil;
    }
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [request setEntity:user];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(volume = %@) AND (chapter = %@)",volumeIndex,chapterIndex];
    [request setPredicate:predicate];
    
    NSError* error = nil;
    NSMutableArray* mutableFetchResult = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        return nil;
    }else{
        return mutableFetchResult;
    }
}

- (NSArray*)findData:(NSNumber*)volumeIndex chapterIndex:(NSNumber*)chapterIndex sectionIndex:(NSNumber*)sectionIndex{
    if (volumeIndex == nil || chapterIndex == nil || sectionIndex == nil) {
        return nil;
    }
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [request setEntity:user];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(volume = %@) AND (chapter = %@) AND (section = %@)",volumeIndex,chapterIndex,sectionIndex];
    [request setPredicate:predicate];
    
    NSError* error = nil;
    NSMutableArray* mutableFetchResult = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        return nil;
    }else{
        return mutableFetchResult;
    }
}

//笔记
- (NSArray*)findNotesData{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [request setEntity:user];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(notes != nil )"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortv = [[NSSortDescriptor alloc] initWithKey:@"volume" ascending:YES];
    NSSortDescriptor *sortc = [[NSSortDescriptor alloc] initWithKey:@"chapter" ascending:YES];
    NSSortDescriptor *sorts = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortv, sortc, sorts, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError* error = nil;
    NSMutableArray* mutableFetchResult = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        return nil;
    }else{
        return mutableFetchResult;
    }
}
//高亮
- (NSArray*)findHighData{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [request setEntity:user];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tag == 'YES')"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortv = [[NSSortDescriptor alloc] initWithKey:@"volume" ascending:YES];
    NSSortDescriptor *sortc = [[NSSortDescriptor alloc] initWithKey:@"chapter" ascending:YES];
    NSSortDescriptor *sorts = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortv, sortc, sorts, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setFetchBatchSize:20];
    
    NSError* error = nil;
    NSMutableArray* mutableFetchResult = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        return nil;
    }else{
        return mutableFetchResult;
    }
}

//更新
- (BOOL)updateData:(ChristNotes*)notes{
    if (notes == nil || notes.volume == nil || notes.chapter == nil || notes.section ==nil || notes.scriptures == nil) {
        return NO;
    }
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [request setEntity:user];
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"(volume = %@) AND (chapter = %@) AND (section = %@)",notes.volume,notes.chapter,notes.section];
    [request setPredicate:predicate];
    NSError* error = nil;
    NSMutableArray* mutableFetchResult=[[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ( mutableFetchResult == nil || mutableFetchResult.count == 0) {//没有数据直接插入
        return [self insertData:notes];
    }
    DebugLog(@"The count of entry: %i",[mutableFetchResult count]);
    //更新
    for (ChristManagedNotes* uNotes in mutableFetchResult) {
        [uNotes setVolume:[notes volume]];
        [uNotes setChapter:[notes chapter]];
        [uNotes setSection:[notes section]];
        [uNotes setScriptures:[notes scriptures]];
        
        if ([notes notes]) {
            [uNotes setNotes:[notes notes]];
        }
        if ([notes tag]) {
            [uNotes setTag:[notes tag]];
        }
        
    }
    return [_managedObjectContext save:&error];
}

//删除
- (BOOL)deleteData:(ChristNotes*)notes {
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"ChristManagedNotes" inManagedObjectContext:_managedObjectContext];
    [request setEntity:user];
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"(volume = %@) AND (chapter = %@) AND (section = %@)",notes.volume,notes.chapter,notes.section];
    [request setPredicate:predicate];
    NSError* error = nil;
    NSMutableArray* mutableFetchResult=[[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if ( mutableFetchResult == nil) {
        DebugLog(@"Error:%@",error);
        return NO;
    }
    
    DebugLog(@"The count of entry: %i",[mutableFetchResult count]);
    for (ChristManagedNotes* uNotes in mutableFetchResult) {
        [_managedObjectContext deleteObject:uNotes];
    }
    
    return [_managedObjectContext save:&error];
}


@end
