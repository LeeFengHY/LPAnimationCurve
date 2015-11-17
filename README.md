# LPAnimationCurve
iOS重绘线条动画
1.实现动画主要文件
*CurveLayer -继承CALayer
@property (nonatomic, assign) CGFloat progress; //滑动进度
- (void)drawInContext:(CGContextRef)ctx;        //内部实现方法

*CurveView  -继承UIView
@property (nonatomic, assign) CGFloat progress;
/**
 *  在progress属性的 setter 方法里，我们让 layer 去实时地重绘
 *
 *  @param progress
 */
- (void)setProgress:(CGFloat)progress
{
    self.curveLayer.progress = progress;
    [self.curveLayer setNeedsDisplay];
}

*结合上下拉刷新利用scrollView的KVO机制(contentOffset), 计算progress滑动进度实现动画
*动画相关属性-CABasicAnimation
-旋转:CGAffineTransformMakeRotation(M_PI * (diff*2/180)); //progress0~0.5的时候实时改变旋转角度
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
2.viewController里面操作
*********************************************************************
   LPPullToCurvcHeader *headerView = [[LPPullToCurvcHeader alloc] initWithAssociatedScrollView:self.tableView withNavigationBar:YES];
    
    __weak LPPullToCurvcHeader *weakHeaderView = headerView;
    //[headerView triggerPulling];
    
    [headerView addRefreshingBlock:^{
        //2秒后自动停止刷新
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakHeaderView stopRefreshing];
            
        });
    }];
    
    LPPullToCurveFooter *footerView = [[LPPullToCurveFooter alloc] initWithAssociatedScrollView:self.tableView withNavigationBar:YES];
    
    __weak LPPullToCurveFooter *weakFooterView = footerView;
    
    [footerView addRefreshingBlock:^{
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakFooterView stopRefreshing];
            
        });
    }];
    *********************************************************************
