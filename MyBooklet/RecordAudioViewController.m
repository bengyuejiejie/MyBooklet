//
//  RecordAudioViewController.m
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-18.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import "RecordAudioViewController.h"

@interface RecordAudioViewController ()

@end

@implementation RecordAudioViewController

@synthesize audioPath, delegate, audioRecorder, audioPlayer, recordBtn, playRecordBtn,okBtn, cancelBtn;

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
    
    self.delegate = [[AttachListViewController alloc] init];
    
    //Setup the audio recorder
    NSURL *soundFileURL=[NSURL fileURLWithPath:
                         [NSTemporaryDirectory()
                          stringByAppendingString:@"sound.caf"]];
	
	NSDictionary *soundSetting;
    soundSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC],AVFormatIDKey,
                    [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,
                    [NSNumber numberWithInt: AVAudioQualityHigh],
                    AVEncoderAudioQualityKey,nil];
	
	self.audioRecorder = [[AVAudioRecorder alloc]
                          initWithURL: soundFileURL
                          settings: soundSetting
                          error: nil];
    
    //Setup the audio player
    NSURL *noSoundFileURL=[NSURL fileURLWithPath:
                           [[NSBundle mainBundle]
                            pathForResource:@"norecording" ofType:@"wav"]];
    self.audioPlayer =  [[AVAudioPlayer alloc]
                         initWithContentsOfURL:noSoundFileURL error:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	录音
 *
 *	@param 	sender 	
 */
- (IBAction)record:(id)sender
{
    if ([self.recordBtn.titleLabel.text
         isEqualToString:@"录音"]) {
		[self.audioRecorder record];
		[self.recordBtn setTitle:@"停止"
                           forState:UIControlStateNormal];
	} else {
		[self.audioRecorder stop];
 		[self.recordBtn setTitle:@"录音"
                           forState:UIControlStateNormal];
        // Load the new sound in the audioPlayer for playback
        NSURL *soundFileURL=[NSURL fileURLWithPath:
                             [NSTemporaryDirectory()
                              stringByAppendingString:@"sound.caf"]];
        self.audioPlayer =  [[AVAudioPlayer alloc]
                             initWithContentsOfURL:soundFileURL error:nil];
	}
}


/**
 *	@brief	播放音频
 *
 *	@param 	sender 	
 */
- (IBAction)playRecord:(id)sender
{
    if (self.audioPlayer) {
        [self.audioPlayer play];
    }
}


/**
 *	@brief	确定
 *
 *	@param 	sender 	
 */
- (IBAction)ok:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"3244" forKey:@"audioPath"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_RECORD_TO_ATTACHLIST" object:self userInfo:dic];
}

- (void)aaaaaa:(NSString *)str
{
    [self.delegate setRecordPath:self.audioPath];

}

/**
 *	@brief	取消
 *
 *	@param 	sender 	
 */
- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
