//
//  BookletAppDelegate.h
//  MyBooklet
//
//  Created by wangxiaohong on 3/17/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface BookletAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

//数据模型对象
@property(strong,nonatomic) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//初始化Core Data使用的数据库
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

//managedObjectModel的初始化赋值函数
-(NSManagedObjectModel *)managedObjectModel;

//managedObjectContext的初始化赋值函数
-(NSManagedObjectContext *)managedObjectContext;

@end
