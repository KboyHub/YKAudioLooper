//
//  UIColor+YKAdditions.m
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/23.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import "UIColor+YKAdditions.h"

@implementation UIColor (YKAdditions)


- (UIColor *)darkerColor{
    
    CGFloat hue,saturation,brightness,alpha;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:saturation brightness:MIN(1.3, 1.1) alpha:0.5];
    }
    return nil;
}
- (UIColor *)lighterColor{
    CGFloat hue,saturation,brightness,alpha;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness*0.92 alpha:alpha];
    }
    return nil;
}

@end
