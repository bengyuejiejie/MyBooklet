//
//  MoreViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 1/7/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "HelpOnlineViewController.h"
#import "DataSyncViewController.h"
#import "AboutGnoteViewController.h"

@interface MoreViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSource;
- (void)setUpView;
@end
