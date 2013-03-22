//
//  EditNoteViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 1/4/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookletAppDelegate.h"
#import "Note.h"
#import "AttachListViewController.h"

@class NotePreviewViewController;

@interface EditNoteViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIButton *keyWordBtn;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) NSSet *attachList;

@property (strong, nonatomic) BookletAppDelegate *coreDataDelegate;
@property (strong, nonatomic) NotePreviewViewController *notePreviewControllerDelegate;

- (id)initWithNote:(Note *)note;
- (void)setAttachListData:(NSSet *)set;
- (IBAction)addTag:(id)sender;
- (void)setTag:(NSString *)str;

@end
