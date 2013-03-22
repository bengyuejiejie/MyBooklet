//
//  TagListViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 2/25/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditNoteViewController.h"
#import "BookletAppDelegate.h"
@class Note;

@interface TagListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) NSMutableArray *dataSource;
@property (retain, nonatomic) NSMutableArray *selectTagList;

@property (retain, nonatomic) EditNoteViewController *delegate;
@property (strong, nonatomic) BookletAppDelegate *coreDataDelegate;

- (IBAction)addToTagList:(id)sender;
- (id)initTagListWithNote:(Note *)orginaNote;

@end
