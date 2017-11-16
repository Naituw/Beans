//
//  BeanView.m
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanView.h"
#import "BeanView+SubClass.h"
#import "BeanView+Private.h"

@interface BeanView ()

@property (nonatomic, strong) CALayer * imageView;

@end

@implementation BeanView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        [self setFrame:frame];
        [self addSublayer:self.imageView];
        [self updateImageView];
    }
    return self;
}

- (CALayer *)imageView
{
    if (!_imageView) {
        _imageView = [CALayer layer];
        _imageView.backgroundColor = [UIColor clearColor].CGColor;
        _imageView.frame = self.bounds;
    }
    return _imageView;
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    _imageView.frame = self.bounds;
}

- (void)startRotationAnimation
{
    [_imageView removeAllAnimations];
    
    {
        CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        double initialOffset = ((double)(arc4random() % 100) / 100.0) * 2 * M_PI;
        double from = initialOffset;
        double to = initialOffset + (M_PI * 2);
        
        if ((arc4random() % 2) == 1) {
            basicAnimation.fromValue = @(from);
            basicAnimation.toValue = @(to);
        } else {
            basicAnimation.toValue = @(from);
            basicAnimation.fromValue = @(to);
        }
        basicAnimation.duration = 5.0;
        basicAnimation.repeatCount = 10;
        
        [_imageView addAnimation:basicAnimation forKey:@"rotation"];
    }
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
    _imageView.contents = (id)[UIImage imageNamed:imageName].CGImage;
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

- (id<CAAction>)actionForKey:(NSString *)event
{
    return [NSNull null];
}

@end
