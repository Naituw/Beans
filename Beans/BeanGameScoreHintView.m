//
//  BeanGameScoreHintView.m
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameScoreHintView.h"

@implementation BeanGameScoreHintView

- (instancetype)initWithContent:(NSString *)content color:(NSString *)color
{
    if (self = [self initWithFrame:CGRectZero]) {
        self.content = content;
    }
    return self;
}

+ (instancetype)hintViewWithCombo:(NSInteger)combo
{
    return [[self alloc] initWithContent:[NSString stringWithFormat:@"cx%zd", combo] color:nil];
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
            return [UIImage imageNamed:@"COMBO"];
        case 'x':
            return [UIImage imageNamed:@"COMBO_X"];
        case '-':
            return nil;
        case '!':
            return nil;
        case 'g':
            return nil;
        default:
        {
            character -= 48;
            if (character >= 0 && character < 10) {
                return [UIImage imageNamed:[NSString stringWithFormat:@"COMBO_%zd", character]];
            }
        }
            break;
    }
    return nil;
}

@end
