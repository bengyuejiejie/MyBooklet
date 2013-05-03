//
//  ViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 1/3/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "MainViewController.h"
#import "Note.h"
#import "EditNoteViewController.h"
#import "NotePreviewViewController.h"
#import "NoteDataModelUtil.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize notes;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setUp View
    [self setUpView];
    
    // Fetch Notes
    self.notes = [[NoteDataModelUtil sharedInstance] getNoteListFromDB];
    
    // Init filterarray(filter for search)
    self.filterarray = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Fetch Notes
    self.notes = [[NoteDataModelUtil sharedInstance] getNoteList];
    
    // Reload Table View
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	启动视图时，设置界面属性，捕获数据
 */
- (void)setUpView
{
    // Create Add  Button
    self.addButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addNotes:)];
    
    self.navigationItem.rightBarButtonItem = self.addButton;
    
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
    
    self.title = @"MyBooklet";
    self.parentViewController.tabBarItem.title = @"我的文章";
}

/**
 *	@brief	添加笔记，打开添加笔记视图
 *
 *	@param 	sender
 */
- (void)addNotes:(id)sender
{
    // Initialize Note Preview Controller
    EditNoteViewController *editNote = [[EditNoteViewController alloc] initWithNibName:@"EditNoteViewController" bundle:[NSBundle mainBundle]];
    
    // Initialize Navigation Controller
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:editNote];

    // Present View Controller
    [self.navigationController presentViewController:nc animated:YES completion:nil];
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

        [[NoteDataModelUtil sharedInstance] deleteNote:note];
        
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
        NSString *keyWordString = note.keywords;
            
        NSRange range = [[titleString lowercaseString] rangeOfString:[searchText lowercaseString]];
        if (range.location != NSNotFound)
        {
            [self.filterarray addObject:note];
        }
        else
        {
            range = [[keyWordString lowercaseString] rangeOfString:[searchText lowercaseString]];
            if (range.location != NSNotFound)
            {
                [self.filterarray addObject:note];
            }
        }
        
        titleString = nil;
    }
    
    [self.searchDC.searchResultsTableView reloadData];
}

@end
