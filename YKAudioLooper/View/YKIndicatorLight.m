//
//  YKIndicatorLight.m
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/23.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import "YKIndicatorLight.h"
#import "UIColor+YKAdditions.h"

@implementation YKIndicatorLight

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

- (void)setLightColor:(UIColor *)lightColor{
    _lightColor = lightColor;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat width = CGRectGetWidth(rect)*0.15;
    CGFloat height = CGRectGetHeight(rect)*0.15;
    CGRect indicatorRect = CGRectMake(midX-(width/2), minY+15, width, height);
    
    UIColor *storkeColor = [self.lightColor darkerColor];
    CGContextSetStrokeColorWithColor(context, storkeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.lightColor.CGColor);
    
    UIColor *shadowColor = [self.lightColor lighterColor];
    CGSize shadowOffset = CGSizeMake(0.0f, 0.0f);
    CGFloat blurRadius = 5.0f;
    
    CGContextSetShadowWithColor(context, shadowOffset, blurRadius, shadowColor.CGColor);
    
    CGContextAddEllipseInRect(context, indicatorRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


@end
