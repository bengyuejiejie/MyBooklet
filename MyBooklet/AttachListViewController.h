//
//  AttachListViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 1/12/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "Note_attach.h"
@class EditNoteViewController;

@interface AttachListViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    int curAttachIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIToolbar *toolBar;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) Note *note;

@property (strong, nonatomic) EditNoteViewController *editNoteViewDelegate;

- (id)initAttachListWithNote:(Note *)orginaNote;
- (void)setRecordPath:(NSString *)audioPath;

@end
