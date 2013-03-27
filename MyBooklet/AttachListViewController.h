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
//#import "NotePreviewViewController.h"
@class NotePreviewViewController;
@class EditNoteViewController;

@interface AttachListViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    int curAttachIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIToolbar *toolBar;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) Note *note;
@property (nonatomic) BOOL cellCanSelect;

@property (strong, nonatomic) EditNoteViewController *editNoteViewDelegate;
@property (strong, nonatomic) NotePreviewViewController *notePreviewDelegate;

- (void)setNoteDataSource:(Note *)orginaNote;
- (void)setRecordPath:(NSString *)audioPath;
@end
