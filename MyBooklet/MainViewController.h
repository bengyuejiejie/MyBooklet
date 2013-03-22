//
//  ViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 1/3/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookletAppDelegate.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain) UISearchBar *searchBar;
@property (retain) UISearchDisplayController *searchDC;
@property (strong, nonatomic) NSMutableArray *filterarray;

@property (nonatomic, strong) NSMutableArray *notes;

- (void)setUpView;

@end
