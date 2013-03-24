//
//  AttachPreviewViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-22.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note_attach.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface AttachPreviewViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) Note_attach *noteAttach;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

- (void)setDataSource:(Note_attach *)attach;
@end
