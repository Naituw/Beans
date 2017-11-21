//
//  ViewController.m
//  Beans
//
//  Created by 吴天 on 2017/11/13.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "ViewController.h"
#import <ARKit/ARKit.h>
#import "BeanGameController.h"
#import "FBTweakViewController.h"
#import "FBTweakInline.h"
#import "EXTScope.h"

@interface ViewController () <FBTweakViewControllerDelegate>

@property (nonatomic, strong) ARSCNView * scnView;
@property (nonatomic, strong) BeanGameController * gameController;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIButton * tweakButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.scnView];
    
    UIButton * tweakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tweakButton.frame = CGRectMake(10, 32, 40, 40);
    tweakButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    [tweakButton addTarget:self action:@selector(tweakButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tweakButton];
    _tweakButton = tweakButton;
    
    [self restart];
}

- (void)restart
{
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_contentView];
    
    _gameController = [[BeanGameController alloc] initWithARSCNView:_scnView contentContainerView:self.contentView interfaceContainerView:self.contentView];
    [_gameController start];
    
    [self.view bringSubviewToFront:_tweakButton];
}

- (ARSCNView *)scnView
{
    if (!_scnView) {
        _scnView = [[ARSCNView alloc] initWithFrame:self.view.bounds options:nil];
    }
    return _scnView;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _scnView.frame = self.view.bounds;
    _contentView.frame = self.view.bounds;
}

- (void)tweakButtonPressed:(id)sender
{
    FBTweakViewController *tweakVC = [[FBTweakViewController alloc] initWithStore:[FBTweakStore sharedInstance]];
    tweakVC.tweaksDelegate = self;
    // Assuming this is in the app delegate
    [self presentViewController:tweakVC animated:YES completion:nil];
    
    [_gameController stop];
    [_contentView removeFromSuperview];
}

- (void)tweakViewControllerPressedDone:(FBTweakViewController *)tweakViewController
{
    @weakify(self);
    [tweakViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        [self restart];
    }];
}

@end
