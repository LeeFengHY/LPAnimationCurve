//
//  LPPullToCurvcHeader.h
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/13.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPPullToCurvcHeader : UIView

/**
 *  需要滑动多大距离才能松开
 */
@property (nonatomic, assign) CGFloat pullDistance;

/**
 *  初始化方法
 *
 *  @param scrollView scrollView 联动的视图
 *  @param navBar     是否带有导航
 *
 *  @return self
 */
- (id)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar;

/**
 *  立即触发下拉刷新
 */
- (void)triggerPulling;

/**
 *  停止旋转,并且滚动视图回弹到顶部
 */
- (void)stopRefreshing;


/**
 *  刷新执行的具体操作
 *
 *  @param block block回调
 */
- (void)addRefreshingBlock:(void(^)(void))block;

@end
