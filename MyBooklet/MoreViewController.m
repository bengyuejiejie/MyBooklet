//
//  MoreViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 1/7/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

@synthesize dataSource;
@synthesize tableView;

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
    
    [self setUpView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView
{
    self.dataSource = [[NSArray alloc] initWithObjects:@"问题反馈",  @"在线帮助", @"数据同步", @"关于GNote", nil];
    self.title = @"更多";
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
       
    [cell.textLabel setText:[self.dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            [self sendMail];
            break;
        case 1:
            [self openHelpOnLineView];
            break;
        case 2:
            [self openDataSyncView];
            break;
        case 3:
            [self openAboutGNote];
            break;
        default:
            break;
    }
    
}

/**
 *	@brief	发送邮件
 */
- (void)sendMail
{
    // 设备不支持发送邮件
    if(MFMailComposeViewController.canSendMail == NO)
    {
        return;
    }
    
    // 显示电子邮件
    MFMailComposeViewController *mailComposer;
    mailComposer =[[MFMailComposeViewController alloc] init];
    
    mailComposer.mailComposeDelegate = self;
        
    // 收件人地址数组
    NSArray *emailAddresses;
    emailAddresses =[[NSArray alloc]initWithObjects: @"vimfung@gmail.com",nil];
    [mailComposer setToRecipients:emailAddresses];
    [mailComposer setSubject:@"GNotes问题反馈"];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

/**
 *	@brief	发送完邮件后的回调函数
 *
 *	@param 	controller
 *	@param 	result
 *	@param 	error
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *	@brief	打开在线帮助界面
 */
- (void)openHelpOnLineView
{
    HelpOnlineViewController *vc = [[HelpOnlineViewController alloc] initWithNibName:@"HelpOnlineViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *	@brief	打开数据同步界面
 */
- (void)openDataSyncView
{
    DataSyncViewController *vc = [[DataSyncViewController alloc] initWithNibName:@"DataSyncViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];    
}

/**
 *	@brief	打开关于GNote界面
 */
- (void)openAboutGNote
{
    AboutGnoteViewController *vc = [[AboutGnoteViewController alloc] initWithNibName:@"AboutGnoteViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
