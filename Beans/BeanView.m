//
//  BeanView.m
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanView.h"
#import "BeanView+SubClass.h"

@interface BeanView ()

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation BeanView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self updateImageView];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

- (void)updateImageView
{
    NSString * imageName = nil;
    switch (_state) {
        default:
        case BeanViewStateNormal:
            imageName = [[self class] imageName];
            break;
        case BeanViewStateBitten:
            imageName = [[self class] bittenImageName];
            break;
    }
    _imageView.image = [UIImage imageNamed:imageName];
}

+ (instancetype)view
{
    return [[self alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = [self defaultSize]}];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(40, 40);
}

+ (NSString *)imageName
{
    return @"";
}

+ (NSString *)bittenImageName
{
    return @"";
}

- (void)bite
{
    if (_state == BeanViewStateNormal) {
        _state = BeanViewStateBitten;
        [self updateImageView];
        [self _runBiteAnimation];
    }
}

- (void)_runBiteAnimation
{
    
}

@end
