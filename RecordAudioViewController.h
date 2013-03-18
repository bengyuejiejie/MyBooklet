//
//  RecordAudioViewController.h
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-18.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RecordAudioViewController : UIViewController

@property (strong, nonatomic) NSString *audioPath;
@property (strong, nonatomic) AttachListViewController *delegate;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) IBOutlet UIButton *recordBtn;
@property (strong, nonatomic) IBOutlet UIButton *playRecordBtn;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)record:(id)sender;
- (IBAction)playRecord:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;
@end
