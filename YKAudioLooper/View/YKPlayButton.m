//
//  YKPlayButton.m
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/23.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import "YKPlayButton.h"
#import "UIColor+YKAdditions.h"

@implementation YKPlayButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    UIColor *strokeColor = [UIColor colorWithWhite:0.06 alpha:1.0f];
    UIColor *gradientLightColor = [UIColor colorWithRed:0.101 green:0.100 blue:0.103 alpha:1.000f];
    UIColor *gradientDarkColor = [UIColor colorWithRed:0.237 green:0.242 blue:0.242 alpha:1.000f];
    if (self.highlighted) {
        gradientLightColor = [gradientLightColor lighterColor];
        gradientDarkColor = [gradientDarkColor darkerColor];
    }
    NSArray *gradientColors = @[(id)gradientLightColor.CGColor,(id)gradientDarkColor.CGColor];
    CGFloat locations[]={0,1};
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, (__bridge CFArrayRef)gradientColors, locations);
    CGRect insetRect = CGRectInset(rect, 2.0f, 2.0f);
    
    CGContextSetFillColorWithColor(contextRef, strokeColor.CGColor);
    UIBezierPath *bezeierPath = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:6.0f];
    CGContextAddPath(contextRef, bezeierPath.CGPath);
    CGContextSetShadowWithColor(contextRef, CGSizeMake(0.0f, 0.5f), 2.0f,[UIColor darkGrayColor].CGColor);
    CGContextDrawPath(contextRef, kCGPathFill);
    
    CGContextSaveGState(contextRef);
    
    insetRect = CGRectInset(insetRect, 3.0f, 3.0f);
    UIBezierPath *buttonPath = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:4.0f];
    CGContextAddPath(contextRef, buttonPath.CGPath);
    CGContextClip(contextRef);
    
    CGFloat midx = CGRectGetMidX(insetRect);
    
    CGPoint startPoint = CGPointMake(midx, CGRectGetMaxY(insetRect));
    CGPoint endPoint = CGPointMake(midx, CGRectGetMinY(insetRect));
    
    
    CGContextDrawLinearGradient(contextRef, gradientRef, startPoint, endPoint, 0);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRestoreGState(contextRef);
    
    UIColor *fillColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    CGContextSetFillColorWithColor(contextRef, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(contextRef, [fillColor darkerColor].CGColor);
    
    CGFloat iconDim = 24.0f;
    
    if (!self.selected) {
        //play 按钮
        CGContextSaveGState(contextRef);
        CGContextTranslateCTM(contextRef, CGRectGetMidX(rect)-(iconDim-3)/2, CGRectGetMidY(rect)-iconDim/2);
        CGContextMoveToPoint(contextRef, 0.0f, 0.0f);
        CGContextAddLineToPoint(contextRef, 0.0f, iconDim);
        CGContextAddLineToPoint(contextRef, iconDim, iconDim/2);
        CGContextClosePath(contextRef);
        CGContextDrawPath(contextRef, kCGPathFill);
        CGContextRestoreGState(contextRef);
    }
    else{
        //stop 按钮
        CGContextSaveGState(contextRef);
        CGFloat tx = (CGRectGetWidth(rect)-iconDim)/2;
        CGFloat ty = (CGRectGetHeight(rect)-iconDim)/2;
        CGContextTranslateCTM(contextRef, tx, ty);
        CGRect stopRect = CGRectMake(0.0f, 0.0f, iconDim, iconDim);
        UIBezierPath *stopBezierPath = [UIBezierPath bezierPathWithRoundedRect:stopRect cornerRadius:2.0f];
        CGContextAddPath(contextRef, stopBezierPath.CGPath);
        CGContextDrawPath(contextRef, kCGPathFill);
        CGContextRestoreGState(contextRef);
        
    }

}




@end
