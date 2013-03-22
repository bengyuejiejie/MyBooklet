//
//  DataSyncViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 1/12/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataSyncViewController : UIViewController

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
