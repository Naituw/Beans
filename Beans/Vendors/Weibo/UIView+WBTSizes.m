//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "UIView+WBTSizes.h"

#define KCoordinateScale ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.2 : 1)

CGFloat wbt_univesalCoordinate(CGFloat coordinate)
{
    return ceilf(coordinate * KCoordinateScale);
}

@implementation UIView (WBTSizes)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtLeft {
	return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtTop {
	return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtRight {
	return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtBottom {
	return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtCenterX {
	return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtCenterY {
	return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtWidth {
	return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtHeight {
	return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtTTScreenX {
	CGFloat x = 0;
	for (UIView* view = self; view; view = view.superview) {
		x += [view wbtLeft];
	}
	return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtTTScreenY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += [view wbtTop];
	}
	return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtScreenViewX {
	CGFloat x = 0;
	for (UIView* view = self; view; view = view.superview) {
		x += [view wbtLeft];
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			x -= scrollView.contentOffset.x;
		}
	}
	
	return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)wbtScreenViewY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += [view wbtTop];
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			y -= scrollView.contentOffset.y;
		}
	}
	return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)wbtScreenFrame {
	return CGRectMake([self wbtScreenViewX], [self wbtScreenViewY], [self wbtWidth], [self wbtHeight]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)wbtOrigin {
	return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)wbtSize {
	return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWbtSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)wbt_descendantOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls])
		return self;
	
	for (UIView* child in self.subviews) {
		UIView* it = [child wbt_descendantOrSelfWithClass:cls];
		if (it)
			return it;
	}
	
	return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)wbt_ancestorOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
	} else if (self.superview) {
		return [self.superview wbt_ancestorOrSelfWithClass:cls];
	} else {
		return nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)wbt_removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)wbt_offsetFromView:(UIView*)otherView {
	CGFloat x = 0, y = 0;
	for (UIView* view = self; view && view != otherView; view = view.superview) {
		x += [view wbtLeft];
		y += [view wbtTop];
	}
	return CGPointMake(x, y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)wbt_viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}

- (UIImage *)wbt_imageFromView
{
    CGSize size = self.wbtSize;
    if (!size.height || !size.width || CGRectIsEmpty(self.frame)) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)wbt_imageFromViewWithLowResolution
{
//    CGSize size = self.wbtSize;
    CGSize size = self.bounds.size; //解决iOS7下横屏显示问题
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.5);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)wbt_imageFromViewInRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)wbt_imageFromBlurView
{
    CGSize size = self.wbtSize;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, size.width , size.height ) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)wbt_imageFromBlurViewWithLowResolution
{
    CGSize size = self.wbtSize;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.5);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, size.width , size.height ) afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)wbt_imageFromViewWithLowResolutionInRect:(CGRect)rect
{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.5);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGRect)wbt_convertFrameToWindow:(UIWindow *)window
{
    
    UIView *superView = [self superview];
    
    CGRect frameInSuperView = [self frame];
    while (superView && (superView != window)){
        if ([superView superview])
        {
            frameInSuperView = [superView.superview convertRect:frameInSuperView fromView:superView];
        }
        superView = [superView superview];
    }
    return frameInSuperView;
}

- (CGRect)wbt_expandedFrame:(CGRect)originalFrame withOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, -offset, -offset);
}

- (CGRect)wbt_expandedFrame:(CGRect)originalFrame withVerticalOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, 0, -offset);
}

- (CGRect)wbt_expandedFrame:(CGRect)originalFrame withHorizontalOffset:(CGFloat)offset
{
    if (CGRectIsEmpty(originalFrame))
    {
        return CGRectZero;
    }
    return CGRectInset(originalFrame, -offset, 0);
}

- (UIView*)wbt_viewForAnimation
{
    return nil;
}

@end



