//
//  AttachListViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 1/12/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "AttachListViewController.h"
#import "EditNoteViewController.h"
#import "RecordAudioViewController.h"

@interface AttachListViewController ()

@end

@implementation AttachListViewController
@synthesize tableView;
@synthesize dataSource;
@synthesize note;
@synthesize editNoteViewDelegate;
@synthesize toolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"附件列表";
    
    // Create Cancel Button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // Create Save Button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(ok:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加附件" style:UIBarButtonItemStyleBordered target:self action:@selector(insertAttach:)];
    [addBtn setWidth:60];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height -toolBar.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;    
    [toolBar setItems:[NSArray arrayWithObjects:flexItem, addBtn, flexItem, nil]];
    
    [self.view addSubview:toolBar];
    
    self.editNoteViewDelegate = [[EditNoteViewController alloc] initWithNibName:@"EditNoteViewController" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // configure cell
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    Note_attach *attach = (Note_attach *)[self.dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:attach.name];
    cell.accessoryType =  UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"打开文件");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Note_attach *noteAttach = [self.dataSource objectAtIndex:indexPath.row];
        
        [self.dataSource removeObject:noteAttach];
        // Update Table View
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        BookletAppDelegate *applicationDelegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
        [applicationDelegate.managedObjectContext deleteObject:noteAttach];
    }
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ok:(id)sender {
    // 保存附件列表数据到EditNoteViewController中。
//    [editNoteViewDelegate setaaaAttachList:[[NSSet alloc] initWithArray:self.dataSource]];
    
    NSSet *attachList = [[NSSet alloc] initWithArray:self.dataSource];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:attachList, @"Attach", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVE_NOTE_ATTACHLIST" object:self userInfo:dic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)insertAttach:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册照片", @"拍照",
                                                                 @"声音", @"视频", @"网页", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
        case 0:
            // 添加相册照片，视频
            [self addMedia:0];
            break;
        case 1:
            // 拍照
            [self addMedia:1];
            break;
        case 2:
            // 声音
            [self openRecordAudioView];
            break;
        case 3:
            // 视频
            NSLog(@"录制视频");
            break;
        case 4:
            // 网页
            NSLog(@"输入网页");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"输入网页地址"
                                                           delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            break;
    }
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
        case 0:
            NSLog(@"取消");
            break;
        case 1:
            [self addToAttachList:[NSString stringWithFormat:@"网页%d：%@", curAttachIndex,[actionSheet textFieldAtIndex:0].text] url:nil];
            break;
        default:
            break;
    }
}

/**
 *	@brief	添加照片
 */
- (void)addMedia:(int)selectIndex
{
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    
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

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *url = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];

    [self addToAttachList:[NSString stringWithFormat:@"图片: %d", curAttachIndex] url:url];   
}

/**
 *	@brief	打开录制音频视图
 */
- (void)openRecordAudioView
{
    RecordAudioViewController *vc = [[RecordAudioViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *	@brief  返回音频路径
 *
 *	@param 	audioPath 	
 */
- (void)setRecordPath:(NSString *)audioPath
{
    [self addToAttachList:[NSString stringWithFormat:@"音频: %d", curAttachIndex] url:audioPath];
}

/**
 *	@brief	添加到附件列表
 *
 *	@param 	name
 *	@param 	url 	
 */
- (void)addToAttachList:(NSString *)name url:(NSString *)url
{
    BookletAppDelegate *applicationDelegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Note_attach *noteAttach = (Note_attach *)[NSEntityDescription insertNewObjectForEntityForName:@"Note_attach" inManagedObjectContext:applicationDelegate.managedObjectContext];
    
    [noteAttach setName:name ];
    [noteAttach setNoteId:self.note.noteId];
    [noteAttach setCreateTime:[NSDate date]];
    
    [noteAttach setUrl:url];
    [noteAttach setInNote:self.note];
    
    curAttachIndex ++;
    [self.dataSource addObject:noteAttach];
    [self.tableView reloadData];
}

/**
 *	@brief	初始化显示的attachList
 *
 *	@param 	note 
 */
- (id)initAttachListWithNote:(Note *)orginaNote
{
    self = [super initWithNibName:@"AttachListViewController" bundle:nil];
    if (self)
    {
        self.dataSource = [[NSMutableArray alloc] initWithArray:orginaNote.attachList.allObjects];
    }
    
    return self;
}

@end
