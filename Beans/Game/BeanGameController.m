//
//  BeanGameController.m
//  Beans
//
//  Created by 吴天 on 2017/11/13.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameController.h"
#import "BeanGamePhaseController.h"
#import "BeanGameCountdownPhase.h"
#import "BeanGamePlayingPhase.h"
#import "BeanGameResultPhase.h"
#import "BeanGameDefines.h"
#import "FBTweakViewController.h"

@interface BeanGameController () <ARSessionDelegate, ARSCNViewDelegate>

@property (nonatomic, weak) ARSession * session;
@property (nonatomic, weak) ARSCNView * scnView;
@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, weak) UIView * interfaceView;
@property (nonatomic, strong) dispatch_queue_t sceneKitQueue;
@property (nonatomic, strong) SCNNode * faceNode;
@property (nonatomic, strong) SCNNode * mouthLeftNode;
@property (nonatomic, strong) SCNNode * mouthRightNode;
@property (nonatomic, strong) ARFaceAnchor * faceAnchor;

@property (nonatomic, strong) UIView * mouthView;
@property (nonatomic, strong) BeanGamePhaseController * phaseController;
@property (nonatomic, strong) BeanGamePlayingPhase * playingPhase;
@property (nonatomic, strong) BeanGameResultPhase * resultPhase;

@property (nonatomic, assign) BOOL mouthOpen;

@end

@implementation BeanGameController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithARSCNView:(ARSCNView *)scnView contentContainerView:(UIView *)contentView interfaceContainerView:(UIView *)interfaceView
{
    if (self = [self init]) {
        _sceneKitQueue = dispatch_queue_create("com.wutian.scenekitqueue", NULL);
        _scnView = scnView;
        self.session = _scnView.session;
        _contentView = contentView;
        _interfaceView = interfaceView;
        _scnView.delegate = self;
        
        if (BeanGameMouthTrackDebugging) {
            [_contentView addSubview:self.mouthView];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phaseStateDidUpdateNotification:) name:BeanGamePhaseDidUpdateStateNotification object:nil];
    }
    return self;
}

- (UIView *)mouthView
{
    if (!_mouthView) {
        _mouthView = [[UIView alloc] initWithFrame:CGRectZero];
        _mouthView.backgroundColor = [UIColor redColor];
        _mouthView.layer.anchorPoint = CGPointMake(0, 0);
    }
    return _mouthView;
}

- (void)phaseStateDidUpdateNotification:(NSNotification *)notification
{
    if (notification.object != _playingPhase) {
        return;
    }
    
    if (_playingPhase.state == BeanGamePhaseStateCompleted) {
        _resultPhase.score = _playingPhase.score;
    }
}

- (void)start
{
    if (@available(iOS 11.0, *)) {
        ARFaceTrackingConfiguration * config = [[ARFaceTrackingConfiguration alloc] init];
        config.lightEstimationEnabled = NO;
        [_session runWithConfiguration:config];
    } else {
        // Fallback on earlier versions
    }
    
    NSMutableArray<BeanGamePhase *> * phases = [NSMutableArray array];
    
    if (BeanGameCountDownPhaseEnabled) {
        [phases addObject:[BeanGameCountdownPhase phase]];
    }
    
    if (BeanGamePlayingPhaseEnabled) {
        [phases addObject:self.playingPhase];
    }
    
    if (BeanGameResultPhaseEnabled) {
        [phases addObject:self.resultPhase];
    }
    
    _phaseController = [[BeanGamePhaseController alloc] initWithPhases:phases contentView:_contentView];
    [_phaseController start];
}

- (void)stop
{
    [_session pause];
    [_phaseController stop];
}

- (BeanGamePlayingPhase *)playingPhase
{
    if (!_playingPhase) {
        _playingPhase = [BeanGamePlayingPhase phase];
    }
    return _playingPhase;
}

- (BeanGameResultPhase *)resultPhase
{
    if (!_resultPhase) {
        _resultPhase = [BeanGameResultPhase phase];
    }
    return _resultPhase;
}

- (void)setSession:(ARSession *)session
{
    if (_session != session) {
        
        if (_session) {
            _session.delegate = nil;
        }
        
        _session = session;
        
        if (_session) {
            _session.delegate = self;
        }
    }
}

