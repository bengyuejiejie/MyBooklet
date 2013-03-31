//
//  NotePreviewViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 1/7/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "EditNoteViewController.h"
@class AttachListViewController;

@interface NotePreviewViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) Note *note;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) BookletAppDelegate *delegate;
@property (strong, nonatomic) AttachListViewController *rightAttachListView;

- (id)initWithNote:(Note *)note;
- (void)createToolBar;
- (void)setupView;
- (void)edit:(id)sender;
- (void)delete:(id)sender;
- (void)setNoteInfo:(Note *)note;

@end
