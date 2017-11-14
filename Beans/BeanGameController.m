//
//  BeanGameController.m
//  Beans
//
//  Created by 吴天 on 2017/11/13.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameController.h"

@interface CanvasView : UIView

@property (nonatomic, weak) ARSCNView * scnView;
@property (nonatomic, strong) ARFaceGeometry * geometry;
@property (nonatomic, strong) SCNNode * node;

@end

@implementation CanvasView

- (void)setGeometry:(ARFaceGeometry *)geometry
{
    if (_geometry != geometry) {
        _geometry = geometry;
        
        [self setNeedsDisplay];
    }
}

- (void)setNode:(SCNNode *)node
{
    if (_node != node) {
        _node = node;
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    
    SCNNode * node = _node;
    
    SCNVector3 position = [node worldPosition];
    position = [_scnView projectPoint:position];
    
    CGFloat radius = 5;
    {
        CGRect rect = CGRectMake(position.x - radius, position.y - radius, 2 * radius, 2 * radius);
        CGContextFillRect(ctx, rect);
    }

    
    SCNVector3 boundingMin, boundingMax;
    [node getBoundingBoxMin:&boundingMin max:&boundingMax];
    
////    boundingMin = [node convertVector:boundingMin toNode:_scnView.pointOfView];
////    boundingMax = [node convertVector:boundingMax toNode:_scnView.pointOfView];
//
//    boundingMin = [_scnView projectPoint:boundingMin];
//    boundingMax = [_scnView projectPoint:boundingMax];
//    CGPoint min = CGPointMake(boundingMin.x, boundingMin.y);
//    CGPoint max = CGPointMake(boundingMax.x, boundingMax.y);
//
//    CGFloat radius = 5;
//    {
//        CGRect rect = CGRectMake(min.x - radius, min.y - radius, 2 * radius, 2 * radius);
//        CGContextFillRect(ctx, rect);
//    }
//    {
//        CGRect rect = CGRectMake(max.x - radius, max.y - radius, 2 * radius, 2 * radius);
//        CGContextFillRect(ctx, rect);
//    }


//    if (!_geometry) {
//        return;
//    }
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
//
//    CGSize size = _scnView.bounds.size;
//
//    for (NSInteger i = 0; i < _geometry.vertexCount; i++) {
//        vector_float3 vertor = _geometry.vertices[i];
//        SCNVector3 scnVector = SCNVector3Make(vertor[0], vertor[1], vertor[2]);
//        scnVector = [_scnView projectPoint:scnVector];
//
//        CGRect rect = CGRectMake(point.x - 1, point.y - 1, 2, 2);
//        CGContextFillRect(ctx, rect);
//    }

//    CGSize size = _scnView.bounds.size;
//
//    for (NSInteger i = 0; i < _geometry.textureCoordinateCount; i++) {
//        vector_float2 vertor = _geometry.textureCoordinates[i];
////        SCNVector3 scnVector = SCNVector3Make(vertor[0], vertor[1], vertor[2]);
////        scnVector = [_scnView projectPoint:scnVector];
//        CGPoint point = CGPointMake(vertor[0], vertor[1]);
//
//        point.x *= size.width;
//        point.y *= size.height;
//
//        CGRect rect = CGRectMake(point.x - 1, point.y - 1, 2, 2);
//        CGContextFillRect(ctx, rect);
//    }

}

@end

@interface BeanGameController () <ARSessionDelegate, ARSCNViewDelegate>

@property (nonatomic, weak) ARSession * session;
@property (nonatomic, weak) ARSCNView * scnView;
@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, weak) UIView * interfaceView;
@property (nonatomic, strong) CanvasView * canvasView;

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
        
        [_contentView addSubview:self.canvasView];
    }
    return self;
}

- (CanvasView *)canvasView
{
    if (!_canvasView) {
        _canvasView = [[CanvasView alloc] initWithFrame:_contentView.bounds];
        _canvasView.scnView = _scnView;
        _canvasView.backgroundColor = [UIColor clearColor];
    }
    return _canvasView;
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

        _canvasView.geometry = geometry;
        
//        CGRect frame = CGRectZero;
//
//        for (NSInteger i = 0; i < geometry.vertexCount; i++) {
//            vector_float3 vertor = geometry.vertices[i];
//            SCNVector3 scnVector = SCNVector3Make(vertor[0], vertor[1], vertor[2]);
//            scnVector = [_scnView projectPoint:scnVector];
//            CGPoint point = CGPointMake(scnVector.x, scnVector.y);
//
//            NSLog(@"%@", NSStringFromCGPoint(point));
//
//            if (CGRectEqualToRect(frame, CGRectZero)) {
//                frame.origin = point;
//            } else {
//                CGRect temp = CGRectZero;
//                temp.origin = point;
//                frame = CGRectUnion(frame, temp);
//            }
//        }
//
//        NSLog(@"Anchor: %@", NSStringFromCGRect(frame));
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    _canvasView.node = node;
//    SCNVector3 boundingMin, boundingMax;
//    [node getBoundingBoxMin:&boundingMin max:&boundingMax];
//    boundingMin = [node convertVector:boundingMin toNode:_scnView.pointOfView];
//    boundingMax = [node convertVector:boundingMax toNode:_scnView.pointOfView];
//
//    boundingMin = [renderer projectPoint:boundingMin];
//    boundingMax = [renderer projectPoint:boundingMax];
//    CGPoint min = CGPointMake(boundingMin.x, boundingMin.y);
//    CGPoint max = CGPointMake(boundingMax.x, boundingMax.y);
//    NSLog(@"min: %@, max: %@", NSStringFromCGPoint(min), NSStringFromCGPoint(max));
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    
}

@end
