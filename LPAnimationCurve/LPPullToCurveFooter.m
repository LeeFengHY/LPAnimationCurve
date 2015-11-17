//
//  LPPullToCurveFooter.m
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/13.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "LPPullToCurveFooter.h"
#import "LabelView.h"
#import "CurveView.h"
#import "UIView+Convenient.h"

@interface LPPullToCurveFooter()
{
    LabelView *labelView;
    CurveView *curveView;
    
    CGSize contentSize;
    CGFloat originOffset;
    BOOL willEnd;
    BOOL notTracking;
    BOOL loading;
}
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) UIScrollView *associatedScrollView;
@property (nonatomic, copy) void(^refreshingBlock)(void);

@end

@implementation LPPullToCurveFooter


#pragma dealloc
-(void)dealloc{
    
    [self.associatedScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.associatedScrollView removeObserver:self forKeyPath:@"contentSize"];
    
}

#pragma mark -- Public Method
/**
 *  初始化方法
 *
 *  @param scrollView 关联的滚动视图
 *
 *  @return self
 */
- (instancetype)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar
{
    self = [super initWithFrame:CGRectMake(scrollView.width/2-200/2, scrollView.height, 200, 100)];
    if (self) {
        if (navBar) {
            originOffset = 64.0f;
        }else{
            originOffset = 0.0f;
        }
        self.associatedScrollView = scrollView;
        [self setUp];
        [self.associatedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.associatedScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.hidden = YES;
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
    
    CGFloat diff =  self.associatedScrollView.contentOffset.y - (self.associatedScrollView.contentSize.height - self.associatedScrollView.height) - self.pullDistane + 10;
    NSLog(@"diff is %0.2f+++self.associatedScrollView.tracking is %ld+++hidden is %ld",diff,(long)self.associatedScrollView.tracking,(long)self.hidden);
    if (diff > 0) {
        /*
         tracking:
         返回用户是否触摸内容并初始化滚动。（只读）--当touch后还没有拖动的时候,值是YES,否则NO(放手未触摸为NO开启旋转动画)
         若用户已触摸内容视图但还未开始拖动时该属性值为YES。
         */
        if (!self.associatedScrollView.tracking && !self.hidden) {
            if (!notTracking) {
                notTracking = YES;
                loading = YES;
                NSLog(@"旋转");
                [self startLoading:curveView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.associatedScrollView.contentInset = UIEdgeInsetsMake(originOffset, 0, self.pullDistane, 0);
                } completion:^(BOOL finished) {
                    if (_refreshingBlock) {
                        self.refreshingBlock();
                    }
                    
                }];
            }
        }
        
        if (!loading) {
            curveView.transform = CGAffineTransformMakeRotation(M_PI * (diff*2/180));
        }
    }
    else{
        labelView.loading = NO;
        curveView.transform = CGAffineTransformIdentity; //属性还原
    }
}

#pragma mark -- Helper Method--设置下拉刷新控件
- (void)setUp
{
    //一些默认参数
    self.pullDistane = 99;
    
    
    curveView = [[CurveView alloc]initWithFrame:CGRectMake(20, 0, 30, self.height)];
    [self insertSubview:curveView atIndex:0];
    
    
    labelView = [[LabelView alloc]initWithFrame:CGRectMake(curveView.right+ 10, curveView.y, 150, curveView.height)];
    labelView.state = UP;
    [self insertSubview:labelView aboveSubview:curveView];
    
}

- (void)addRefreshingBlock:(void (^)(void))block
{
    self.refreshingBlock = block;
}

- (void)stopRefreshing
{
    willEnd = YES;
    
    self.progress = 1.0;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0f;
        self.associatedScrollView.contentInset = UIEdgeInsetsMake(originOffset, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.alpha = 1.0f;
        willEnd = NO;
        notTracking = NO;
        loading = NO;
        labelView.loading = NO;
        [self stopLoading:curveView];
    }];
}

/**
 *  停止旋转-移除动画
 *  @param rotateView
 */
- (void)stopLoading:(UIView *)rotateView{
    
    [rotateView.layer removeAllAnimations];
    
}

/**
 *  旋转动画
 *
 *  @param rotateView
 */
- (void)startLoading:(UIView *)rotateView
{
    rotateView.transform = CGAffineTransformIdentity;
    //1.创建动画并指定动画属性
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //2.设置动画属性初始值、结束值
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];//@(M_PI * 2.0);
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO; //旋转后再旋转到原来的位置
    rotationAnimation.repeatCount = HUGE_VALF; //可看做无穷大,起到循环动画的效果
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; //控制动画运行的节奏
    //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [rotateView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

#pragma mark --KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        contentSize = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        if (contentSize.height > 0.0) {
            self.hidden = NO;
        }
        self.frame = CGRectMake(self.associatedScrollView.width/2 - 200/2, contentSize.height, 200, 100);
    }
    
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        if (contentOffset.y >= (contentSize.height - self.associatedScrollView.height)) {
            
            self.center = CGPointMake(self.center.x, contentSize.height + (contentOffset.y - (contentSize.height - self.associatedScrollView.height))/2);
            
            self.progress = MAX(0.0, MIN((contentOffset.y - (contentSize.height - self.associatedScrollView.height)) / self.pullDistane, 1.0));
            NSLog(@"contentOffset.y is %0.2f+++contentSize.height is %0.2f+++self.associatedScrollView.height is %0.2f++ progress is %0.2f",contentOffset.y,contentSize.height,self.associatedScrollView.height,self.progress);
        }
        
    }
}
@end
