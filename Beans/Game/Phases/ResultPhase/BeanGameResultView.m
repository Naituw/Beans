//
//  BeanGameResultView.m
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameResultView.h"
#import "BeanAnimatedCountView.h"
#import "BeanGameResource.h"
#import "UIView+WBTSizes.h"
#import "EXTScope.h"

@interface BeanGameResultView ()

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger percentOfPeopleBelow;
@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) BeanAnimatedCountView * animatedCountView;
@property (nonatomic, strong) UIImageView * starView;
@property (nonatomic, strong) UIImageView * backgroundView;

@end

@implementation BeanGameResultView

- (instancetype)initWithScore:(NSInteger)score
{
    if (self = [self initWithFrame:CGRectZero]) {
        _score = score;
        _percentOfPeopleBelow = [self calculatePercentOfPeopleBelowScore:score];
        
        [self addSubview:self.starView];
        [self addSubview:self.backgroundView];
        [self addSubview:self.animatedCountView];
        [self addSubview:self.label];
        
        [_label setText:[NSString stringWithFormat:@"打败了全球%zd%%的网友!", _percentOfPeopleBelow]];
        [_label sizeToFit];
    }
    return self;
}

- (UIImageView *)starView
{
    if (!_starView) {
        _starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"final_star"]];
    }
    return _starView;
}

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soccer_bg"]];
    }
    return _backgroundView;
}

- (BeanAnimatedCountView *)animatedCountView
{
    if (!_animatedCountView) {
        _animatedCountView = [[BeanAnimatedCountView alloc] initWithNumberImages:[BeanGameResource resultScoreNumberImages]];
        
        @weakify(self);
        [_animatedCountView setUpdateBlock:^{
            @strongify(self);
            [self layoutSubviews];
        }];
    }
    return _animatedCountView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        _label.textColor = [UIColor whiteColor];
        _label.layer.shouldRasterize = YES;
        _label.layer.shadowColor = [UIColor colorWithRed:100.0/255 green:222.0/255 blue:224.0/255 alpha:1.0].CGColor;
        _label.layer.shadowOffset = CGSizeMake(0, 0);
        _label.layer.shadowRadius = 2.0;
        _label.layer.shadowOpacity = 1.0;
        _label.layer.masksToBounds = NO;
    }
    return _label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(self.wbtWidth / 2, self.wbtHeight / 2);
    
    _backgroundView.center = center;
    _starView.wbtCenterX = center.x;
    _starView.wbtBottom = _backgroundView.wbtTop + 20;
    
    _animatedCountView.center = CGPointMake(center.x, center.y - 25);
    _label.center = CGPointMake(center.x, center.y + 50);
    
}

- (NSInteger)calculatePercentOfPeopleBelowScore:(NSInteger)score
{
    // curve fit with https://mycurvefit.com/
    double x = score;
    return 98.37014 + (0.9441336 - 98.37014)/(1 + pow(x/1822.323, 1.414505));
}

- (void)startAnimating
{
    [_animatedCountView setCount:_score animateDuration:2];
}

@end
