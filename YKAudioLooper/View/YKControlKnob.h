//
//  YKControlKnob.h
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/23.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKControlKnob : UIControl

@property (nonatomic)float maximumValue;
@property (nonatomic)float minimumValue;
@property (nonatomic)float defaultValue;
@property (nonatomic)float value;

@end


@interface YKGreenControlKnob :YKControlKnob

@end

@interface YKOrangeControlKnob :YKControlKnob

@end