- (SCNNode *)mouthLeftNode
{
    if (!_mouthLeftNode) {
        _mouthLeftNode = [[SCNNode alloc] init];
        [_mouthLeftNode setPosition:SCNVector3Make(-0.028, -0.036, 0.045)];
        [_mouthLeftNode setScale:SCNVector3Make(1.0, 1.0, 1.0)];
    }
    return _mouthLeftNode;
}

- (SCNNode *)mouthRightNode
{
    if (!_mouthRightNode) {
        _mouthRightNode = [[SCNNode alloc] init];
        [_mouthRightNode setPosition:SCNVector3Make(0.028, -0.036, 0.045)];
        [_mouthRightNode setScale:SCNVector3Make(1.0, 1.0, 1.0)];
    }
    return _mouthRightNode;
}

- (void)setupFaceNode
{
    if (!_faceNode) {
        return;
    }
    
    for (SCNNode * child in _faceNode.childNodes) {
        [child removeFromParentNode];
    }
    
    [_faceNode addChildNode:self.mouthLeftNode];
    [_faceNode addChildNode:self.mouthRightNode];
}

- (void)setMouthOpen:(BOOL)mouthOpen
{
    if (_mouthOpen != mouthOpen) {
        _mouthOpen = mouthOpen;
        
        _mouthView.backgroundColor = mouthOpen ? [UIColor greenColor] : [UIColor redColor];
        
        if (mouthOpen) {
            [_playingPhase unbite];
        } else {
            [_playingPhase bite];
        }
    }
}

- (void)updateMouthState
{
    double mouthClose = [_faceAnchor.blendShapes[ARBlendShapeLocationMouthClose] doubleValue];
    // close: ~0.004, open: ~0.18
    double mouthCloseMin = 0.01;
    double mouthCloseMax = 0.15;
    
    self.mouthOpen = mouthClose > ((mouthCloseMax - mouthCloseMin) * BeanGameMouthOpenSensitivity + mouthCloseMin);
}

- (void)updateMouthArea
{
    SCNVector3 lposition = [_mouthLeftNode worldPosition];
    lposition = [_scnView projectPoint:lposition];
    CGPoint leftPoint = CGPointMake(lposition.x, lposition.y);

    SCNVector3 rposition = [_mouthRightNode worldPosition];
    rposition = [_scnView projectPoint:rposition];
    CGPoint rightPoint = CGPointMake(rposition.x, rposition.y);
    
    [_playingPhase setLeftMouthPoint:leftPoint rightMouthPoint:rightPoint];
    
    if (!_mouthView) {
        return;
    }
    /*
         rp
        /  |
       /   |
      /    |
     /     |
    /<-rot |
   lp ----- cp
    */
    
    CGPoint lp = leftPoint, rp = rightPoint, cp = CGPointMake(rp.x, lp.y);
    
    double lp2rp = sqrt(pow((rightPoint.x - leftPoint.x), 2) + pow((rightPoint.y - leftPoint.y), 2));
    double lp2cp = ABS(cp.x - lp.x);
    
    double rot = acos(lp2cp / lp2rp);
    if (rp.y <= lp.y) {
        rot = -rot;
    }
    if (rp.x < lp.x) {
        rot = (2 * M_PI) - rot;
    }
    
    if (isnan(lp.x) || isnan(lp.y) || isnan(lp2cp) || lp2cp == 0) {
        return;
    }
    
    CGRect frame = CGRectMake(lp.x, lp.y, lp2cp, 5);
    
    if (CGRectIsNull(frame)) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _mouthView.transform = CGAffineTransformIdentity;
        _mouthView.frame = frame;
        _mouthView.transform = CGAffineTransformMakeRotation(rot);
    });
}

- (void)updateWithNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if (!_faceNode || !_faceAnchor) {
        _faceNode = node;
        if ([anchor isKindOfClass:[ARFaceAnchor class]]) {
            _faceAnchor = (ARFaceAnchor *)anchor;
        }
        dispatch_async(_sceneKitQueue, ^{
            [self setupFaceNode];
        });
    }
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    [self updateWithNode:node forAnchor:anchor];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    [self updateWithNode:node forAnchor:anchor];
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor *> *)anchors
{
    for (ARAnchor * anchor in anchors) {
        if ([anchor isKindOfClass:[ARFaceAnchor class]]) {
            _faceAnchor = (ARFaceAnchor *)anchor;
            break;
        }
    }
    [self updateMouthState];
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    [self updateMouthArea];
}

@end
