//
//  ViewController.m
//  AudioAirPlay
//
//  Created by ShaoLing on 5/21/14.
//  Copyright (c) 2014 dastone.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic)   AVAudioRecorder *recorder;
@property (strong, nonatomic)   AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (IBAction)startRecord:(UIButton *)sender {
    
    if (_recorder == nil) {

        NSString *filePath = [NSString stringWithFormat:@"%@/rec_audio.caf", [self documentsDirectory]];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        
        NSError *error = nil;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        [session setActive:YES error:&error];
        NSTimeInterval bufferDuration =.005;
        [session setPreferredIOBufferDuration:bufferDuration error:&error];
        if (error) {
            NSLog(@"set buffer error");
        }

        
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        
        [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [settings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [settings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        
        _recorder = [[AVAudioRecorder alloc]initWithURL:fileURL settings:settings error:&error];
        _recorder.delegate = self;
    }
    
    if (_recorder.isRecording) {
        return;
    }
    
    if (_player && _player.isPlaying) {
        [_player stop];
    }
    
    //start recording
    [_recorder record];
    
    _label.text = @"录制中...";
}


- (IBAction)doStop:(UIButton *)sender {
    
    [self stop];

}

- (void)stop {
    _label.text = @"停止";
    
    if (_recorder.isRecording) {
        [_recorder stop];
        _recorder.delegate = nil;
        _recorder = nil;
    }
    
    if (_player.isPlaying) {
        [_player stop];
        _player = nil;
    }
    
}

- (IBAction)startPlay:(UIButton *)sender {
    
    //[self stop];
    
    //airplay
    
    [self play];
    
}

- (void)play {
    NSString *filePath = [NSString stringWithFormat:@"%@/rec_audio.caf", [self documentsDirectory]];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSError *error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];
    NSTimeInterval bufferDuration =.005;
    [session setPreferredIOBufferDuration:bufferDuration error:&error];
    if (error){
        NSLog(@"set buffer error");
    }
    
    
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];
    
    if (error) {
        NSLog(@"playing error");
    }else {
        [_player play];
        _label.text = @"播放中";
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _label.text = @"停止";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"recording finished");
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
    NSLog(@"interrupt begin");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
    NSLog(@"interrupt end");
}

- (NSString *)documentsDirectory {
    NSString *documentsDirectory;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        documentsDirectory = [paths objectAtIndex:0];
    }
    return documentsDirectory;
}

@end



