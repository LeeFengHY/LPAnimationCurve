//
//  LPPullToCurveFooter.h
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/13.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPPullToCurveFooter : UIView

/**
 *  需要滑动多大距离才能松开
 */
@property (nonatomic, assign) CGFloat pullDistane;

/**
 *  初始化方法
 *
 *  @param scrollView 关联的滚动视图
 *
 *  @return self
 */
- (instancetype)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar;

/**
 *  停止旋转, 并且滚动视图回弹到底部
 */
- (void)stopRefreshing;

/**
 *  添加footer刷新执行的具体操作
 *
 *  @param block block 回调
 */
- (void)addRefreshingBlock:(void(^)(void))block;

@end
