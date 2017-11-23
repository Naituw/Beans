//
//  BeanGameProgressBar.m
//  Beans
//
//  Created by wutian on 2017/11/22.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameProgressBar.h"
#import "UIView+WBTSizes.h"

@interface BeanGameProgressBar ()

@property (nonatomic, strong) UIView * fillView;

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
}

- (UIView *)fillView
{
    if (!_fillView) {
        _fillView = [[UIView alloc] initWithFrame:self.bounds];
        _fillView.backgroundColor = [UIColor colorWithRed:255.0/255 green:126.0/255 blue:70.0/255 alpha:1.0];
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
    
    _fillView.frame = CGRectMake(0, 0, self.wbtWidth * _progress, self.wbtHeight);
}

@end
