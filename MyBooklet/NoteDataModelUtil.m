//
//  NoteDataModelUtil.m
//  MyBooklet
//
//  Created by wangxiaohong on 3/17/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "NoteDataModelUtil.h"
#import "BookletAppDelegate.h"

static NoteDataModelUtil *sharedObj = nil; //第一步：静态实例，并初始化。

@implementation NoteDataModelUtil

+ (NoteDataModelUtil *) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

/**
 *	@brief	从数据库中读取NoteList
 */
- (NSMutableArray *)getNoteListFromDB
{
    BookletAppDelegate *delegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:delegate.managedObjectContext];

    [request setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"modifyTime" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;

    noteList = [[delegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (noteList == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return noteList;
}

/**
 *	@brief	直接读取缓存中的NoteList
 */
- (NSMutableArray *)getNoteList
{
    return noteList;
}

/**
 *	@brief	从数据库中删除Note
 *
 *	@param 	note 	
 */
- (void)deleteNote:(Note *)note
{
    BookletAppDelegate *delegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Delete Entity
    [delegate.managedObjectContext deleteObject:(NSManagedObject *)note];
    
    NSError *error;
    if (![delegate.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    } else {
        NSLog(@"delete successful");
    }
    
    [noteList removeObject:note];
}

/**
 *	@brief	在数据库中添加note，或更新note
 *
 *	@param 	note 
 */
- (void)addNote:(Note *)note
{
    BookletAppDelegate *delegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];

    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    NSError *error;
    BOOL isSaveSuccess = [delegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    } else {
        NSLog(@"Add successful!");
    }
    
    if ([noteList containsObject:note]) {
        [noteList removeObject:note];
    }
    [noteList insertObject:note atIndex:0];
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步 适当实现allocWitheZone，copyWithZone，release和autorelease。
{
    return self;
}
@end
