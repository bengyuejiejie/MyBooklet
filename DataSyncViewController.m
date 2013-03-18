//
//  DataSyncViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 1/12/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "DataSyncViewController.h"

@interface DataSyncViewController ()

@end

@implementation DataSyncViewController

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
    
    NSDictionary *dic1 = [[NSDictionary alloc]
                          initWithObjectsAndKeys:@"iCloud", @"name",  @"isCloudOn",@"status",nil];
    NSDictionary *dic2 = [[NSDictionary alloc]
                          initWithObjectsAndKeys: @"金山快盘", @"name",  @"isJinShanKuaiPanOn", @"status",nil];
    self.dataSource = [[NSArray alloc] initWithObjects:dic1, dic2, nil];
    
    self.title = @"数据同步";
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
    
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:((NSString *)[dic objectForKey:@"name"])];
    
    //add a switch
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
    switchview.tag = indexPath.row;
    cell.accessoryView = switchview;
    
    return cell;
}

- (IBAction)updateSwitchAtIndexPath:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if(switchView.isOn)
    {
        if(switchView.tag == 0) {
            NSLog(@"iCloud");
        } else {
            NSLog(@"金山快译");
        }
    }
    else
    {
        if(switchView.tag == 0) {
             NSLog(@"iCloud + close");
        } else {
            NSLog(@"金山快译 + close");
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
