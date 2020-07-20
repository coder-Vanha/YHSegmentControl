//
//  YHSegmentItem.m
//  YHSegmentView
//
//  Created by Vanha on 2020/7/12.
//

#import "YHSegmentItem.h"
#import "YHSegmentSetting.h"
#import "UIView+YHSize.h"
#import "SDWebImage.h"

 NSString * const kYHSegmentItemCellID = @"kYHSegmentItemCellID";

@interface YHSegmentItem ()

@property (nonatomic, strong) CALayer *redDot;
@property (nonatomic, strong) UIButton *itemBtn;
@property (nonatomic, strong) UIImageView *tips;
@property (nonatomic, strong) YHSegmentItmeModel *model;
@property (nonatomic, strong) YHSegmentSetting *setting;

@end

@implementation YHSegmentItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.itemBtn];
        [self addSubview:self.tips];
        [self.layer addSublayer:self.redDot];
    }
    return self;
}

- (void)yh_refreshDataWithModel:(id)model setting:(nonnull YHSegmentSetting *)setting{
    if (![model isKindOfClass:[YHSegmentItmeModel class]]) return;
    
    self.model = model;
    self.setting = setting;
    YHSegmentItmeModel *itemModel = model;
    
    UIFont *itemFont = [UIFont fontWithName:setting.titleNormalFont.fontName size:setting.titleSelectFont.pointSize];
    self.itemBtn.titleLabel.font = itemFont;
    _itemBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _itemBtn.titleLabel.font = setting.titleSelectFont;
    _itemBtn.titleLabel.textColor = setting.titleNormalColor;
    

    
    if (itemModel.showBadge) {
        if (itemModel.badgeURL.length > 0) {
            _tips.hidden = NO;
            _redDot.hidden = YES;
            _tips.frame = CGRectMake(CGRectGetWidth(self.frame)-self.model.badgeSize.width + itemModel.badgeInsets.right, itemModel.badgeInsets.top, self.model.badgeSize.width, self.model.badgeSize.height);
            [self.tips sd_setImageWithURL:[NSURL URLWithString:itemModel.badgeURL]];
            
            self.tips.backgroundColor = [UIColor redColor];
        } else {
            _tips.hidden = YES;
            _redDot.hidden = NO;
            _redDot.frame = CGRectMake(CGRectGetWidth(self.frame)-self.model.badgeSize.width+itemModel.badgeInsets.right, itemModel.badgeInsets.top, self.model.badgeSize.width, self.model.badgeSize.height);
            _redDot.cornerRadius = MIN(self.model.badgeSize.width, self.model.badgeSize.height)/2;
        }
    } else {
        _redDot.hidden = YES;
        _tips.hidden = YES;
    }
    
    CGAffineTransform currentTransform = CGAffineTransformMakeScale(setting.BaseScale, setting.BaseScale);
    _itemBtn.transform = currentTransform;
    [_itemBtn setTitleColor:setting.titleNormalColor forState:UIControlStateNormal];
    [_itemBtn setTitleColor:setting.titleSelectColor forState:UIControlStateSelected];
    [_itemBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_itemBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    if (setting.itemContentType == YHItemContentTypeText) {
         [_itemBtn setImage:nil forState:UIControlStateNormal];
        [_itemBtn setTitle:itemModel.title forState:UIControlStateNormal];
    } else if (setting.itemContentType == YHItemContentTypeImageText){
        if (itemModel.image) {
             [_itemBtn setTitle:@"" forState:UIControlStateNormal];
            [_itemBtn setImage:itemModel.image forState:UIControlStateNormal];
        } else {
            [_itemBtn setTitle:itemModel.title forState:UIControlStateNormal];
        }
    }
    

}

- (void)yh_setAnimationWithItemStatus:(YHSegmentItemStatus)status absRatio:(CGFloat)absRatio transScale:(CGFloat)transScale{
    NSString *normalFontName = self.setting.titleNormalFont.fontName;
    NSString *selectedFontName = self.setting.titleSelectFont.fontName;
  //  CGFloat normalSize = self.setting.titleNormalFont.pointSize;
    CGFloat selectedSize = self.setting.titleSelectFont.pointSize;
    
    
    switch (status) {
        case YHSegmentItemStatusNormal:
        {
            switch (_setting.itemContentType) {
                case YHItemContentTypeText:
                {
                    UIFont *normalFont = [UIFont fontWithName:normalFontName size:selectedSize];
                    self.itemBtn.titleLabel.font = normalFont;
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(transScale, transScale);
                    self.itemBtn.transform = currentTransform;
                }
                    break;
                case YHItemContentTypeImageText:
                {
                    if (_model.image) {
                        [_itemBtn setTitle:@"" forState:UIControlStateNormal];
                        [_itemBtn setImage:_model.image forState:UIControlStateNormal];
                    } else {
                        [_itemBtn setImage:nil forState:UIControlStateNormal];
                        [_itemBtn setTitle:_model.title forState:UIControlStateNormal];
                    }
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(transScale, transScale);
                    self.itemBtn.transform = currentTransform;
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        }
            break;
        case YHSegmentItemStatusSelected:
        {
            switch (_setting.itemContentType) {
                case YHItemContentTypeText:
                {
                    UIFont *selectedFont = [UIFont fontWithName:selectedFontName size:selectedSize];
                    self.itemBtn.titleLabel.font = selectedFont;
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(transScale, transScale);
                    self.itemBtn.transform = currentTransform;
                }
                    break;
                case YHItemContentTypeImageText:
                {
                    if (_model.selectedImage) {
                        [_itemBtn setTitle:@"" forState:UIControlStateNormal];
                        [_itemBtn setImage:_model.selectedImage forState:UIControlStateNormal];
                    } else {
                        [_itemBtn setImage:nil forState:UIControlStateNormal];
                        [_itemBtn setTitle:_model.title forState:UIControlStateNormal];
                    }
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(transScale, transScale);
                    self.itemBtn.transform = currentTransform;
                }
                    break;
                    
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    
}


- (void)yh_changeTitleColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    UIColor *color = [self interpolationColorFrom:fromColor to:toColor percent:percent];
    [self.itemBtn setTitleColor:color forState:UIControlStateNormal];
}


- (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

- (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat red = [self interpolationFrom:[self redWithColor:fromColor] to:[self redWithColor:toColor] percent:percent];
    CGFloat green = [self interpolationFrom:[self greenWithColor:fromColor] to:[self greenWithColor:toColor] percent:percent];
    CGFloat blue = [self interpolationFrom:[self blueWithColor:fromColor] to:[self blueWithColor:toColor] percent:percent];
    CGFloat alpha = [self interpolationFrom:[self alphaWithColor:fromColor] to:[self alphaWithColor:toColor] percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CGFloat)redWithColor:(UIColor *)color {
    CGFloat r = 0, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)greenWithColor:(UIColor *)color {
    CGFloat r, g = 0, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blueWithColor:(UIColor *)color {
    CGFloat r, g, b = 0, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)alphaWithColor:(UIColor *)color {
    return CGColorGetAlpha(color.CGColor);
}



- (UIButton *)s_button {
    return self.itemBtn;
}

- (void)itemClicked:(UIButton *)sender {
    sender.selected  = YES;
}


- (CALayer *)redDot {
    if (!_redDot) {
        _redDot = [CALayer layer];
        _redDot.backgroundColor = [UIColor redColor].CGColor;
        _redDot.cornerRadius = 3;
    }
    return _redDot;
}

- (UIButton *)itemBtn {
    if (!_itemBtn) {
        _itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _itemBtn.userInteractionEnabled = NO;
        _itemBtn.exclusiveTouch = YES;
        [_itemBtn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemBtn;
}

- (UIImageView *)tips {
    if (!_tips) {
        _tips = [[UIImageView alloc] init];
    }
    return _tips;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.itemBtn.frame = self.bounds;
}

@end
