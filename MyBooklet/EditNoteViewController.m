//
//  EditNoteViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 1/4/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "EditNoteViewController.h"
#import "NotePreviewViewController.h"
#import "TagListViewController.h"
#import "NoteDataModelUtil.h"
#import "GeneralUtil.h"

@interface EditNoteViewController ()

@end

@implementation EditNoteViewController

@synthesize titleTextField;
@synthesize keyWordBtn;
@synthesize contentWebView;

@synthesize toolBar;
@synthesize coreDataDelegate;
@synthesize notePreviewControllerDelegate;
@synthesize attachList = _attachList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.coreDataDelegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Setup View
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAttachListData:) name:@"SAVE_NOTE_ATTACHLIST" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupView
{    
    self.title = @"编辑文章";
    
    // Create Cancel Button
    if (!self.note) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    // Create Save Button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Create Back Button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // Create Toolbar
    [self createToolBar];
    
    titleTextField.delegate = self;
    
    if (self.note)
    {
        // Populate Form Fields
        [self.titleTextField setText:[self.note title]];
        [self.keyWordBtn setTitle:[self.note keywords] forState:UIControlStateNormal];
        [self setContent];
    }
    else
    {
        [self createContentHtmlInDocument];
    }
}

/**
 *	@brief	设置笔记的内容
 *
 *	@param 	str 	
 */
- (void)setContent
{
    NSString *documentsDirectory = [GeneralUtil getDocumentDirectory];
    NSString *noteIdDirectory = [documentsDirectory stringByAppendingPathComponent:[self.note noteId]];
    NSString *htmlDocDirectory = [noteIdDirectory stringByAppendingPathComponent:@"index.html"];

    NSString * htmlString = [NSString stringWithContentsOfFile:htmlDocDirectory encoding:(NSUTF8StringEncoding) error:nil];
    
    [self.contentWebView loadHTMLString:htmlString baseURL:nil];
}

/**
 *	@brief	在document目录下创建contentHtml
 */
- (void)createContentHtmlInDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *documentsDirectory = [GeneralUtil getDocumentDirectory];
    
    // 先设置一个临时目录
    NSString *noteIdDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    NSString *htmlDocDirectory = [noteIdDirectory stringByAppendingPathComponent:@"index.html"];

    // 创建一个noteID的文件夹
    NSError *createDirectoryError;
    BOOL createDirectorySuccess = [fileManager createDirectoryAtPath:noteIdDirectory withIntermediateDirectories:NO attributes:nil error:&createDirectoryError];
    
    if (createDirectorySuccess)
    {
        // 获取工程resource路径下的index.html路径
        NSString *indexHtmlDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"index.html"];
            
        // 把index.html 文件复制到dnoteID的文件夹中
        NSError *copyItemError;
        BOOL success = [fileManager copyItemAtPath:indexHtmlDirectory toPath:htmlDocDirectory error:&copyItemError];
        if (!success)
        {
            NSLog(@"%@", [copyItemError localizedDescription]);
        }
        else
        {
            NSString * htmlString = [NSString stringWithContentsOfFile:indexHtmlDirectory encoding:(NSUTF8StringEncoding) error:nil];
            [self.contentWebView loadHTMLString:htmlString baseURL:nil];
        }
    }
    else
    {
        NSLog(@"%@", [createDirectoryError localizedDescription]); 
    }
}

