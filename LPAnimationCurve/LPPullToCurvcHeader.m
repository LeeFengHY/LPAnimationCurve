//
//  LPPullToCurvcHeader.m
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/13.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "LPPullToCurvcHeader.h"
#import "LabelView.h"
#import "CurveView.h"
#import "UIView+Convenient.h"

@interface LPPullToCurvcHeader ()
{
    LabelView *labelView;
    CurveView *curveView;
    
    CGFloat originOffset;
    BOOL willEnd;
    BOOL notTracking;
    BOOL loading;
}

@property(nonatomic,assign)CGFloat progress;
@property (nonatomic,weak)UIScrollView *associatedScrollView;
@property (nonatomic,copy)void(^refreshingBlock)(void);

@end

@implementation LPPullToCurvcHeader


/**
 *  初始化方法
 *
 *  @param scrollView 联动的视图
 *  @param navBar     是否带有导航
 *
 *  @return self
 */
- (id)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar
{
    self = [super initWithFrame:CGRectMake(scrollView.width/2 - 200/2, -100, 200, 100)];
    if (self) {
        if (navBar) {
            originOffset = 64.0f;
        }
        else
        {
            originOffset = 0.0f;
        }
        self.associatedScrollView = scrollView;
        [self setUp];
        
        /**
         *  KVO
         */
        [self.associatedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.associatedScrollView insertSubview:self atIndex:0];
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    if (!self.associatedScrollView.tracking) {
        labelView.loading = YES;
    }
    
    if (!willEnd && !loading) {
        curveView.progress = labelView.progress = progress;
    }
    
    self.center = CGPointMake(self.center.x, -fabs(self.associatedScrollView.contentOffset.y + originOffset)/2);
    
    CGFloat diff = fabs(self.associatedScrollView.contentOffset.y + originOffset) - self.pullDistance + 10;
    
    NSLog(@"contentOffset y is %0.2f++ diff is %0.2f+++loading is %ld", self.associatedScrollView.contentOffset.y,diff,(long)loading);
    if (diff > 0) {
        if (!self.associatedScrollView.tracking) {
            if (!notTracking) {
                notTracking = YES;
                loading = YES;
                NSLog(@"旋转");
                [self startLoading:curveView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    //设置联动视图位移
                    self.associatedScrollView.contentInset = UIEdgeInsetsMake(self.pullDistance + originOffset, 0, 0, 0);
                } completion:^(BOOL finished) {
                    //触发刷新需要执行的代码
                    if (_refreshingBlock) {
                        self.refreshingBlock();
                    }
                }];
            }
        }
        
        if (!loading) {
            curveView.transform = CGAffineTransformMakeRotation(M_PI *(diff*2/180));
        }
    }
    else
    {
        labelView.loading = NO;
        curveView.transform = CGAffineTransformIdentity;
    }
}

/**
 *  设置回调
 *
 *  @param block
 */
- (void)addRefreshingBlock:(void (^)(void))block
{
    self.refreshingBlock = block;
}

/**
 *  开启刷新
 */
- (void)triggerPulling
{
    [self.associatedScrollView setContentOffset:CGPointMake(0, -self.pullDistance - originOffset) animated:YES];
}

/**
 *  停止刷新
 */
- (void)stopRefreshing
{
    willEnd = YES;
    self.progress = 1.0;
    /*
     //时间函数曲线相关
     
     UIViewAnimationOptionCurveEaseInOut //时间曲线函数，由慢到快
     
     UIViewAnimationOptionCurveEaseIn //时间曲线函数，由慢到特别快
     
     UIViewAnimationOptionCurveEaseOut //时间曲线函数，由快到慢
     
     UIViewAnimationOptionCurveLinear //时间曲线函数，匀速
     http://www.daxueit.com/article/5609.html
     */
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0f;
        self.associatedScrollView.contentInset = UIEdgeInsetsMake(originOffset, 0, 0, 0);
    } completion:^(BOOL finished) {
        //还原必要的属性
        self.alpha = 1.0f;
        willEnd = NO;
        notTracking = NO;
        loading = NO;
        labelView.loading = NO;
        [self stopLoading:curveView];
    }];
}

/**
 *  移除动画
 *
 *  @param rotateView layer 层
 */
- (void)stopLoading:(UIView *)rotateView
{
    [rotateView.layer removeAllAnimations];
}

/**
 *  开始旋转动画
 *
 *  @param rotateView
 */
- (void)startLoading:(UIView *)rotateView
{
    rotateView.transform = CGAffineTransformIdentity; //还原
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.5f; //1.设置动画时间
    rotationAnimation.repeatCount = HUGE_VALF; //无穷大
    rotationAnimation.autoreverses = NO; //2.是否旋转后再旋转到原来的位置
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//3.控制动画运行的节奏
    //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [rotateView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/**
 *  完成刷新控件
 */
- (void)setUp
{
    //一些默认参数
    self.pullDistance = 99;
    
    curveView = [[CurveView alloc]initWithFrame:CGRectMake(20, 0, 30, self.height)];
    NSLog(@"self.height is %0.2f",self.height);
    [self insertSubview:curveView atIndex:0];
    
    labelView = [[LabelView alloc]initWithFrame:CGRectMake(curveView.right+ 10, curveView.y, 150, curveView.height)];
    [self insertSubview:labelView aboveSubview:curveView];//表示向指定的子视图之上，插入该视图
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        if (contentOffset.y + originOffset <= 0) {
            //设置progress 的值 0~1 fabs 求绝对值
            self.progress = MAX(0.0, MIN(fabs(contentOffset.y+originOffset)/self.pullDistance, 1.0));
            NSLog(@"self.progress is %0.2f",self.progress);
        }
    }
    
}

#pragma mark -dealloc
- (void)dealloc
{
    [self.associatedScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
