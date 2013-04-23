//
//  BookletAppDelegate.m
//  MyBooklet
//
//  Created by wangxiaohong on 3/17/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "BookletAppDelegate.h"
#import "MoreViewController.h"
#import "MainViewController.h"
#import "GeneralUtil.h"

@implementation BookletAppDelegate
@synthesize tabBarController;

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize first View Controller
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:
                                  nil];
    // Initialize tab left Navigation Controller
    UINavigationController *ncLeft = [[UINavigationController alloc] initWithRootViewController:mainVC];
    ncLeft.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的文章" image:nil tag:0];
    
    
    MoreViewController *moreVC = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    
    // Initialize tab right Navigation Controller
    UINavigationController *ncRight = [[UINavigationController alloc] initWithRootViewController:moreVC];
    ncRight.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:nil tag:1];
    
    
    // create a tab bar controller
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects: ncLeft, ncRight, nil];
    
    // Initialize Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    return YES;
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
    NSError *error;
    if (managedObjectContext != nil) {
        //hasChanges方法是检查是否有未保存的上下文更改，如果有，则执行save方法保存上下文
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
            abort();
        }
    }
    
    // 删除document下的temp目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [GeneralUtil getDocumentDirectory];
    
    if ([fileManager fileExistsAtPath:@"temp" isDirectory:YES]) {
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"temp"] error:NULL];
    }
}

/**
 *	@brief	初始化数据模型
 *
 *	@return
 */
-(NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"GNote.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return persistentStoreCoordinator;
}

/**
 *	@brief	被管理对象上下文
 *
 *	@return
 */
-(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}

@end
