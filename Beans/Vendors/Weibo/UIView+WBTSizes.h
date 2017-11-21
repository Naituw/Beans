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

/*!
 *  该类主要是用来管理关于UIView对象的位置和大小相关的属相以及一些通过对当前UIView对象的处理来获取当前快照的操作.
 */

#import <UIKit/UIKit.h>

CGFloat wbt_univesalCoordinate(CGFloat coordinate);

@interface UIView (WBTSizes)

/*!
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat wbtLeft;

/*!
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat wbtTop;

/*!
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat wbtRight;

/*!
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat wbtBottom;

/*!
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat wbtWidth;

/*!
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat wbtHeight;

/*!
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat wbtCenterX;

/*!
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat wbtCenterY;

/*!
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat wbtTTScreenX;

/*!
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat wbtTTScreenY;

/*!
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat wbtScreenViewX;

/*!
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat wbtScreenViewY;

/*!
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect wbtScreenFrame;

/*!
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint wbtOrigin;

/*!
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize wbtSize;

/*!
 *  查找所有子视图包括自己，返回第一个指定类型Class的对象.
 *
 *  @param cls 指定的class类型
 *
 *  @return 指定类型的UIView对象
 */
- (UIView*)wbt_descendantOrSelfWithClass:(Class)cls;

/*!
 *  查找所有父视图包括自己，返回第一个指定类型Class的对象.
 *
 *  @param cls 指定的class类型
 *
 *  @return 指定类型的UIView对象
 */
- (UIView*)wbt_ancestorOrSelfWithClass:(Class)cls;

/*!
 * 删除当前UIView对象的所有子视图.
 */
- (void)wbt_removeAllSubviews;

/*!
 * 返回包含当前对象的UIViewController.
 */
- (UIViewController*)wbt_viewController;

/*!
 *  根据当前screen scale和当前视图的CGRect生成一个当前视图的截图并返回
 *
 *  @return 返回处理后的UIImage对象
 */
- (UIImage *)wbt_imageFromView;
/*!
 *  以scale=0.5和当前视图的CGRect生成一个根据当前视图对象为基础的截图并返回
 *
 *  @return 返回处理后的UIImage对象
 */
- (UIImage *)wbt_imageFromViewWithLowResolution;

/*!
 *  以所给的rect区域和screen scale生成一个根据当前视图对象为基础的截图并返回
 *
 *  @param rect 需要调整的CGRect结构
 *
 *  @return 返回处理后的UIImage对象
 */
- (UIImage *)wbt_imageFromViewInRect:(CGRect)rect;
/*!
 *  以所给的rect和scale=0.5生成一个根据当前视图对象为基础的的截图并返回
 *
 *  @param rect 需要调整的CGRect结构
 *
 *  @return 返回处理后的UIImage对象
 */
- (UIImage *)wbt_imageFromViewWithLowResolutionInRect:(CGRect)rect;

/**
 *  当iOS7下，根据view层次关系，渲染出一张UIImage；否则直接生成一个UIImage并返回
 */
- (UIImage *)wbt_imageFromBlurView;

/**
 *  当iOS7下，scale=0.5,根据view层次关系，渲染出一张UIImage；否则直接生成一个UIImage并返回
 */
- (UIImage *)wbt_imageFromBlurViewWithLowResolution;

/*!
 *  将当前view的frame转换成相对window的frame
 *
 *  @param window 对应的UIWindow对象
 *
 *  @return 返回将当前view的frame转换成相对window的frame
 */
- (CGRect)wbt_convertFrameToWindow:(UIWindow *)window;

/*!
 *  将当前view的frame的纵向扩大offset,并返回扩大后的UIview的Frame返回
 *
 *  @param originalFrame 需要调整的CGRect结构
 *  @param offset        需要调整的x坐标值大小
 *
 *  @return 返回调整后的CGRect结构
 */
- (CGRect)wbt_expandedFrame:(CGRect)originalFrame withVerticalOffset:(CGFloat)offset;
/*!
 *  将当前view的frame的水平扩大offset,并返回扩大后的UIview的Frame返回
 *
 *  @param originalFrame 需要调整的CGRect结构
 *  @param offset        需要调整的y坐标值大小
 *
 *  @return 返回调整后的CGRect结构
 */
- (CGRect)wbt_expandedFrame:(CGRect)originalFrame withHorizontalOffset:(CGFloat)offset;
/*!
 *  将当前view的frame的横，纵向扩大offset,并返回扩大后的UIview的Frame返回
 *
 *  @param originalFrame 需要调整的CGRect结构
 *  @param offset        需要调整的x,y坐标值大小
 *
 *  @return 返回调整后的CGRect结构
 */
- (CGRect)wbt_expandedFrame:(CGRect)originalFrame withOffset:(CGFloat)offset;

- (UIView*)wbt_viewForAnimation;


@end
