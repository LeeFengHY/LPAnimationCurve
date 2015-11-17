//
//  CurveLayer.h
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/13.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CurveLayer : CALayer

/**
 *  CurveLayer的进度 0~1
 */
@property (nonatomic, assign) CGFloat progress;

@end
