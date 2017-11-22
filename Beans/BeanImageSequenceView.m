//
//  BeanImageSequenceView.m
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanImageSequenceView.h"
#import "BeanNoAnimationLayer.h"

@interface BeanImageSequenceView ()

@property (nonatomic, strong) NSMutableArray * imageLayers;

@end

@implementation BeanImageSequenceView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageLayers = [NSMutableArray array];
    }
    return self;
}

- (void)setContent:(NSString *)content
{
    if (_content != content) {
        _content = content;
        
        [self __updateContent];
    }
}

- (UIImage *)imageForCharacter:(unichar)character
{
    return nil;
}

- (void)__updateContent
{
    NSString * displayString = _content;
    
    NSUInteger length = displayString.length;
    NSMutableArray * numbers = [NSMutableArray array];
    CGSize size = CGSizeZero;
    for (NSInteger index = 0; index < length; index++) {
        unichar character = [displayString characterAtIndex:index];
        UIImage * image = [self imageForCharacter:character];
        
        if (!image) {
            continue;
        }
        
        [numbers addObject:image];
        
        CGSize imageSize = image.size;
        size.height = MAX(size.height, imageSize.height);
        size.width += imageSize.width;
        size.width += _imageMargin;
    }
    
    size.width -= _imageMargin;
    
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
    
    length = numbers.count;
    _sequenceLength = length;
    CGFloat baseX = 0;
    for (NSInteger i = 0; i < length; i++) {
        CALayer * imageLayer = nil;
        if (i < _imageLayers.count) {
            imageLayer = _imageLayers[i];
        } else {
            imageLayer = [BeanNoAnimationLayer layer];
            [_imageLayers addObject:imageLayer];
            [self.layer addSublayer:imageLayer];
        }
        UIImage * image = numbers[i];
        CGSize size = image.size;
        imageLayer.contents = (id)image.CGImage;
        imageLayer.frame = CGRectMake(baseX, (bounds.size.height - size.height) / 2, size.width, size.height);
        baseX += size.width;
        baseX += _imageMargin;
    }
    
    while (_imageLayers.count > numbers.count) {
        CALayer * layer = _imageLayers.lastObject;
        [layer removeFromSuperlayer];
        [_imageLayers removeLastObject];
    }
    
    if (_updateBlock) {
        _updateBlock();
    }
}

@end
