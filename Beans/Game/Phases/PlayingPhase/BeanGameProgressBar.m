//
//  BeanGameProgressBar.m
//  Beans
//
//  Created by wutian on 2017/11/22.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameProgressBar.h"
#import "UIView+WBTSizes.h"

@interface BeanGameProgressBarFillView : UIView

@property (nonatomic, readonly) CAGradientLayer * gradientLayer;

@end

@implementation BeanGameProgressBarFillView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer
{
    return (CAGradientLayer *)self.layer;
}

@end

@interface BeanGameProgressBar ()

@property (nonatomic, strong) BeanGameProgressBarFillView * fillView;

@end

@implementation BeanGameProgressBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        self.clipsToBounds = YES;
        
        [self addSubview:self.fillView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.layer.cornerRadius = frame.size.height / 2;
    _fillView.layer.cornerRadius = self.layer.cornerRadius;
    
    _fillView.bounds = self.bounds;
}

- (UIView *)fillView
{
    if (!_fillView) {
        _fillView = [[BeanGameProgressBarFillView alloc] initWithFrame:self.bounds];
        _fillView.backgroundColor = [UIColor colorWithRed:255.0/255 green:126.0/255 blue:70.0/255 alpha:1.0];
        UIColor * leftColor = [UIColor colorWithRed:221.0/255 green:255.0/255 blue:83.0/255 alpha:1.0];
        UIColor * rightColor = [UIColor colorWithRed:23.0/255 green:236.0/255 blue:255.0/255 alpha:1.0];
        
        CAGradientLayer * gradientLayer = _fillView.gradientLayer;
        gradientLayer.colors = @[(id)leftColor.CGColor, (id)rightColor.CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }
    return _fillView;
}

- (void)setProgress:(double)progress
{
    if (_progress != progress) {
        _progress = progress;
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.origin.x -= frame.size.width * (1 - _progress);
    
    _fillView.frame = frame;
}

@end
