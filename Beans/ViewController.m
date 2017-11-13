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

@interface ViewController ()

@property (nonatomic, strong) ARSCNView * scnView;
@property (nonatomic, strong) BeanGameController * gameController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.scnView];
    
    _gameController = [[BeanGameController alloc] initWithARSCNView:_scnView contentContainerView:self.view interfaceContainerView:self.view];
    [_gameController start];
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
}

@end
