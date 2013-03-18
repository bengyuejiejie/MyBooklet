//
//  NoteListViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-14.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import "NoteListViewController.h"
#import "Note.h"
#import "NotePreviewViewController.h"

@interface NoteListViewController ()

@end

@implementation NoteListViewController

@synthesize notes;
@synthesize delegate = _delegate;
@synthesize keyword;

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
    
    // setUp View
    [self setUpView];
    
    //获取当前应用程序的委托（UIApplication sharedApplication为整个应用程序上下文）
    self.delegate = (BookletAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Fetch Notes
    self.notes = [self fetchNotes];
    
    // Init filterarray(filter for search)
    self.filterarray = [[NSMutableArray alloc] init];
}

/**
 *	@brief	启动视图时，设置界面属性，捕获数据
 */
- (void)setUpView
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索标题";
    self.tableView.tableHeaderView = self.searchBar;
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
    
    self.title = @"文章列表";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	获取并设置数据源
 */
- (NSMutableArray *)fetchNotes
{
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.delegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    
    BOOL (^block)(id, NSDictionary *) = ^(id evaluatedObject, NSDictionary *bindings) {
        
        if ((Note *)evaluatedObject) {
            return [((Note *)evaluatedObject).keywords isEqualToString:@"iOS"];
        }
        return YES;
    };

    NSPredicate *p = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
        
//        if ((Note *)evaluatedObject) {
//            return [((Note *)evaluatedObject).keywords isEqualToString:@"iOS"];
//        }
        return YES;
    }];
    
    //:@"self.keywords == %@",@"iOS"];
//    [request setPredicate:p];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"modifyTime" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.delegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    NSLog(@"The count of notes:%i",[mutableFetchResult count]);
    
    return mutableFetchResult;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return [self.notes count];
    }
    else
    {
        return [self.filterarray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // configure cell
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    Note *note = nil;
    if (atableView == self.tableView)
    {
        note = [self.notes objectAtIndex:[indexPath row]];
    }
    else
    {
        note = [self.filterarray objectAtIndex:indexPath.row];
    }
    
    [cell.textLabel setText:[note title]];
    [cell.detailTextLabel setText:[note keywords]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Fetch Note
    Note *note = nil;
    
    if ( tableView == self.tableView ) {
        note = [self.notes objectAtIndex:[indexPath row]];
    } else {
        note = [self.filterarray objectAtIndex:[indexPath row]];
    }
    
    // Initialize Note preview View Controller
    NotePreviewViewController *notePreview = [[NotePreviewViewController alloc] initWithNote:note];
    
    // Push View Controller onto Navigation Stack
    [self.navigationController pushViewController:notePreview animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Fetch Note
        Note *note = [self.notes objectAtIndex:[indexPath row]];
        
        // Delete Note from Data Source
        [self.notes removeObjectAtIndex:[indexPath row]];
        
        // Delete Entity
        [self.delegate.managedObjectContext deleteObject:note];
        
        NSError *error;
        if (![self.delegate.managedObjectContext save:&error]) {
            NSLog(@"Error:%@,%@",error,[error userInfo]);
        }
        
        // Update Table View
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/**
 *	@brief	查询数据
 *
 *	@param 	searchBar
 *	@param 	searchText
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filterarray removeAllObjects];
    
    for (Note *note in self.notes)
    {
        NSString *titleString = note.title;
        
        NSRange range = [[titleString lowercaseString] rangeOfString:[searchText lowercaseString]];
        if (range.location != NSNotFound)
        {
            [self.filterarray addObject:note];
        }
        
        titleString = nil;
    }
    
    [self.searchDC.searchResultsTableView reloadData];
}

@end