/**
 *	@brief	内容加载完成
 *
 *	@param 	webView 	
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}


- (void)back:(id)sender
{
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 之前添加附件的操作去除，没有保存到数据库
    [self.coreDataDelegate.managedObjectContext rollback];
    
    // 删除document下的temp目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [GeneralUtil getDocumentDirectory];
    
    [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"temp"] error:NULL];
}

- (void)save:(id)sender
{
    BOOL isNewNote = !self.note;
    if (!self.note) {
        // Create Note
        self.note = (Note *)[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.coreDataDelegate.managedObjectContext];
        
        // Configure Note
        [self.note setCreateTime:[NSDate date]];
        [self.note setModifyTime:[NSDate date]];
        [self.note setNoteId:[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]]];
    }
    else
    {
        [self.note setModifyTime:[NSDate date]];
    }

    // Configure Note
    [self.note setTitle:[self.titleTextField text]];
    [self.note setKeywords:self.keyWordBtn.titleLabel.text];
    [self.note addAttachList:_attachList];

    
    // 把document下的temp目录重命名为noteId
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [GeneralUtil getDocumentDirectory];
    
    // 如果是新建的笔记，则把temp目录重命名为noteId。
    if (isNewNote) {
        NSString *tempDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
        NSString *targetDirectory = [documentsDirectory stringByAppendingPathComponent:[self.note noteId]];
        NSString *htmlDirectory = [targetDirectory stringByAppendingPathComponent:@"index.html"];
        
        NSError *error;
        BOOL success = [fileManager moveItemAtPath:tempDirectory toPath:targetDirectory error:&error];
        if (!success)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
        else
        {
            NSString *innerHTMLJS = @"document.documentElement.innerHTML";
            NSString *innerHTML = [self.contentWebView stringByEvaluatingJavaScriptFromString:innerHTMLJS];
            
            NSError *writeError;
            BOOL *writeSuccess = [innerHTML writeToFile:htmlDirectory atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
            if (!writeSuccess) {
                NSLog(@"%@", [writeError localizedDescription]);
            }
        }
    }
    else // 如果是编辑的笔记，则把noteId目录下的html内容更新。
    {
        NSString *targetDirectory = [documentsDirectory stringByAppendingPathComponent:[self.note noteId]];
        NSString *htmlDirectory = [targetDirectory stringByAppendingPathComponent:@"index.html"];
        
        NSString *innerHTMLJS = @"document.documentElement.innerHTML";
        NSString *innerHTML = [self.contentWebView stringByEvaluatingJavaScriptFromString:innerHTMLJS];
        
        NSError *writeError;
        BOOL *writeSuccess = [innerHTML writeToFile:htmlDirectory atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (!writeSuccess) {
            NSLog(@"%@", [writeError localizedDescription]);
        }
    }
    
    [[NoteDataModelUtil sharedInstance] addNote:self.note];
    [self.notePreviewControllerDelegate setNoteInfo:self.note];
    
    [GeneralUtil showToast:@"保存笔记成功"];

    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNote:(Note *)note {
    self = [self initWithNibName:@"EditNoteViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Set Note
        self.note = note;
    }
    return self;
}

- (void)createToolBar
{
    UIBarButtonItem *insertBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insert:)];
    
    UIBarButtonItem *attachBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(insertAttach:)];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
       
    [self.navigationController  setToolbarHidden:YES animated:YES];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - toolBar.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [toolBar setItems:[NSArray arrayWithObjects:flexItem, insertBtnItem, flexItem, attachBtnItem, flexItem, nil]];
    [self.view addSubview:toolBar];
}

/**
 *	@brief	插入多媒体内容
 *
 *	@param 	sender 	
 */
- (void)insert:(id)sender
{
    
}

/**
 *	@brief	插入附件
 *
 *	@param 	sender 	
 */
- (void)insertAttach:(id)sender
{
    AttachListViewController *vc = [[AttachListViewController alloc] init];
    [vc setNoteDataSource:self.note];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

/**
 *	@brief	添加附件列表
 *
 *	@param 	set 	临时存储的附件列表，并不真正入库
 */
- (void)setAttachListData:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    _attachList = [[userInfo objectForKey:@"Attach"] copy];
}

/**
 *	@brief	添加标签
 *
 *	@param 	sender
 */
- (IBAction)addTag:(id)sender
{
    TagListViewController *vc = [[TagListViewController alloc] initTagListWithNote:self.note];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setTag:(NSString *)str
{
    [self.keyWordBtn setTitle:str forState:UIControlStateNormal];
}

/**
 *	@brief	键盘return key事件响应
 *
 *	@param 	textField
 *
 *	@return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}
@end
