//
//  LabelView.m
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/16.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "LabelView.h"
#import "UIView+Convenient.h"

#define kPullingDownString  @"下拉即可刷新..."
#define kPullingUpString    @"上拉即可刷新..."
#define kReleaseString      @"松开即可刷新..."

#define kPullingString      self.state == UP ? kPullingUpString : kPullingDownString
#define LabelHeight 50

@implementation LabelView
{
    UILabel *titileLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI
{
    self.state = DOWN;
    titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2 - LabelHeight/2, self.width, LabelHeight)];
    titileLabel.text = kPullingString;
    titileLabel.textColor = [UIColor blackColor];
    titileLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titileLabel];
}

- (void)setProgress:(CGFloat)progress
{
    titileLabel.alpha  = progress;
    
    if (!self.loading) {
        if (progress >= 1.0) {
            titileLabel.text = kReleaseString;
        }
        else
        {
            titileLabel.text = kPullingString;
        }
    }
    else
    {
        if (progress >= 0.91) {
            titileLabel.text = kReleaseString;
        }
        else
        {
            titileLabel.text = kPullingString;
        }
    }
}

@end
