//
//  BeanGameController.m
//  Beans
//
//  Created by 吴天 on 2017/11/13.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameController.h"

@interface BeanGameController () <ARSessionDelegate, ARSCNViewDelegate>

@property (nonatomic, weak) ARSession * session;
@property (nonatomic, weak) ARSCNView * scnView;
@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, weak) UIView * interfaceView;

@end

@implementation BeanGameController

- (instancetype)initWithARSCNView:(ARSCNView *)scnView contentContainerView:(UIView *)contentView interfaceContainerView:(UIView *)interfaceView
{
    if (self = [self init]) {
        _scnView = scnView;
        self.session = _scnView.session;
        _contentView = contentView;
        _interfaceView = interfaceView;
        _scnView.delegate = self;
    }
    return self;
}

- (void)start
{
    [_session runWithConfiguration:[[ARFaceTrackingConfiguration alloc] init]];
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

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
    
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    for (ARFaceAnchor * faceAnchor in anchors) {
        if (![faceAnchor isKindOfClass:[ARFaceAnchor class]]) {
            return;
        }

        ARFaceGeometry * geometry = faceAnchor.geometry;

        CGRect frame = CGRectZero;

        for (NSInteger i = 0; i < geometry.vertexCount; i++) {
            vector_float3 vertor = geometry.vertices[i];
            SCNVector3 scnVector = SCNVector3Make(vertor[0], vertor[1], vertor[2]);
            scnVector = [_scnView projectPoint:scnVector];
            CGPoint point = CGPointMake(scnVector.x, scnVector.y);

            NSLog(@"%@", NSStringFromCGPoint(point));
            
            if (CGRectEqualToRect(frame, CGRectZero)) {
                frame.origin = point;
            } else {
                CGRect temp = CGRectZero;
                temp.origin = point;
                frame = CGRectUnion(frame, temp);
            }
        }

        NSLog(@"Anchor: %@", NSStringFromCGRect(frame));
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    SCNVector3 boundingMin, boundingMax;
    [node getBoundingBoxMin:&boundingMin max:&boundingMax];
    boundingMin = [node convertVector:boundingMin toNode:_scnView.pointOfView];
    boundingMax = [node convertVector:boundingMax toNode:_scnView.pointOfView];
    
    boundingMin = [renderer projectPoint:boundingMin];
    boundingMax = [renderer projectPoint:boundingMax];
    CGPoint min = CGPointMake(boundingMin.x, boundingMin.y);
    CGPoint max = CGPointMake(boundingMax.x, boundingMax.y);
    NSLog(@"min: %@, max: %@", NSStringFromCGPoint(min), NSStringFromCGPoint(max));
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    
}

@end
