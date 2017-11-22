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

@end

@implementation BeanGameResultView

- (instancetype)initWithScore:(NSInteger)score
{
    if (self = [self initWithFrame:CGRectZero]) {
        _score = score;
        _percentOfPeopleBelow = [self calculatePercentOfPeopleBelowScore:score];
        
        [self addSubview:self.animatedCountView];
        [self addSubview:self.label];
        
        [_label setText:[NSString stringWithFormat:@"打败了全球%zd%%的网友!", _percentOfPeopleBelow]];
        [_label sizeToFit];
    }
    return self;
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
        _label.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
        _label.layer.shadowOffset = CGSizeMake(0, 0);
        _label.layer.shadowRadius = 4.0;
        _label.layer.shadowOpacity = 1.0;
        _label.layer.masksToBounds = NO;
    }
    return _label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(self.wbtWidth / 2, self.wbtHeight / 2);
    _animatedCountView.center = CGPointMake(center.x, center.y - 80);
    _label.center = CGPointMake(center.x, center.y + 20);
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