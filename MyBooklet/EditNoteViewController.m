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
#import "Const.h"

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

- (id)initWithNote:(Note *)note {
    self = [self initWithNibName:@"EditNoteViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Set Note
        self.note = note;
    }
    return self;
}

#pragma mark
#pragma mark setup View

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

    // 不是新建的笔记
    if (self.note)
    {
        // Populate Form Fields
        [self.titleTextField setText:[self.note title]];
        [self.keyWordBtn setTitle:[self.note keywords] forState:UIControlStateNormal];
        [self setContent];
    }
    else
    {
        // 新建的笔记需要在document下创建temp目录，并拷贝resource下的index.html到temp目录下
        [self createContentHtmlInDocument];
    }
    
    // 使webview滚动时不出现上部下部的黑条
    for (id view in self.contentWebView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view setBounces:NO];
        }
    }
//    [self.contentWebView setBackgroundColor:[UIColor clearColor]];
//    self.contentWebView.opaque = NO;
    
    self.contentWebView.frame = CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, MainWidth, MainHeight - self.navigationController.navigationBar.frame.size.height - self.toolBar.frame.size.height - self.contentWebView.frame.origin.y);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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

#pragma mark
#pragma mark set htmlContent

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
    NSURL * baseURL = [NSURL fileURLWithPath:htmlDocDirectory];

    NSString * htmlString = [NSString stringWithContentsOfFile:htmlDocDirectory encoding:(NSUTF8StringEncoding) error:nil];
    [self.contentWebView loadHTMLString:htmlString baseURL:baseURL];
}

/**
 *	@brief	在document下创建temp目录，并拷贝resource下的index.html到temp目录下
 */
- (void)createContentHtmlInDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *documentsDirectory = [GeneralUtil getDocumentDirectory];
    
    // 先设置一个临时目录
    NSString *noteIdDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    NSString *htmlDocDirectory = [noteIdDirectory stringByAppendingPathComponent:@"index.html"];
    NSURL * baseURL = [NSURL fileURLWithPath:htmlDocDirectory];

    // 创建一个temp目录
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
            NSLog(@"拷贝index.html出错");
        }
        else
        {
            NSString * htmlString = [NSString stringWithContentsOfFile:indexHtmlDirectory encoding:(NSUTF8StringEncoding) error:nil];
            [self.contentWebView loadHTMLString:htmlString baseURL:baseURL];
        }
    }
    else
    {
        NSLog(@"创建temp目录失败，已有temp目录或者创建的目录不正确"); 
    }
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

#pragma mark
#pragma mark save html

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

    [self saveContentHtmlToDirectory:isNewNote];
        
    [[NoteDataModelUtil sharedInstance] addNote:self.note];
    [self.notePreviewControllerDelegate setNoteInfo:self.note];
    
    [GeneralUtil showToast:@"保存笔记成功"];

    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *	@brief	保存html内容，生成index.html放到document/note_id/目录下
 *
 *	@param 	isNewNote 	是否是新建的笔记
 */
- (void)saveContentHtmlToDirectory:(BOOL)isNewNote
{
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
}

#pragma mark
#pragma mark insert media

/**
 *	@brief	插入多媒体内容
 *
 *	@param 	sender 	
 */
- (void)insert:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册照片", @"拍照",
                                  @"语音", @"视频", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
        case 0:
            // 添加相册照片
            [self addMedia:0];
            break;
        case 1:
            // 拍照
            [self addMedia:1];
            break;
        case 2:
            // 语音
//            [self openRecordAudioView];
            break;
        case 3:
            // 视频
            NSLog(@"录制视频");
            [self addMedia:2];
            break;
    }
}


/**
 *	@brief	添加照片,录制视频
 */
- (void)addMedia:(int)selectIndex
{
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    if (selectIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        } else {
            NSLog(@"在模拟器上无法打开照相机，请在真机中使用");
        }
    }
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:
                      UIImagePickerControllerOriginalImage];
    NSData *data;
    data = UIImageJPEGRepresentation(image, 0.7);
    
    NSString *docPaths = [GeneralUtil getDocumentDirectory];
    
    // 是编辑文本，不是新增的文本
    NSString *noteIdDirectory;
    if (self.note) {
        noteIdDirectory = [docPaths stringByAppendingPathComponent:[self.note noteId]];
    } else {
        noteIdDirectory = [docPaths stringByAppendingPathComponent:@"temp"];
    }
    
    NSString *time = [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", time];
    
    NSString *pngImage = [noteIdDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", time]];
    [data writeToFile:pngImage atomically:YES];
    

    NSString *js = [NSString stringWithFormat:@"var br = document.createElement('p'); document.body.appendChild(br); var img = document.createElement('img'); img.width = 300; img.height = 360; img.src = '%@' ;document.body.appendChild(img); ", imageName];
    
    [self.contentWebView stringByEvaluatingJavaScriptFromString:js];
}


#pragma mark
#pragma mark set AttachList

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

#pragma mark
#pragma mark set tag 

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

#pragma mark
#pragma mark set keyboard delegate

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

/**
 *	@brief	关闭键盘
 *
 *	@param 	sender 	
 */
- (IBAction)closeKeyBoard:(id)sender
{
    [self.contentWebView setUserInteractionEnabled:NO];
    [self.contentWebView setUserInteractionEnabled:YES];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    [self performSelector:@selector(removeBar) withObject:nil afterDelay:0];
}

- (void)removeBar
{
    // Locate non-UIWindow.
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIWebFormView.
    for (UIView *possibleFormView in [keyboardWindow subviews]) {
        // iOS 5 sticks the UIWebFormView inside a UIPeripheralHostView.
        if ([[possibleFormView description] rangeOfString:@"UIPeripheralHostView"].location != NSNotFound) {
            for (UIView *subviewWhichIsPossibleFormView in [possibleFormView subviews]) {
                if ([[subviewWhichIsPossibleFormView description] rangeOfString:@"UIWebFormAccessory"].location != NSNotFound) {
                    [subviewWhichIsPossibleFormView removeFromSuperview];
                }
            }
        }
    }
}



@end
