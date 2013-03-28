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
#import "AttachPreviewViewController.h"
#import "NotePreviewViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AttachListViewController ()

@end

@implementation AttachListViewController
@synthesize tableView;
@synthesize dataSource;
@synthesize note;
@synthesize editNoteViewDelegate;
@synthesize notePreviewDelegate;
@synthesize toolBar;
@synthesize cellCanSelect;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRecordPath:) name:@"ADD_RECORD_TO_ATTACHLIST" object:nil];
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
    if (cellCanSelect) {
        AttachPreviewViewController *vc = [[AttachPreviewViewController alloc] init];
        
        Note_attach *noteAttach = [self.dataSource objectAtIndex:indexPath.row];
        [vc setDataSource:noteAttach];
        [self.notePreviewDelegate.navigationController pushViewController:vc animated:YES];
    }
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
            // 添加相册照片
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
            // 拍照
            [self addMedia:2];
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
            [self addToAttachList:[NSString stringWithFormat:@"网页%d：%@", curAttachIndex,[actionSheet textFieldAtIndex:0].text] url:[actionSheet textFieldAtIndex:0].text type:3];
            break;
        default:
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
            
            // 录制视频
            if (selectIndex == 2) {
                NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
                if ([sourceTypes containsObject:(NSString *)kUTTypeMovie ])
                {
                    imagePicker.mediaTypes= [NSArray arrayWithObjects:(NSString *)kUTTypeMovie,nil];
                }
            }
            
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

    // 视频
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"])
    {
        // The completion block to be executed after image taking action process done
        void (^completionBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
            if (error) NSLog(@"error,  write the image data to the assets library (camera roll): %@",
                             [error description]);
            // Add new one to |photos_|
            __block NSString *url = [assetURL absoluteString];
            
            // 视频 type：2
            [self addToAttachList:[NSString stringWithFormat:@"视频: %d", curAttachIndex] url:url type:2];
        };
        
        void (^failureBlock)(NSError *) = ^(NSError *error) {
            if (error == nil) return;
            NSLog(@"error, failed to add the asset to the custom photo album: %@", [error description]);
        };
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary saveVideo:[info objectForKey:UIImagePickerControllerMediaURL] toAlbum:@"Custom Video Album" completionBlock:completionBlock failureBlock:failureBlock];
    }
    else
    {
        if ([info objectForKey:UIImagePickerControllerReferenceURL])//从相册中读取
        {
            NSString *url = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            
            // 图片 type：0
            [self addToAttachList:[NSString stringWithFormat:@"图片: %d", curAttachIndex] url:url type:0];
            
        }
        else // 拍照
        {
            // The completion block to be executed after image taking action process done
            void (^completionBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
                if (error) NSLog(@"error,  write the image data to the assets library (camera roll): %@",
                                 [error description]);
                // Add new one to |photos_|
                __block NSString *url = [assetURL absoluteString];
                
                // 图片 type：0
                [self addToAttachList:[NSString stringWithFormat:@"图片: %d", curAttachIndex] url:url type:0];
            };
            
            void (^failureBlock)(NSError *) = ^(NSError *error) {
                if (error == nil) return;
                NSLog(@"error, failed to add the asset to the custom photo album: %@", [error description]);
            };
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary saveImage:(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]
                             toAlbum:@"Custom Photo Album"
                     completionBlock:completionBlock
                        failureBlock:failureBlock];
            
        }
 
    }
}

/**
 *	@brief	打开录制音频视图
 */
- (void)openRecordAudioView
{
    RecordAudioViewController *vc = [[RecordAudioViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

/**
 *	@brief  返回音频路径
 *
 *	@param 	audioPath 	
 */
- (void)setRecordPath:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSString *audioPath = [dic objectForKey:@"audioPath"];
    [self addToAttachList:[NSString stringWithFormat:@"音频: %d", curAttachIndex ] url:audioPath type:1];
}

/**
 *	@brief	添加到附件列表
 *
 *	@param 	name
 *	@param 	url 	
 */
- (void)addToAttachList:(NSString *)name url:(NSString *)url type:(int)type
{
    BookletAppDelegate *applicationDelegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Note_attach *noteAttach = (Note_attach *)[NSEntityDescription insertNewObjectForEntityForName:@"Note_attach" inManagedObjectContext:applicationDelegate.managedObjectContext];
    
    [noteAttach setName:name ];
    [noteAttach setNoteId:self.note.noteId];
    [noteAttach setCreateTime:[NSDate date]];
    [noteAttach setType:[NSNumber numberWithInt:type]];
    
    [noteAttach setUrl:url];
    [noteAttach setInNote:self.note];
    
    curAttachIndex ++;
    [self.dataSource addObject:noteAttach];
    [self.tableView reloadData];
}

/**
 *	@brief	设置dataSource
 *
 *	@param 	note 
 */
- (void)setNoteDataSource:(Note *)orginaNote
{
    self.dataSource = [[NSMutableArray alloc] initWithArray:orginaNote.attachList.allObjects];
    [self.tableView reloadData];
}


@end
