//
//  AttachPreviewViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-22.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note_attach.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface AttachPreviewViewController : UIViewController

@property (strong, nonatomic) Note_attach *noteAttach;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (void)setDataSource:(Note_attach *)attach;
- (IBAction)back:(id)sender;

@end
