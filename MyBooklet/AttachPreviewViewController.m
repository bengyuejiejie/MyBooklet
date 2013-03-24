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
    
    // Create Cancel Button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationController setToolbarHidden:YES animated:NO];
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
    // type:0 图片
    switch ([attach.type intValue]) {
        case 0:
            [self addImgToWebview];
            break;
        default:
            break;
    }
}


/**
 *	@brief	添加imgview到webview上
 *
 */
- (void)addImgToWebview
{
    // Get image from Custom Photo Album for the selected photo url.
    if (! self.assetsLibrary) assetsLibrary = [[ALAssetsLibrary alloc] init];
    
//    [self.assetsLibrary saveImage:finalImageToSave
//                          toAlbum:kKYCustomPhotoAlbumName_
//                  completionBlock:completionBlock
//                     failureBlock:failureBlock];
    
    [assetsLibrary assetForURL:[NSURL URLWithString:self.noteAttach.url]
                        resultBlock:^(ALAsset *asset) {
                            //
                            //  thumbnail: asset.thumbnail
                            //             asset.aspectRatioThumbnail
                            // fullscreen: asset.defaultRepresentation.fullScreenImage
                            //             asset.defaultRepresentation.fullResolutionImage
                            //
                            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                            [self.webview addSubview:imgView];

                        }
                       failureBlock:^(NSError *error) {
                           NSLog(@"!!!ERROR: cannot get image: %@", [error description]);
                       }];
}

/**
 *	@brief	返回附件显示
 *
 *	@param 	sender 	
 */
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
