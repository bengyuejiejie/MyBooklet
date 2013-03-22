//
//  NoteListViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-14.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookletAppDelegate.h"

@interface NoteListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain) UISearchBar *searchBar;
@property (retain) UISearchDisplayController *searchDC;
@property (strong, nonatomic) NSMutableArray *filterarray;

@property (nonatomic, strong) NSMutableArray *notes;
@property (strong, nonatomic) BookletAppDelegate *delegate;
@property (strong, nonatomic) NSString *keyword;

- (void)setUpView;
- (NSMutableArray *)fetchNotes;

@end
