//
//  YKPlayerController.h
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/22.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YKPlayerControllerDelegate <NSObject>

- (void)playbackStopped;
- (void)playbackBegin;

@end

@interface YKPlayerController : NSObject

@property (nonatomic,readonly,getter=isPlaying)BOOL playing;

@property (nonatomic,weak)id <YKPlayerControllerDelegate> delegate;

//一般功能方法
- (void)play;
- (void)stop;
- (void)adjustPlayRate:(float)rate;

//特殊功能
- (void)adjustPlayPan:(float)pan forPlayerAtIndex:(NSUInteger)index;//立体效果
- (void)adjustPlayVolume:(float)volume forPlayerAtIndex:(NSUInteger)index;//音量设、


@end
