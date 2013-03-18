//
//  HelpOnlineViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 1/12/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "HelpOnlineViewController.h"

@interface HelpOnlineViewController ()

@end

@implementation HelpOnlineViewController
@synthesize webView;

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
    
//    self.webView = [[UIWebView alloc] init];
    
    NSURL *nsUrl = [[NSURL alloc] initWithString:@"http://my.oschina.net/vimfung/blog/84200"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:nsUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
