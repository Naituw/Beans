//
//  BeanScoreView.m
//  Beans
//
//  Created by wutian on 2017/11/21.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanScoreView.h"
#import "BeanAnimatedCountView.h"
#import "BeanGameResource.h"
#import "EXTScope.h"
#import "UIView+WBTSizes.h"

@interface BeanScoreView ()

@property (nonatomic, strong) BeanAnimatedCountView * countView;
@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UIImageView * beanIconView;
@property (nonatomic, assign) NSUInteger digitCount;

@end

@implementation BeanScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _score = -1;
        self.score = 0;
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.beanIconView];
        [self addSubview:self.countView];
        
        [self countDidUpdate];
    }
    return self;
}

- (BeanAnimatedCountView *)countView
{
    if (!_countView) {
        _countView = [[BeanAnimatedCountView alloc] initWithNumberImages:[BeanGameResource scoreNumberImages]];
        _countView.imageMargin = -6;
        @weakify(self);
        [_countView setUpdateBlock:^{
            @strongify(self);
            if (!self) {
                return;
            }
            [self countDidUpdate];
        }];
    }
    return _countView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImageView;
}

- (UIImageView *)beanIconView
{
    if (!_beanIconView) {
        _beanIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orange_normal"]];
        _beanIconView.wbtSize = CGSizeMake(34, 34);
    }
    return _beanIconView;
}

- (void)countDidUpdate
{
    self.digitCount = _countView.digitCount;
}

- (void)setDigitCount:(NSUInteger)digitCount
{
    if (_digitCount != digitCount) {
        _digitCount = digitCount;
        
        _backgroundImageView.image = [BeanGameResource scoreBoardImageWithNumberCount:digitCount];
        
        self.wbtSize = _backgroundImageView.image.size;
        
        if (_sizeUpdateBlock) {
            _sizeUpdateBlock();
        }
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroundImageView.frame = self.bounds;
    _beanIconView.wbtRight = self.wbtWidth - 10;
    _beanIconView.wbtBottom = self.wbtHeight - 12;
    _countView.wbtCenterX = 10 + (self.wbtWidth - 60) / 2;
    _countView.wbtBottom = self.wbtHeight - 7;
}

- (void)setScore:(NSInteger)score
{
    score = MIN(score, 99999);
    if (_score != score) {
        _score = score;
        
        NSInteger delta = ABS(score - (NSInteger)_countView.presentationCount);
        NSTimeInterval duration = 1.0 * ((double)delta / 1000.0);
        duration = MIN(duration, 1);
        [_countView setCount:score animateDuration:duration];
    }
}

@end
