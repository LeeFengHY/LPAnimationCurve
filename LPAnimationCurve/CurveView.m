//
//  CurveView.m
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/13.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "CurveView.h"
#import "CurveLayer.h"

@interface CurveView()

@property (nonatomic, strong) CurveLayer *curveLayer;

@end

@implementation CurveView

+ (Class)layerClass
{
    return [CurveLayer class];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


/**
 *  在progress属性的 setter 方法里，我们让 layer 去实时地重绘(充分体现layer是UIView的代理关系)
 *
 *  @param progress
 */
- (void)setProgress:(CGFloat)progress
{
    self.curveLayer.progress = progress;
    [self.curveLayer setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.curveLayer = [CurveLayer layer];
    self.curveLayer.frame = self.bounds;
    self.curveLayer.contentsScale = [UIScreen mainScreen].scale;
    self.curveLayer.progress = 0.0f;
    [self.curveLayer setNeedsDisplay];
    [self.layer addSublayer:self.curveLayer];

}
@end
