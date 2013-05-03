//
//  TagListViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 2/25/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "TagListViewController.h"
#import "Note_tag.h"
#import "Note.h"
#import "BookletAppDelegate.h"

@interface TagListViewController ()

@end

@implementation TagListViewController

@synthesize tableView,dataSource,inputTextField,delegate;

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
    
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.title = @"标签";
    
    // Create Back Button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;

    self.tableView.tableHeaderView = self.topView;
    
    self.coreDataDelegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self initData];
}

- (void)initData
{
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note_tag" inManagedObjectContext:self.coreDataDelegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    self.dataSource = [[self.coreDataDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (self.dataSource == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    NSLog(@"The count of note_tag:%i",[self.dataSource count]);
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    return @"常用标签";
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
    
    [cell.textLabel setText:((Note_tag *)[self.dataSource objectAtIndex:indexPath.row]).name];
    
    if ([self.selectTagList containsObject:((Note_tag *)[self.dataSource objectAtIndex:indexPath.row]).name])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)cancel:(id)sender
{
    NSString *tagStr = [self.selectTagList componentsJoinedByString:@";"];
    [self.delegate setTag:tagStr];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (![self.selectTagList containsObject:((Note_tag *)[self.dataSource objectAtIndex:indexPath.row]).name])
    {
        [self.selectTagList addObject:((Note_tag *)[self.dataSource objectAtIndex:indexPath.row]).name];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        [self.selectTagList removeObject:((Note_tag *)[self.dataSource objectAtIndex:indexPath.row]).name];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


/**
 *	@brief	初始化显示的attachList
 *
 *	@param 	note
 */
- (id)initTagListWithNote:(Note *)orginaNote
{
    self = [super initWithNibName:@"TagListViewController" bundle:nil];
    if (self)
    {
        self.selectTagList = [[NSMutableArray alloc] init];
        NSArray *tagArr = [orginaNote.keywords componentsSeparatedByString:@";"];
        
        for (int i = 0; i < tagArr.count; i ++) {
            [self.selectTagList addObject:tagArr[i]];
        }
    }
    
    return self;
}

/**
 *	@brief	添加到标签列表
 *
 *	@param 	sender 	
 */
- (IBAction)addToTagList:(id)sender
{
    Note_tag *tag = (Note_tag *)[NSEntityDescription insertNewObjectForEntityForName:@"Note_tag" inManagedObjectContext:self.coreDataDelegate.managedObjectContext];
    tag.name = self.inputTextField.text;
    tag.createTime = [NSDate date];

    NSError *error = nil;
    //存储到数据库中
    BOOL isSaveSuccess = [self.coreDataDelegate.managedObjectContext save:&error];
    
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    } else {
        NSLog(@"Save successful!");
    }
    self.inputTextField.text = @"";
    [self.dataSource addObject:tag];
    
    [self.tableView reloadData];
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
