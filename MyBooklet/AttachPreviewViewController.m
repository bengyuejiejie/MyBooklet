//
//  AttachPreviewViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-22.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import "AttachPreviewViewController.h"
#import "Const.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

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
    [self showInfo];
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
}

/**
 *	@brief	显示webview内容
 */
- (void)showInfo
{
    [self cleanView];
    // type:0 相册图片 1 声音 2 视频 3 网页
    switch ([noteAttach.type intValue]) {
        case 0:
            [self addImgToview];
            break;
        case 1:
            break;
        case 2:
            [self playMovie];
            break;
        case 3:
            [self showWebSite];
            break;
        default:
            break;
    }
}

/**
 *	@brief	清理当前视图
 */
-(void)cleanView
{
    for (int i = 0; i < self.view.subviews.count; i ++) {
        UIView *view = self.view.subviews[i];
        [view removeFromSuperview];
    }
}


/**
 *	@brief	是图片资源，添加imgview到webview上
 *
 */
- (void)addImgToview
{
    // Get image from Custom Photo Album for the selected photo url.
    if (! self.assetsLibrary) assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:[NSURL URLWithString:self.noteAttach.url]
                        resultBlock:^(ALAsset *asset) {
                            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                            
                            // 等比例缩放图片，暂时先不care
                            imgView.frame = CGRectMake(0, 0, MainWidth, MainHeight - self.navigationController.view.frame.size.height);
                            [self.view addSubview:imgView];
                        }
                       failureBlock:^(NSError *error) {
                           NSLog(@"!!!ERROR: cannot get image: %@", [error description]);
                       }];
}


/**
 *	@brief	播放视频
 */
- (void)playMovie
{
    if (! self.assetsLibrary) assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:[NSURL URLWithString:self.noteAttach.url]
                   resultBlock:^(ALAsset *asset) {
                       
                       NSLog(@"%@", asset);
                       NSLog(@"%@",[asset valueForProperty:@"ALAssetPropertyURLs"]);
                       NSLog(@"%@",[[asset valueForProperty:@"ALAssetPropertyURLs"] objectForKey:@"com.apple.quicktime-movie"]);
                       
                       NSMutableString *path = [[asset valueForProperty:@"ALAssetPropertyURLs"] objectForKey:@"com.apple.quicktime-movie"];
                       NSString *videoPath = [NSString stringWithFormat:@"%@.MOV", path];
                       MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: asset.defaultRepresentation.url];
                       [moviePlayer prepareToPlay];
                       moviePlayer.shouldAutoplay = YES;
//                       if([moviePlayer respondsToSelector:@selector(setAllowsAirPlay:)]) {
//                           moviePlayer.allowsAirPlay = NO;
//                       }
                       
                       [self.view addSubview:moviePlayer.view];
                       [[NSNotificationCenter defaultCenter] addObserver:self
                                                                selector:@selector(playMovieFinished:)
                                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                                  object:moviePlayer];
                       [[NSNotificationCenter defaultCenter] addObserver:self
                                                                selector:@selector(playMovieFinished:)
                                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                                  object:moviePlayer];
                       [moviePlayer setFullscreen:YES animated:YES];
                       [moviePlayer play];
                   }
                  failureBlock:^(NSError *error) {
                      NSLog(@"!!!ERROR: cannot get image: %@", [error description]);
                  }];
   
//    [self setcon]
}



- (void)playMovieFinished:(NSNotification*)theNotification
{
    if (theNotification.name == MPMoviePlayerPlaybackDidFinishNotification)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:theNotification.object];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:MPMoviePlayerDidExitFullscreenNotification
         object:theNotification.object];
    }
}

/**
 *	@brief	显示网站
 */
- (void)showWebSite
{
    UIWebView *webview = [[UIWebView alloc] init];
    webview.scalesPageToFit = YES;
    webview.frame = CGRectMake(0, 0, MainWidth, MainHeight - self.navigationController.view.frame.size.height);
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:noteAttach.url]];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
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
