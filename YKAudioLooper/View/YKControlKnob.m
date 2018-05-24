//
//  YKControlKnob.m
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/23.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import "YKControlKnob.h"
#import "UIColor+YKAdditions.h"
#import "YKIndicatorLight.h"
#import <QuartzCore/QuartzCore.h>


const float kMaxAngle = 120.0f;
const float kScalingFactor = 4.0f;

@interface YKControlKnob ()

@property (nonatomic)float angle;
@property (nonatomic)CGPoint touthOrigin;
@property (strong,nonatomic)YKIndicatorLight *indicatorLightView;

@end

@implementation YKControlKnob


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    _angle = 0.0f;
    
    _defaultValue = 0.0f;
    _minimumValue = -1.0f;
    _maximumValue = 1.0f;
    _value = _defaultValue;
    
    _indicatorLightView = [[YKIndicatorLight alloc]initWithFrame:self.bounds];
    _indicatorLightView.lightColor = [self indicatorLightColor];
    [self addSubview:_indicatorLightView];
    [self valueDidChangeFrom:_defaultValue to:_defaultValue animated:NO];
    
}

- (UIColor *)indicatorLightColor{
    
    return [UIColor whiteColor];
}

- (float)clampAngle:(float)angle{
    if (angle< -kMaxAngle) {
        angle = -kMaxAngle;
    }else if (angle >kMaxAngle){
        angle = kMaxAngle;
    }
    return angle;
}

- (float)angleForValue:(float)value{
    return ((value - self.minimumValue)/(self.maximumValue- self.minimumValue)-0.5f)*(kMaxAngle*2.0f);
}

- (float)valueForAngle:(float)angle{
    return (angle /(kMaxAngle*2.0f)+0.5f)*(self.maximumValue -self.minimumValue)+self.minimumValue;
}

- (float)valueForPonsition:(CGPoint)point{
    float delta = self.touthOrigin.y - point.y;
    float newAngle = [self clampAngle:delta*kScalingFactor+self.angle];
    return [self valueForAngle:newAngle];
}

- (void)setValue:(float)newvalue{
    [self setValue:newvalue animated:NO];
}

- (void)setValue:(float)newvalue animated:(BOOL)animated{
    float oldValue = _value;
    if (newvalue <self.minimumValue) {
        _value = self.minimumValue;
    }else if (newvalue >self.maximumValue){
        _value = self.maximumValue;
    }else{
        _value = newvalue;
    }
    [self valueDidChangeFrom:oldValue to:_value animated:animated];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint point = [touch locationInView:self];
    self.touthOrigin = point;
    self.angle = [self angleForValue:self.value];
    self.highlighted = YES;
    [self setNeedsDisplay];
    return YES;
}

- (BOOL)handleTouch:(UITouch *)touch{
    if (touch.tapCount >1) {
        [self setValue:self.defaultValue animated:YES];
        return NO;
    }
    CGPoint point = [touch locationInView:self];
    self.value = [self valueForPonsition:point];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if ([self handleTouch:touch]) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self handleTouch:touch];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    self.highlighted = NO;
    [self setNeedsDisplay];
}


- (void)valueDidChangeFrom:(float)oldValue to:(float)newValue animated:(BOOL)animated{
    float newAngle = [self angleForValue:newValue];
    if (animated) {
        float oldAngle = [self angleForValue:oldValue];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 0.2f;
        
        animation.values = @[@(oldAngle*M_PI/180.0f),@((newAngle+oldAngle)/2.0f*M_PI/180.0f),@(newAngle*M_PI/180.0f)];
        animation.keyTimes=@[@0.0f,@0.5f,@1.0f];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.indicatorLightView.layer addAnimation:animation forKey:nil];
    }
    self.indicatorLightView.transform =CGAffineTransformMakeRotation(newAngle*M_PI/180.0f);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *strokeColor = [UIColor colorWithWhite:0.06 alpha:1.0f];
    UIColor *gradientLightColor = [UIColor colorWithRed:0.101 green:0.100 blue:0.103 alpha:1.000f];
    UIColor *gradientDarkColor = [UIColor colorWithRed:0.237 green:0.242 blue:0.242 alpha:1.000f];
    
    if (self.highlighted) {
        gradientLightColor = [gradientLightColor lighterColor];
        gradientDarkColor = [gradientDarkColor darkerColor];
    }
    
    NSArray *gradientColors = @[(id)gradientLightColor.CGColor,(id)gradientDarkColor.CGColor];
    CGFloat locations[] = {0,1};
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, (__bridge CFArrayRef)gradientColors, locations);
    
    CGRect insetRect = CGRectInset(rect, 2.0f, 2.0f);
    
    CGContextSetFillColorWithColor(context, strokeColor.CGColor);
    CGContextFillEllipseInRect(context, insetRect);
    
    CGFloat midX = CGRectGetMidX(insetRect);
    CGFloat midY = CGRectGetMidY(insetRect);
    
    CGContextAddArc(context, midX, midY, CGRectGetWidth(insetRect)/2,0,M_PI*2, 1);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.5f), 2.0f, [UIColor darkGrayColor].CGColor);
    CGContextFillPath(context);
    
    CGContextAddArc(context, midX, midY, (CGRectGetWidth(insetRect)-6)/2, 0, M_PI*2, 1);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(midX, CGRectGetMaxY(insetRect));
    CGPoint endPoint = CGPointMake(midX, CGRectGetMinY(insetRect));
    
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
}

@end


@implementation YKGreenControlKnob

- (UIColor *)indicatorLightColor{
    return [UIColor colorWithRed:0.226 green:1.000 blue:0.226 alpha:1.000];
}

@end



@implementation YKOrangeControlKnob

- (UIColor *)indicatorLightColor{
    return [UIColor colorWithRed:1.000 green:0.718 blue:0.000 alpha:1.000];
}


@end









