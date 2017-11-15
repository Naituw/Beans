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

@end

@implementation BeanGameController

- (instancetype)initWithARSCNView:(ARSCNView *)scnView contentContainerView:(UIView *)contentView interfaceContainerView:(UIView *)interfaceView
{
    if (self = [self init]) {
        _sceneKitQueue = dispatch_queue_create("com.wutian.scenekitqueue", NULL);
        _scnView = scnView;
        self.session = _scnView.session;
        _contentView = contentView;
        _interfaceView = interfaceView;
        _scnView.delegate = self;
        
        [_contentView addSubview:self.mouthView];
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

- (void)start
{
    [_session runWithConfiguration:[[ARFaceTrackingConfiguration alloc] init]];
    
    _phaseController = [[BeanGamePhaseController alloc] initWithPhases:@[[BeanGameCountdownPhase phase], [BeanGamePlayingPhase phase], [BeanGameResultPhase phase]] contentView:_contentView];
    [_phaseController start];
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

- (void)updateMouthState
{
    double mouthClose = [_faceAnchor.blendShapes[ARBlendShapeLocationMouthClose] doubleValue];
    // close: ~0.004, open: ~0.18
    if (mouthClose > 0.05) {
        _mouthView.backgroundColor = [UIColor greenColor];
    } else {
        _mouthView.backgroundColor = [UIColor redColor];
    }
}

- (void)updateMouthArea
{
    SCNVector3 lposition = [_mouthLeftNode worldPosition];
    lposition = [_scnView projectPoint:lposition];
    CGPoint leftPoint = CGPointMake(lposition.x, lposition.y);

    SCNVector3 rposition = [_mouthRightNode worldPosition];
    rposition = [_scnView projectPoint:rposition];
    CGPoint rightPoint = CGPointMake(rposition.x, rposition.y);
    
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

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    _faceNode = node;
    if ([anchor isKindOfClass:[ARFaceAnchor class]]) {
        _faceAnchor = (ARFaceAnchor *)anchor;
    }
    dispatch_async(_sceneKitQueue, ^{
        [self setupFaceNode];
    });
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
