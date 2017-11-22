//
//  BeanGameScoreHintView.m
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameScoreHintView.h"

@interface BeanGameScoreHintView ()

@property (nonatomic, strong) NSString * color;

@end

@implementation BeanGameScoreHintView

- (instancetype)initWithContent:(NSString *)content color:(NSString *)color
{
    if (self = [self initWithFrame:CGRectZero]) {
        self.color = color;
        self.content = content;
    }
    return self;
}

+ (NSString *)nextColor
{
    static NSArray * colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = @[@"blue", @"yellow", @"green", @"red"];
    });
    static NSUInteger colorIndex = 0;
    
    NSString * color = colors[colorIndex];
    colorIndex++;
    colorIndex = colorIndex%4;
    
    return color;
}

+ (instancetype)hintViewWithCombo:(NSInteger)combo
{
    return [[self alloc] initWithContent:[NSString stringWithFormat:@"cx%zd", combo] color:[self nextColor]];
}

+ (instancetype)hintViewWithMiss:(NSInteger)score
{
    return [[self alloc] initWithContent:[NSString stringWithFormat:@"%zd!", score] color:nil];
}

+ (instancetype)hintViewWithGreat
{
    return [[self alloc] initWithContent:@"g" color:nil];
}

- (UIImage *)imageForCharacter:(unichar)character
{
    switch (character) {
        case 'c':
            return [UIImage imageNamed:[NSString stringWithFormat:@"COMBO_%@", self.color]];
        case 'x':
            return [UIImage imageNamed:[NSString stringWithFormat:@"COMBO_%@_X", self.color]];
        case '-':
            return [UIImage imageNamed:@"miss_minus"];
        case '!':
            return [UIImage imageNamed:@"miss_bang"];
        case 'g':
            return [UIImage imageNamed:@"GREAT__"];
        default:
        {
            character -= 48;
            if (character >= 0 && character < 10) {
                if (self.color) {
                    return [UIImage imageNamed:[NSString stringWithFormat:@"COMBO_%@_%zd", self.color, character]];
                } else {
                    return [UIImage imageNamed:[NSString stringWithFormat:@"miss_%zd", character]];
                }
            }
        }
            break;
    }
    return nil;
}

@end
