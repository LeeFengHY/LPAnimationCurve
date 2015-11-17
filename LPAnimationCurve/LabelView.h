//
//  LabelView.h
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/16.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import <UIKit/UIKit.h>

//上下拉状态
typedef enum : NSUInteger {
    UP,
    DOWN,
} PULLINGSTATE;

@interface LabelView : UIView

/**
 *  LabelView的进度0~1
 */
@property (nonatomic, assign) CGFloat progress;

/**
 *  是否正在刷新
 */
@property (nonatomic, assign) BOOL loading;

/**
 *  上拉还是下拉
 */
@property (nonatomic, assign) PULLINGSTATE state;

@end
