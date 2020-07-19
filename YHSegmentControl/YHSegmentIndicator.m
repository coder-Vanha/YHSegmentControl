//
//  YHSegmentIndicator.m
//  YHSegmentView
//
//  Created by Vanha on 2020/7/16.
//

#import "YHSegmentIndicator.h"
#import "YHSegmentSetting.h"
#import "UIView+YHSize.h"

@interface YHSegmentIndicator ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation YHSegmentIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
           CAGradientLayer *gradientLayer = [CAGradientLayer layer];
           [self.layer addSublayer:gradientLayer];
           _gradientLayer = gradientLayer;
       }
       return self;
}

- (void)yh_setGradientColorsWithSetting:(YHSegmentSetting *)setting {
    
    if (setting.hiddenindicator) return;
    self.top = setting.indicatorTop;
    self.size = setting.indicatorSize;

    self.backgroundColor = setting.indicatorBgColor;
    self.layer.cornerRadius = setting.indicatorSize.height /2;
    
    if (setting.indicatorColors.count > 0 && setting.indicatorLocations.count > 0) {
        _gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  setting.indicatorSize.height);
        _gradientLayer.startPoint = setting.indicatorStartPoint;
        _gradientLayer.endPoint = setting.indicatorEndPoint;
        _gradientLayer.locations = setting.indicatorLocations;
        _gradientLayer.colors = setting.indicatorColors;
    }
    
    
}


@end
