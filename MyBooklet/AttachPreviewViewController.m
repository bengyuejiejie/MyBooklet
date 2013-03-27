//
//  AttachPreviewViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-22.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import "AttachPreviewViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface AttachPreviewViewController ()

@end

@implementation AttachPreviewViewController
@synthesize noteAttach, assetsLibrary;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	设置网页内容
 *
 *	@param 	attach 	
 */
- (void)setDataSource:(Note_attach *)attach
{
    self.noteAttach = attach;
    // type:0 相册图片 1 声音 2 视频 3 网页
    switch ([attach.type intValue]) {
        case 0:
            [self addImgToWebview];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            [self showWebSite];
            break;
        default:
            break;
    }
}

/**
 *	@brief	是图片资源，添加imgview到webview上
 *
 */
- (void)addImgToWebview
{
    // Get image from Custom Photo Album for the selected photo url.
    if (! self.assetsLibrary) assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:[NSURL URLWithString:self.noteAttach.url]
                        resultBlock:^(ALAsset *asset) {
                            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                            
                            // 等比例缩放图片，暂时先不care
                            imgView.frame = CGRectMake(0, 0, self.webview.frame.size.width, self.webview.frame.size.height);
                            [self.webview addSubview:imgView];
                        }
                       failureBlock:^(NSError *error) {
                           NSLog(@"!!!ERROR: cannot get image: %@", [error description]);
                       }];
}

/**
 *	@brief	显示网站
 */
-(void)showWebSite
{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:noteAttach.url]];
    [self.webview loadRequest:request];
    
    NSURL *nsUrl = [[NSURL alloc] initWithString:@"http://www.baidu.com"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:nsUrl]];
}

/**
 *	@brief	返回附件显示
 *
 *	@param 	sender 	
 */
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
