//
//  BeanGamePhaseController.m
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGamePhaseController.h"
#import "BeanGamePhase+Private.h"
#import "BeanGamePhase+SubClass.h"

@interface BeanGamePhaseController ()

@property (nonatomic, strong) NSArray<BeanGamePhase *> * phases;
@property (nonatomic, strong) NSMutableArray<BeanGamePhase *> * phasesToRun;
@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, assign) BOOL running;

@end

static NSInteger BeanGamePhaseControllerRunningCount;

@implementation BeanGamePhaseController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.running = NO;
}

- (instancetype)initWithPhases:(NSArray<BeanGamePhase *> *)phases contentView:(UIView *)contentView
{
    if (self = [self init]) {
        self.phases = phases;
        if (phases.count) {
            self.phasesToRun = [NSMutableArray arrayWithArray:_phases];
        }
        _contentView = contentView;
        
        NSAssert(contentView != nil, @"BeanGamePhaseController Must Have ContentView");
        NSAssert(_phasesToRun.count != 0, @"BeanGamePhaseController Must Have Phases to Run");
    }
    return self;
}

- (void)setRunning:(BOOL)running
{
    if (_running != running) {
        _running = running;
        
        if (running) {
            BeanGamePhaseControllerRunningCount++;
        } else {
            BeanGamePhaseControllerRunningCount--;
        }
        
        [UIApplication sharedApplication].idleTimerDisabled = BeanGamePhaseControllerRunningCount > 0;
    }
}

- (void)start
{
    for (BeanGamePhase * phase in _phases) {
        phase.contentView = _contentView;
    }
    [self _gameWillStart];
    
    self.running = YES;
    
    [self _runNextPhase];
}

- (void)stop
{
    self.running = NO;

    [_phasesToRun.firstObject stop];
}

- (void)_gameWillStart
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phaseStateDidUpdateNotification:) name:BeanGamePhaseDidUpdateStateNotification object:nil];

    for (BeanGamePhase * phase in _phases) {
        [phase _gameWillStart];
    }
}

- (void)_gameDidFinish
{
    for (BeanGamePhase * phase in _phases) {
        [phase _gameDidFinish];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BeanGamePhaseDidUpdateStateNotification object:nil];
    
    self.running = NO;
}

- (void)_currentPhaseCompleted
{
    [_phasesToRun removeObjectAtIndex:0];
    
    if (_phasesToRun.count && _running) {
        [self _runNextPhase];
    } else {
        [self _gameDidFinish];
    }
}

- (void)_runNextPhase
{
    [_phasesToRun.firstObject start];
}

- (void)phaseStateDidUpdateNotification:(NSNotification *)notification
{
    BeanGamePhase * phase = notification.object;
    if (phase != _phasesToRun.firstObject) {
        return;
    }
    
    if (phase.state == BeanGamePhaseStateCompleted) {
        [self _currentPhaseCompleted];
    }
}

@end
