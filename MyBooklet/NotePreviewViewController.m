//
//  NotePreviewViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 1/7/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "NotePreviewViewController.h"
#import "AttachListViewController.h"
#import "NoteListViewController.h"
#import "NoteDataModelUtil.h"

@interface NotePreviewViewController ()

@end

@implementation NotePreviewViewController
@synthesize note = _note;
@synthesize toolBar;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    // Create Back Button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = backButton;
    
    // Create Save Button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"附件" style:UIBarButtonItemStyleBordered target:self action:@selector(attach:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Create Toolbar
    [self createToolBar];
    
    [self setNoteInfo:self.note];
    self.title = @"文章详情";
    
    self.contentTextView.editable = NO;

//    [self.view addSubview:self.keywordView];
}

- (void)back:(id)sender {
    
    // Dismiss View Controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNoteInfo:(Note *)note
{
    if (self.note) {
        [self.titleLabel setText:[self.note title]];
        NSArray *arr = [self.note.keywords componentsSeparatedByString:@";"];

        [self.keywordView removeFromSuperview];
        for (int i = 0; i < arr.count; i ++) {
            [self generateKeyWordBtn:arr[i] index:i];
        }
        [self.contentTextView setText:[self.note content]];
    }
}

/**
 *	@brief	生成keyword一排按钮
 *
 *	@param 	str 	
 */
- (void)generateKeyWordBtn:(NSString *)str index:(int)i
{
    self.keywordView = [[UIView alloc] initWithFrame:CGRectMake(20, 55, 300, 20)];
    self.keywordView.tag = 100;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*55, 0, 45, 20)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize: 12];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickKeyWordBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self.keywordView addSubview:btn];
    [self.view addSubview:self.keywordView];

}

/**
 *	@brief	点击关键字按钮
 *
 *	@param 	str 	
 */
- (void)clickKeyWordBtn:(id)sender
{
    UIButton *btn = sender;
    if (btn) {
        NSLog(@"%@", btn.titleLabel.text);
        NoteListViewController *vc = [[NoteListViewController alloc] init];
        vc.keyword = btn.titleLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (id)initWithNote:(Note *)note {
    self = [self initWithNibName:@"NotePreviewViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Set Note
        self.note = note;
        
        // hide bottom bar
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)createToolBar
{
    UIBarButtonItem *insertBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(edit:)];
    
    UIBarButtonItem *attachBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(delete:)];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.navigationController  setToolbarHidden:YES animated:YES];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - toolBar.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [toolBar setItems:[NSArray arrayWithObjects:flexItem, insertBtnItem, flexItem, attachBtnItem, flexItem, nil]];
    [self.view addSubview:toolBar];
}

- (void)edit:(id)sender
{
    // Initialize Note Preview Controller
    EditNoteViewController *editNote = [[EditNoteViewController alloc] initWithNote:self.note];
    
    editNote.notePreviewControllerDelegate = self;
    // Initialize Navigation Controller
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:editNote];
    
    // Present View Controller
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (void)delete:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除文章" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)//click ok button
    {
        // Delete Entity
        [[NoteDataModelUtil sharedInstance] deleteNote:self.note];
     
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)attach:(id)sender
{
    self.rightAttachListView = [[AttachListViewController alloc] init];
    [self.rightAttachListView setNoteDataSource:self.note];
    
    self.rightAttachListView.view.frame = CGRectMake(320, 20, 260, 480);
    
    [self.delegate.window addSubview:self.rightAttachListView.view];
    self.rightAttachListView.toolBar.hidden = YES;
    self.rightAttachListView.cellCanSelect = YES;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.rightAttachListView];
    [self moveToLeftSide];
}

// move view to left side
- (void)moveToLeftSide {
    
    CGRect leftRect = CGRectMake(-220.0f, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    
    CGRect rightRect = CGRectMake(100.0f, 20, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    
    [self animateHomeViewToSide:leftRect with:rightRect];
}

// animate home view to side rect
- (void)animateHomeViewToSide:(CGRect)leftRect with:(CGRect)rightRect{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.navigationController.view.frame = leftRect;
                         self.rightAttachListView.view.frame = rightRect;
                     }
                     completion:^(BOOL finished){
                         UIControl *overView = [[UIControl alloc] init];
                         overView.tag = 10086;
                         overView.backgroundColor = [UIColor clearColor];
                         overView.frame = self.navigationController.view.frame;
                         [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                     }];
}

// restore view location
- (void)restoreViewLocation {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0,
                                                                           self.navigationController.view.frame.origin.y,
                                                                           self.navigationController.view.frame.size.width,
                                                                           self.navigationController.view.frame.size.height);
                         self.rightAttachListView.view.frame = CGRectMake(320,
                                                                           20,
                                                                           self.navigationController.view.frame.size.width,
                                                                           self.navigationController.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:10086];
                         [overView removeFromSuperview];
                         self.rightAttachListView.view.hidden = YES;
                     }];
}
@end
