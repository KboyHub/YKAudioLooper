//
//  YKPlayerController.m
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/22.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import "YKPlayerController.h"
#import <AVFoundation/AVFoundation.h>

@interface YKPlayerController ()<AVAudioPlayerDelegate>

@property (nonatomic)BOOL playing;
@property (strong,nonatomic)NSArray *players;

@end

@implementation YKPlayerController

- (instancetype)init{
    self = [super init];
    if (self) {
        AVAudioPlayer *guitarPlayer = [self playerForFile:@"guitar"];
        AVAudioPlayer *bassPlayer = [self playerForFile:@"bass"];
        AVAudioPlayer *drumsPlayer = [self playerForFile:@"drums"];
        _players = @[guitarPlayer,bassPlayer,drumsPlayer];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        //1.电话打入、视频接入、闹钟响起等中断事件发生时，需要相应处理
        [notiCenter addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
        //2.耳机插入、拔出，麦克风断开等线路发生改变时 需要通知控制器做相应的处理
        [notiCenter addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    }
    return self;
}

- (AVAudioPlayer *)playerForFile:(NSString *)name{
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:name withExtension:@"caf"];
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];
    if (player) {
        player.numberOfLoops = -1;
        player.enableRate = YES;
        [player prepareToPlay];
    }else{
        NSLog(@"Error createing Player is %@",[error localizedDescription]);
    }
    return player;
}


//一般功能方法
- (void)play{
    if (!self.playing) {
        NSTimeInterval delayTime = [self.players[0] deviceCurrentTime]+0.01;
        for (AVAudioPlayer *player in self.players) {
            [player playAtTime:delayTime];
        }
        self.playing = YES;
    }
}
- (void)stop{
    if (self.playing) {
        for (AVAudioPlayer *player in self.players) {
            [player stop];
            player.currentTime = 0.0f;
        }
        self.playing = NO;
    }
}
- (void)adjustPlayRate:(float)rate{
    for (AVAudioPlayer *player in self.players) {
        player.rate = rate;
    }
}

//特殊功能
//立体效果
- (void)adjustPlayPan:(float)pan forPlayerAtIndex:(NSUInteger)index{
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.pan = pan;
    }
}
//音量设置、
- (void)adjustPlayVolume:(float)volume forPlayerAtIndex:(NSUInteger)index{
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.volume = volume;
    }
}

- (BOOL)isValidIndex:(NSUInteger)index {
    return index == 0 || index < self.players.count;
}

#pragma mark - 电话打入、视频接入、闹钟响起等中断事件发生时，需要相应处理
- (void)handleInterruption:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self stop];
        if (self.delegate) {
            [self.delegate playbackStopped];
        }
    }else{
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            [self play];
            if (self.delegate) {
                [self.delegate playbackBegin];
            }
        }
    }
}
#pragma mark - 耳机插入、拔出，麦克风断开等线路发生改变时 需要通知控制器做相应的处理
- (void)handleRouteChange:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *previousRoute =
        info[AVAudioSessionRouteChangePreviousRouteKey];
        
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self stop];
            if(self.delegate){
                 [self.delegate playbackStopped];
            }
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
