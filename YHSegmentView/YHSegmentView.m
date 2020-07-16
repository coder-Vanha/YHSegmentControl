//
//  YHSegmentView.m
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 万叶华. All rights reserved.
//

#import "YHSegmentView.h"
#import "YHSegmentViewConstant.h"
#import "SDWebImage.h"
#import "UIView+YHSize.h"


static const CGFloat kLeftMargin = 6;
static const CGFloat kItemInnerPadding = 10;

@interface BBUISlideMenuItem : NSObject

@property (nonatomic, strong)   YHSegmentItmeModel    * s_model;
@property (nonatomic, strong)   NSString             * s_title;
@property (nonatomic, assign)   NSInteger            s_index;

@property (nonatomic, assign)   CGFloat              s_itemWidth;       //图片宽高比
@property (nonatomic, assign)   CGRect               s_frame;
@property (nonatomic, strong)   UIButton             * s_button;
@property (nonatomic, strong)   UIView               * s_badgeDot;
@property (nonatomic, strong)   UIImageView          * s_badgeImageView;

@end

@implementation BBUISlideMenuItem : NSObject

@end





@interface YHSegmentView ()
<
    UIScrollViewDelegate
>
{
    __block BOOL _s_isClickScroll;
    BOOL _s_isTop;
}

@property (nonatomic, strong)  YHSegmentSetting      * s_setting;
@property (nonatomic, assign)  NSInteger                      s_currentIndex;

@property (nonatomic, weak)    UIScrollView                         * s_pageScrollView;
@property (nonatomic, strong)  UIScrollView                         * s_baseScrollView;
@property (nonatomic, strong)  UIView                               * s_progressView;
@property (nonatomic, weak)    CAGradientLayer                      * s_progressLayer;
@property (nonatomic, strong)  NSMutableArray <BBUISlideMenuItem *>  * s_buttonsItems;

@property (nonatomic, strong) CADisplayLink *s_Timer;
@property (nonatomic, assign) CGFloat s_StartValue;
@property (nonatomic, assign) CGFloat s_DestinationValue;
@property (nonatomic, assign) NSTimeInterval s_Progress;
@property (nonatomic, assign) NSTimeInterval s_LastUpdate;
@property (nonatomic, assign) NSTimeInterval s_TotalTime;
@property (nonatomic, assign) BOOL s_IsClickAction;



@end



@implementation YHSegmentView

- (void)dealloc
{
    [_s_Timer invalidate];
    _s_Timer = nil;

}


+ (YHSegmentView *) menuViewWithTitles:(NSArray<NSString *> *)titles
                                  setting:(YHSegmentSetting *)setting
                       currentSelectIndex:(NSInteger)index
                           pageScrollView:(UIScrollView *)pageScrollView
                                 delegate:(id<YHSegmentViewDelegate>)delegate
{
    if (titles.count == 0)
    {
        return nil;
    }
    
    if (index < 0 || index >= titles.count)
    {
        index = 0;
    }
    
    YHSegmentView *menuView = [[YHSegmentView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    menuView.s_pageScrollView = pageScrollView;
    menuView.s_setting = setting;
    menuView.delegate = delegate;
    [menuView setSlideMenuViewWidth:menuView.s_setting.MenuViewWidth];
    [menuView refreshWithTitles:titles currentSelectIndex:index];
    
    return menuView;
}


+ (YHSegmentView *) menuViewWithModels:(NSArray<YHSegmentItmeModel *> *)models
           setting:(YHSegmentSetting *)setting
currentSelectIndex:(NSInteger)index
    pageScrollView:(UIScrollView *)pageScrollView
          delegate:(id<YHSegmentViewDelegate>)delegate
{
    if (models.count == 0)
    {
        return nil;
    }

    if (index < 0 || index >= models.count)
    {
        index = 0;
    }

    YHSegmentView *menuView = [[YHSegmentView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    menuView.s_pageScrollView = pageScrollView;
    menuView.s_setting = setting;
    menuView.delegate = delegate;
    [menuView setSlideMenuViewWidth:menuView.s_setting.MenuViewWidth];
    [menuView refreshWithModels:models currentSelectIndex:index];

    return menuView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect realFrame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.height, [[self class]heightOfMenuView]);
    if (self = [super initWithFrame:realFrame])
    {
        [self s_initData];
        [self s_initSubviews];
    }
    return self;
}

- (void)setSlideMenuViewWidth:(CGFloat)menuWidth
{
   // self.width = menuWidth;
    
    CGRect self_frame = self.frame;
    self_frame.size.width = menuWidth;
    self.frame = self_frame;
    
    CGRect baseScrollView_frame = self.s_baseScrollView.frame;
    baseScrollView_frame.size.width = menuWidth;
    self.s_baseScrollView.frame = baseScrollView_frame;
   
    
   // self.frame.size.width = menuWidth;

    BBUISlideMenuItem *item = [self.s_buttonsItems lastObject];
    if (item)
    {
        self.s_baseScrollView.contentSize = CGSizeMake(MAX(CGRectGetMaxX(item.s_frame) + kLeftMargin , self.s_baseScrollView.bounds.size.width), [[self class]heightOfMenuView]);
        self.s_baseScrollView.scrollEnabled = self.s_baseScrollView.contentSize.width > self.s_baseScrollView.bounds.size.width;
    }

}


#pragma mark - Delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.recognizeSimultaneouslyScrollView)
    {
        self.recognizeSimultaneouslyScrollView.scrollEnabled = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.recognizeSimultaneouslyScrollView)
    {
    self.recognizeSimultaneouslyScrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.recognizeSimultaneouslyScrollView)
    {
        if (!decelerate)
        {
            self.recognizeSimultaneouslyScrollView.scrollEnabled = YES;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.recognizeSimultaneouslyScrollView)
    {
        self.recognizeSimultaneouslyScrollView.scrollEnabled = YES;
    }
}


#pragma mark - User inteface methods

- (void)s_itemButtonClicked:(UIButton *)button
{
    NSInteger index = button.tag - 49000;
    self.s_IsClickAction = YES;
    [self setCurrentIndex:index];
}




#pragma mark - Public methods


- (void)refreshWithTitles:(NSArray<NSString *> *)titles currentSelectIndex:(NSInteger)index
{
    NSArray<YHSegmentItmeModel *> *models = [YHSegmentItmeModel itemsWithTitles:titles];
    [self refreshWithModels:models currentSelectIndex:index];
}

- (void)refreshWithModels:(NSArray<YHSegmentItmeModel *> *)models currentSelectIndex:(NSInteger)index
{
    self.backgroundColor = _s_isTop ? self.s_setting.backgroundTopColor : self.s_setting.backgroundNormalColor;
    self.s_progressView.hidden = !self.s_setting.hiddenindicator;

    for (BBUISlideMenuItem *item in self.s_buttonsItems)
    {
        [item.s_button removeFromSuperview];
        [item.s_badgeDot removeFromSuperview];
        [item.s_badgeImageView removeFromSuperview];
    }
    [self.s_buttonsItems removeAllObjects];
    
    
   // self.s_setting.indicatorColors = self.s_setting.
    
    self.s_progressLayer.colors = self.s_setting.indicatorColors;


//    if (self.s_setting.progressLeftColor && self.s_setting.progressRightColor)
//    {
//        self.s_progressLayer.colors = @[(__bridge id)self.s_setting.progressLeftColor.CGColor,
//                                        (__bridge id)self.s_setting.progressRightColor.CGColor];
//    }


    CGFloat cursorX = kLeftMargin;

    for (NSInteger i = 0; i < models.count; i++)
    {
        BBUISlideMenuItem *item = [BBUISlideMenuItem new];

        YHSegmentItmeModel *model = [models objectAtIndex:i];
        item.s_model = model;
        item.s_title = model.title;
        item.s_index = i;

        switch (item.s_model.ItemType)
        {
            case BBUISlideMenuItemTypeText:
            {
                item.s_itemWidth = [item.s_title sizeWithFont:self.s_setting.titleNormalFont].width;
//                // 高度？？？？？？
//                // 字体大小？？？？？
//                item.s_itemWidth = [item.s_title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.s_setting.titleSelectFont} context:nil].size.height;
                
            }
                break;
            case BBUISlideMenuItemTypeImage:
            {
                if ([item.s_model.imageWidth floatValue] > 0 && [item.s_model.imageHeight floatValue] > 0)
                {
                    // 有返回宽高比
                    item.s_itemWidth = [item.s_model.imageWidth floatValue]/[item.s_model.imageHeight floatValue] * 20;
                }
                else
                {
                    item.s_itemWidth = self.s_setting.imageMaxWidth;
                }
            }
                break;
            default:
            {
                item.s_itemWidth = self.s_setting.imageMaxWidth;
            }
                break;
        }

        item.s_frame = CGRectMake(cursorX, 0, kItemInnerPadding + item.s_itemWidth + kItemInnerPadding, [[self class]heightOfMenuView]);

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = item.s_frame;

        if (model.ItemType == BBUISlideMenuItemTypeImage)
        {
            
            CGRect buttonframe = button.frame;
            buttonframe.size.width = item.s_itemWidth;
            
            CGPoint buttonCenter = button.center;
            buttonCenter.x = item.s_frame.origin.x + item.s_frame.size.width/2.0;
            button.center = buttonCenter;
          
        
//            button.width = item.s_itemWidth;
//            button.centerX = item.s_frame.origin.x + item.s_frame.size.width/2.0;
            
        }

        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.titleLabel.font = self.s_setting.titleSelectFont;
        button.titleLabel.textColor = self.s_setting.titleNormalColor;
//        [button setFont:self.s_setting.titleSelectFont withColor:self.s_setting.titleNormalColor];
        UIFont *buttonTitleFont = [UIFont fontWithName:self.s_setting.titleNormalFont.fontName size:self.s_setting.titleSelectFont.pointSize];
        button.titleLabel.font = buttonTitleFont;
        CGAffineTransform currentTransform = CGAffineTransformMakeScale(self.s_setting.BaseScale, self.s_setting.BaseScale);
        button.transform = currentTransform;
        [button setTitleColor:self.s_setting.titleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.s_setting.titleSelectColor forState:UIControlStateSelected];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

        switch (item.s_model.ItemType)
        {
            case BBUISlideMenuItemTypeText:
            {
                [button setTitle:item.s_title forState:UIControlStateNormal];
            }
                break;
            case BBUISlideMenuItemTypeImage:
            {
                if (model.image)
                {
                    [button setImage:model.image forState:UIControlStateNormal];
                }
                else if (model.imageURL.length > 0)
                {
                    [button sd_setImageWithURL:[NSURL URLWithString:model.imageURL] forState:UIControlStateNormal];
                }
                else
                {
                    [button setTitle:item.s_title forState:UIControlStateNormal];
                }
            }
                break;
            default:
                break;
        }

        button.exclusiveTouch = YES;
        button.tag = 49000+item.s_index;
        [button addTarget:self action:@selector(s_itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.s_baseScrollView addSubview:button];
        item.s_button = button;
        
        CGFloat redDot_x = CGRectGetMaxX(item.s_frame) - 5 - 4;
        CGFloat redDot_y = 12;
        if (button.titleLabel.text.length > 0) {
            CGFloat textWidth = [item.s_title sizeWithFont:self.s_setting.titleNormalFont].width;
            redDot_x = CGRectGetMaxX(item.s_frame) - (button.frame.size.width - textWidth) / 2 - 4;
        }
        UIView *redDotView = [[UIView alloc] initWithFrame:CGRectMake(redDot_x, redDot_y, 6, 6)];
        if (item.s_model.badgeDotColor) {
            redDotView.backgroundColor = item.s_model.badgeDotColor;
        }
        
        redDotView.layer.cornerRadius = redDotView.frame.size.width/2;
        item.s_badgeDot = redDotView;
        [self.s_baseScrollView addSubview:redDotView];
        [self.s_baseScrollView  bringSubviewToFront:item.s_badgeDot];

        if (!item.s_model.showBadge)
        {
            item.s_badgeDot.hidden = YES;
        }
        
        // 如果有网络配置的badge 则隐藏 小红点
        if (item.s_model.badgeURL.length > 0) {
            item.s_badgeDot.hidden = YES;
            CGFloat badgeImageX = CGRectGetMaxX(item.s_frame) - 18;
            if (button.titleLabel.text.length > 0)
            {
                CGFloat textWidth = [item.s_title sizeWithFont:self.s_setting.titleNormalFont].width;
                badgeImageX = CGRectGetMaxX(item.s_frame) -((CGRectGetWidth(item.s_frame) - textWidth)/2 + 8);
            }
            item.s_badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(badgeImageX, 2, 24, 14)];
            [item.s_badgeImageView sd_setImageWithURL:[NSURL URLWithString:item.s_model.badgeURL]];
            [self.s_baseScrollView addSubview:item.s_badgeImageView];
            [self.s_baseScrollView bringSubviewToFront:item.s_badgeImageView];

        }
        if (item) {
            [self.s_buttonsItems addObject:item];
        }
       
        cursorX += item.s_frame.size.width;
    }

   // [self.s_progressView bringToFront];
    [self.s_baseScrollView bringSubviewToFront:self.s_progressView];

    self.s_baseScrollView.contentSize = CGSizeMake(MAX(cursorX + kLeftMargin , self.s_baseScrollView.width), [[self class]heightOfMenuView]);
    self.s_baseScrollView.scrollEnabled = self.s_baseScrollView.contentSize.width > self.s_baseScrollView.width;
    
    if (self.s_currentIndex == index)
    {
        self.s_currentIndex = -1;
    }
    [self setCurrentIndex:index animated:NO];

}



- (void)refreshSetting:(YHSegmentSetting *)setting
{
    if (!setting)
    {
        return;
    }
    
    self.s_setting = setting;
    
//    if (self.s_setting.progressLeftColor && self.s_setting.progressRightColor)
//    {
//        self.s_progressLayer.colors = @[(__bridge id)self.s_setting.progressLeftColor.CGColor,
//                                        (__bridge id)self.s_setting.progressRightColor.CGColor];
//    }
    
     self.s_progressLayer.colors = self.s_setting.indicatorColors;
    
    CGFloat cursorX = kLeftMargin;

    for (NSInteger i=0; i<self.s_buttonsItems.count; i++)
    {
        BBUISlideMenuItem *item = [self.s_buttonsItems objectAtIndex:i];
     
        switch (item.s_model.ItemType)
        {
            case BBUISlideMenuItemTypeText:
            {
                item.s_itemWidth = [item.s_title sizeWithFont:self.s_setting.titleNormalFont].width;
            }
                break;
            case BBUISlideMenuItemTypeImage:
            {
                if ([item.s_model.imageWidth floatValue] > 0 && [item.s_model.imageHeight floatValue] > 0)
                {
                    // 有返回宽高比
                    item.s_itemWidth = [item.s_model.imageWidth floatValue]/[item.s_model.imageHeight floatValue] * 20;
                }
                else
                {
                    item.s_itemWidth = self.s_setting.imageMaxWidth;
                }
            }
                break;
            default:
            {
                item.s_itemWidth = self.s_setting.imageMaxWidth;
            }
                break;
        }

        item.s_frame = CGRectMake(cursorX, 0, kItemInnerPadding + item.s_itemWidth + kItemInnerPadding, [[self class]heightOfMenuView]);

        UIButton *button = item.s_button;
        button.frame = item.s_frame;

        if (item.s_model.ItemType == BBUISlideMenuItemTypeImage)
        {
            button.width = item.s_itemWidth;
            button.centerX = item.s_frame.origin.x + item.s_frame.size.width/2.0;
        }

        if (self.s_currentIndex == i) {
//            [button setFont:self.s_setting.titleSelectFont withColor:self.s_setting.titleSelectColor];
            
            button.titleLabel.font = self.s_setting.titleSelectFont;
            button.titleLabel.textColor = self.s_setting.titleSelectColor;
            
            CGAffineTransform currentTransform = CGAffineTransformMakeScale(1, 1);
            button.transform = currentTransform;
        }
        else {
//            [button setFont:self.s_setting.titleSelectFont withColor:self.s_setting.titleNormalColor];
            
            button.titleLabel.font = self.s_setting.titleSelectFont;
            button.titleLabel.textColor = self.s_setting.titleSelectColor;
            
            UIFont *buttonTitleFont = [UIFont fontWithName:self.s_setting.titleNormalFont.fontName size:self.s_setting.titleSelectFont.pointSize];
            button.titleLabel.font = buttonTitleFont;
            CGAffineTransform currentTransform = CGAffineTransformMakeScale(self.s_setting.BaseScale, self.s_setting.BaseScale);
            button.transform = currentTransform;
            
        }
        button.tag = 49000+item.s_index;
        cursorX += item.s_frame.size.width;
    }
    
   // [self.s_progressView bringToFront];
    
    [self.s_baseScrollView bringSubviewToFront:self.s_progressView];
    
    self.s_baseScrollView.contentSize = CGSizeMake(MAX(cursorX + kLeftMargin , self.s_baseScrollView.width), [[self class]heightOfMenuView]);
    self.s_baseScrollView.scrollEnabled = self.s_baseScrollView.contentSize.width > self.s_baseScrollView.width;
}


- (void)setCurrentIndex:(NSInteger)index
{
    [self setCurrentIndex:index animated:YES];
}

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated
{
    if (self.s_currentIndex == index || index >= self.s_buttonsItems.count)
    {
        return;
    }
    self.s_StartValue = 0;
    self.s_DestinationValue = 1;
    if (index  < self.s_currentIndex)
    {
        self.s_StartValue = 1;
        self.s_DestinationValue = 0;
    }

    self.s_currentIndex = index;

    for (NSInteger i = 0; i<self.s_buttonsItems.count; i++)
    {
        BBUISlideMenuItem *item = [self.s_buttonsItems objectAtIndex:i];
        
        if (self.s_currentIndex == i)
        {
            switch (item.s_model.ItemType)
            {
                case BBUISlideMenuItemTypeText:
                {
//                    [item.s_button setFont:self.s_setting.titleSelectFont withColor:self.s_setting.titleSelectColor];
                    
                    item.s_button.titleLabel.font = self.s_setting.titleSelectFont;
                    item.s_button.titleLabel.textColor = self.s_setting.titleSelectColor;
                    
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(1, 1);
                    item.s_button.transform = currentTransform;
                }
                    break;
                case BBUISlideMenuItemTypeImage:
                {
                    item.s_button.width = item.s_itemWidth * 1.1;
                    item.s_button.centerX = item.s_frame.origin.x + item.s_frame.size.width/2.0;
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (item.s_model.ItemType)
            {
                case BBUISlideMenuItemTypeText:
                {
//                    [item.s_button setFont:self.s_setting.titleSelectFont withColor:self.s_setting.titleNormalColor];
                    
                    item.s_button.titleLabel.font = self.s_setting.titleSelectFont;
                    item.s_button.titleLabel.textColor = self.s_setting.titleSelectColor;
                    
                    UIFont *buttonTitleFont = [UIFont fontWithName:self.s_setting.titleNormalFont.fontName size:self.s_setting.titleSelectFont.pointSize];
                    item.s_button.titleLabel.font = buttonTitleFont;
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(self.s_setting.BaseScale, self.s_setting.BaseScale);
                    item.s_button.transform = currentTransform;
                    
                }
                    break;
                case BBUISlideMenuItemTypeImage:
                {
                    item.s_button.width = item.s_itemWidth;
                    item.s_button.centerX = item.s_frame.origin.x + item.s_frame.size.width/2.0;
                }
                    break;
                default:
                    break;
            }
        }
    }
    
    BBUISlideMenuItem *item = [self.s_buttonsItems objectAtIndex:index];

    if (self.s_pageScrollView.contentSize.width <= self.s_pageScrollView.width)
    {
        animated = YES; //contentSize 未被初始化 做下兼容 延后跳转
    }
    
    if ([self.s_pageScrollView isKindOfClass:[UICollectionView class]])
    {
        _s_isClickScroll = YES;


        if (animated)
        {
            [UIView animateWithDuration:0.3 animations:^{

                CGFloat progressViewSelectedWidth = 14;
                self.s_progressView.width = progressViewSelectedWidth;
                self.s_progressView.x = item.s_frame.origin.x +item.s_frame.size.width/2.0 - progressViewSelectedWidth/2.0;
                //        [self.s_pageScrollView setContentOffset:CGPointMake(self.s_pageScrollView.width * index, self.s_pageScrollView.contentOffset.y)];

            } completion:^(BOOL finished) {
                self->_s_isClickScroll = NO;
                [self s_didMoveToIndex:self.s_currentIndex];
            }];
            [self.s_pageScrollView setContentOffset:CGPointMake(self.s_pageScrollView.width * index, self.s_pageScrollView.contentOffset.y) animated:YES];
            if (self.s_IsClickAction)
            {
                self.s_LastUpdate = CACurrentMediaTime();
                self.s_TotalTime = 0.3;
                self.s_Progress = 0;
                [self.s_Timer invalidate];
                self.s_Timer = nil;
                CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
                timer.frameInterval = 0.1;
                [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
                self.s_Timer = timer;
            }

        }
        else
        {
            CGFloat progressViewSelectedWidth = 14;
            self.s_progressView.width = progressViewSelectedWidth;
            self.s_progressView.x = item.s_frame.origin.x +item.s_frame.size.width/2.0 - progressViewSelectedWidth/2.0;
            //        [self.s_pageScrollView setContentOffset:CGPointMake(self.s_pageScrollView.width * index, self.s_pageScrollView.contentOffset.y)];

            _s_isClickScroll = NO;
            [self s_didMoveToIndex:self.s_currentIndex];

            [self.s_pageScrollView setContentOffset:CGPointMake(self.s_pageScrollView.width * index, self.s_pageScrollView.contentOffset.y) animated:NO];
        }
    }
    else
    {
        if (animated)
        {
            _s_isClickScroll = YES;
            [UIView animateWithDuration:0.3 animations:^{

                CGFloat progressViewSelectedWidth = 14;
                self.s_progressView.width = progressViewSelectedWidth;
                self.s_progressView.x = item.s_frame.origin.x +item.s_frame.size.width/2.0 - progressViewSelectedWidth/2.0;
                [self.s_pageScrollView setContentOffset:CGPointMake(self.s_pageScrollView.width * index, self.s_pageScrollView.contentOffset.y)];

            } completion:^(BOOL finished) {
                self->_s_isClickScroll = NO;
                [self s_didMoveToIndex:self.s_currentIndex];
            }];
            if (self.s_IsClickAction)
            {
                self.s_LastUpdate = CACurrentMediaTime();
                self.s_TotalTime = 0.3;
                self.s_Progress = 0;
                [self.s_Timer invalidate];
                self.s_Timer = nil;
                CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
                timer.frameInterval = 0.1;
                [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
                self.s_Timer = timer;
            }

        }
        else
        {
            _s_isClickScroll = YES;

            CGFloat progressViewSelectedWidth = 14;
            self.s_progressView.width = progressViewSelectedWidth;
            self.s_progressView.x = item.s_frame.origin.x +item.s_frame.size.width/2.0 - progressViewSelectedWidth/2.0;
            [self.s_pageScrollView setContentOffset:CGPointMake(self.s_pageScrollView.width * index, self.s_pageScrollView.contentOffset.y)];

            _s_isClickScroll = NO;
            [self s_didMoveToIndex:self.s_currentIndex];

        }
    }
}

- (void)updateValue:(NSTimer *)timer
{
    NSTimeInterval now = CACurrentMediaTime();
    self.s_Progress += now - self.s_LastUpdate;
    self.s_LastUpdate = now;
    if (self.s_Progress >= self.s_TotalTime)
    {
        self.s_IsClickAction = NO;
        [self.s_Timer invalidate];
        self.s_Timer = nil;
        self.s_Progress = self.s_TotalTime;
    }
    CGFloat currentValue = self.s_StartValue;
    if (self.s_Progress >= self.s_TotalTime)
    {
        currentValue = self.s_DestinationValue;
    }
    CGFloat percent = self.s_Progress / self.s_TotalTime;
    currentValue = self.s_StartValue + (percent * (self.s_DestinationValue - self.s_StartValue));
    [self s_setScaleRatio:currentValue];
}

- (void)s_setScaleRatio:(CGFloat)ratio
{
    if (ratio < 0 || ratio > self.s_buttonsItems.count - 1)
    {
        return;
    }
    
    NSInteger leftNodeIndex = floor(ratio);
    NSInteger rightNodeIndex = ceil(ratio);
    
    BBUISlideMenuItem *leftItem = [self.s_buttonsItems objectAtIndex:leftNodeIndex];
    BBUISlideMenuItem *rightItem = [self.s_buttonsItems objectAtIndex:rightNodeIndex];
    if (ratio == leftNodeIndex && leftItem)
    {
        return;
    }
    if (ratio == rightNodeIndex && rightItem)
    {
        return;
    }
    if (leftItem && rightItem)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(bbui_menuViewScrollingRatio:currentSelectIndex:)])
        {
            [self.delegate bbui_menuViewScrollingRatio:ratio currentSelectIndex:self.s_currentIndex];
        }
    }
}


- (void)setShowTypeIsTop:(BOOL)isTop
{
    _s_isTop = isTop;
    self.backgroundColor = isTop ? self.s_setting.backgroundTopColor : self.s_setting.backgroundNormalColor;
    self.layer.shadowColor = isTop ? [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor : [UIColor clearColor].CGColor;
}

- (void)showBottomLayerShadow:(BOOL)isShow
{
    if (isShow) {
        self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    } else {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}


//-- 小红点
- (void)showRedTipWithIndex:(NSInteger)index
{
    BBUISlideMenuItem *targetItem = [self.s_buttonsItems objectAtIndex:index];

    if (targetItem && !(targetItem.s_model.badgeURL.length > 0))
    {
        targetItem.s_badgeDot.hidden = NO;
    }
}

- (void)hideRedTipWithIndex:(NSInteger)index
{
    BBUISlideMenuItem *targetItem = [self.s_buttonsItems objectAtIndex:index];

    if (targetItem )
    {
        targetItem.s_badgeDot.hidden = YES;
    }
}

- (void)hideAllRedTips
{
    for (NSInteger i=0; i<self.s_buttonsItems.count; i++)
    {
        BBUISlideMenuItem *targetItem = [self.s_buttonsItems objectAtIndex:i];

        if (targetItem)
        {
            targetItem.s_badgeDot.hidden = YES;
        }
    }
}

- (UIView *)getTabViewWithIndex:(NSInteger)index
{
    BBUISlideMenuItem *targetItem = [self.s_buttonsItems objectAtIndex:index];
    return targetItem.s_button;
}


- (void)bbui_scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_s_isClickScroll)
    {
        CGFloat ratio = scrollView.contentOffset.x / scrollView.width;
        [self s_setRatio:ratio];
    }
}

- (void)bbui_scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_s_isClickScroll)
    {
        CGFloat ratio = scrollView.contentOffset.x / scrollView.width;

        NSInteger leftNodeIndex = floor(ratio);
        NSInteger rightNodeIndex = ceil(ratio);

        CGFloat absRatio = ratio - leftNodeIndex;

        if (absRatio <=0.5)
        {
            self.s_currentIndex = leftNodeIndex;
        }
        else
        {
            self.s_currentIndex = rightNodeIndex;
        }

        [self s_didMoveToIndex:self.s_currentIndex];
    }
}



#pragma mark - Private meyhods

- (void)s_initData
{
    self.s_currentIndex = -1;
    self.s_buttonsItems = [NSMutableArray array];
}


- (void)s_initSubviews
{
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 4;
    
    //base scrollview
    UIScrollView *baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[self class]heightOfMenuView])];
    baseScrollView.showsVerticalScrollIndicator = NO;
    baseScrollView.showsHorizontalScrollIndicator = NO;
    baseScrollView.scrollEnabled = NO;
    baseScrollView.scrollsToTop = NO;
    baseScrollView.backgroundColor = [UIColor clearColor];
    baseScrollView.delegate = self;
    [self addSubview:baseScrollView];
    self.s_baseScrollView = baseScrollView;

    
    //progress view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, [[self class]heightOfMenuView] - 8, 100, 4)];
   // view.backgroundColor = [UIColor colorWithRed:255/255.0 green:128./255.0 blue:112/255.0 alpha:1];
    view.backgroundColor = [UIColor blackColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.frame.size.height/2.0;
    [self.s_baseScrollView addSubview:view];
    self.s_progressView = view;
    
    // CAGradientLayer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    gradientLayer.frame = view.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    self.s_progressLayer = gradientLayer;
}


- (void)s_setRatio:(CGFloat)ratio
{
    if (ratio < 0 || ratio > self.s_buttonsItems.count - 1)
    {
        return;
    }
    
    NSInteger leftNodeIndex = floor(ratio);
    NSInteger rightNodeIndex = ceil(ratio);
    
    BBUISlideMenuItem *leftItem = [self.s_buttonsItems objectAtIndex:leftNodeIndex];
    BBUISlideMenuItem *rightItem = [self.s_buttonsItems objectAtIndex:rightNodeIndex];
    
    CGFloat progressViewSelectedWidth = 14;
    
    
    if (ratio == leftNodeIndex && leftItem)
    {
        self.s_progressView.x = leftItem.s_frame.origin.x + leftItem.s_frame.size.width/2.0 - progressViewSelectedWidth/2.0;
        self.s_progressView.width = progressViewSelectedWidth;
    }
    else if (ratio == rightNodeIndex && rightItem)
    {
        self.s_progressView.x = rightItem.s_frame.origin.x + rightItem.s_frame.size.width/2.0 - progressViewSelectedWidth/2.0;
        self.s_progressView.width = progressViewSelectedWidth;
    }
    else
    {
        if (leftItem && rightItem)
        {
            CGFloat absRatio = ratio - leftNodeIndex;
            
            CGFloat leftItemCenterX = leftItem.s_frame.origin.x + leftItem.s_frame.size.width/2.0;
            CGFloat rightItemCenterX = rightItem.s_frame.origin.x + rightItem.s_frame.size.width/2.0;
            
            if (absRatio < 0.5)
            {
                CGFloat x = leftItemCenterX - progressViewSelectedWidth/2.0 *(1- absRatio/0.5);
                CGFloat width = progressViewSelectedWidth/2.0 *(1- absRatio/0.5) + progressViewSelectedWidth/2.0 + absRatio/0.5 *(rightItemCenterX - leftItemCenterX - progressViewSelectedWidth/2.0);
                
                self.s_progressView.x = x;
                self.s_progressView.width = width;
            }
            else if (absRatio == 0.5)
            {
                CGFloat x = leftItem.s_frame.origin.x + leftItem.s_frame.size.width/2.0 ;
                CGFloat width = rightItemCenterX - leftItemCenterX;
                self.s_progressView.x = x;
                self.s_progressView.width = width;
            }
            else
            {
                CGFloat x = leftItemCenterX + (rightItemCenterX - leftItemCenterX - progressViewSelectedWidth/2.0) * (absRatio-0.5)/0.5;
                CGFloat width = rightItemCenterX - x + progressViewSelectedWidth/2.0 * (absRatio-0.5)/0.5;
                self.s_progressView.x = x;
                self.s_progressView.width = width;
            }
        }
    }

    NSString *normalFontName = self.s_setting.titleNormalFont.fontName;
    NSString *selectedFontName = self.s_setting.titleSelectFont.fontName;
    CGFloat normalSize = self.s_setting.titleNormalFont.pointSize;
    CGFloat selectedSize = self.s_setting.titleSelectFont.pointSize;
    CGFloat deltaFontSize = fabs(selectedSize - normalSize);

    UIButton *leftButton = leftItem.s_button;
    UIButton *rightButton = rightItem.s_button;

    if (ratio == leftNodeIndex && leftItem)
    {
        // donothing
    }
    else if (ratio == rightNodeIndex && rightItem)
    {
        // donothing
    }
    else
    {
        if (leftItem && rightItem)
        {
            CGFloat absRatio = ratio - leftNodeIndex;
            if (self.delegate && [self.delegate respondsToSelector:@selector(bbui_menuViewScrollingRatio:currentSelectIndex:)])
            {
                [self.delegate bbui_menuViewScrollingRatio:ratio currentSelectIndex:self.s_currentIndex];
            }

            UIColor *leftColor = [self interpolationColorFrom:self.s_setting.titleSelectColor to:self.s_setting.titleNormalColor percent:absRatio];
            
            [leftButton setTitleColor:leftColor forState:UIControlStateNormal];

            UIColor *rightColor = [self interpolationColorFrom:self.s_setting.titleNormalColor to:self.s_setting.titleSelectColor percent:absRatio];
            [rightButton setTitleColor:rightColor forState:UIControlStateNormal];

            CGFloat baseScale = self.s_setting.BaseScale;
            CGFloat leftZoomScale = self.s_setting.MaxZoomScale - (self.s_setting.MaxZoomScale - 1) * absRatio;
            CGFloat rightZoomScale = 1 + (self.s_setting.MaxZoomScale - 1) * absRatio;

            if (absRatio < 0.5 && absRatio > 0)
            {
                // 左边选中 右边非选中
                // 左边字体变小  0 最大  0.5 最小
                // 左边图片变小  0-->100%   0.5-->95%
                // 右边不动 (未选中状态)  字体最小、图95%

                //-----  左处理
                switch (leftItem.s_model.ItemType)
                {
                    case BBUISlideMenuItemTypeText:
                    {
                        UIFont *leftFont = [UIFont fontWithName:selectedFontName size:selectedSize];
                        leftButton.titleLabel.font = leftFont;
                        CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale*leftZoomScale, baseScale*leftZoomScale);
                        leftButton.transform = currentTransform;

                    }
                        break;
                    case BBUISlideMenuItemTypeImage:
                    {
                        CGFloat deltaImageWidth = leftItem.s_itemWidth * 1.1 - leftItem.s_itemWidth;

                        leftButton.width = (leftItem.s_itemWidth * 1.1 - deltaImageWidth*absRatio);
                        leftButton.centerX = leftItem.s_frame.origin.x + leftItem.s_frame.size.width/2.0;
                    }
                        break;
                    default:
                        break;
                }

                //-----  右处理
                switch (rightItem.s_model.ItemType)
                {
                    case BBUISlideMenuItemTypeText:
                    {
                        UIFont *rightFont = [UIFont fontWithName:normalFontName size:selectedSize];
                        rightButton.titleLabel.font = rightFont;
                        CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale*rightZoomScale, baseScale*rightZoomScale);
                        rightButton.transform = currentTransform;

                    }
                        break;
                    case BBUISlideMenuItemTypeImage:
                    {
                        CGFloat deltaImageWidth = leftItem.s_itemWidth * 1.1 - leftItem.s_itemWidth;
                        rightButton.width = rightItem.s_itemWidth + deltaImageWidth * ratio;
                        rightButton.centerX = rightItem.s_frame.origin.x + rightItem.s_frame.size.width/2.0;
                    }
                        break;
                    default:
                        break;
                }
            }
            else
            {
                //左边非选中 右边选中
                //右边字体变小  0.5 最小  0.999 最大
                // 右边图片变小  0.5-->95%    0.999-->100%
                // 左边不动 (未选中状态)  字体最小、图95%

                //-----  左处理
                switch (leftItem.s_model.ItemType)
                {
                    case BBUISlideMenuItemTypeText:
                    {
                        UIFont *leftFont = [UIFont fontWithName:normalFontName size:selectedSize];
                        leftButton.titleLabel.font = leftFont;
                        CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale*leftZoomScale, baseScale*leftZoomScale);
                        leftButton.transform = currentTransform;

                    }
                        break;
                    case BBUISlideMenuItemTypeImage:
                    {
                        CGFloat deltaImageWidth = leftItem.s_itemWidth * 1.1 - leftItem.s_itemWidth;
                        leftButton.width = (leftItem.s_itemWidth * 1.1 - deltaImageWidth*absRatio);
                        leftButton.centerX = leftItem.s_frame.origin.x + leftItem.s_frame.size.width/2.0;
                    }
                        break;
                    default:
                        break;
                }

                //-----  右处理
                switch (rightItem.s_model.ItemType)
                {
                    case BBUISlideMenuItemTypeText:
                    {
                        UIFont *rightFont = [UIFont fontWithName:selectedFontName size:selectedSize];
                        rightButton.titleLabel.font = rightFont;
                        CGAffineTransform currentTransform = CGAffineTransformMakeScale(baseScale*rightZoomScale, baseScale*rightZoomScale);
                        rightButton.transform = currentTransform;

                    }
                        break;
                    case BBUISlideMenuItemTypeImage:
                    {
                        CGFloat deltaImageWidth = leftItem.s_itemWidth * 1.1 - leftItem.s_itemWidth;
                        rightButton.width = rightItem.s_itemWidth + deltaImageWidth * ratio;
                        rightButton.centerX = rightItem.s_frame.origin.x + rightItem.s_frame.size.width/2.0;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

- (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

- (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:[self redWithColor:fromColor] to:[self redWithColor:toColor] percent:percent];
    CGFloat green = [self interpolationFrom:[self greenWithColor:fromColor] to:[self greenWithColor:toColor] percent:percent];
    CGFloat blue = [self interpolationFrom:[self blueWithColor:fromColor] to:[self blueWithColor:toColor] percent:percent];
    CGFloat alpha = [self interpolationFrom:[self alphaWithColor:fromColor] to:[self alphaWithColor:toColor] percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CGFloat)redWithColor:(UIColor *)color
{
    CGFloat r = 0, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)greenWithColor:(UIColor *)color
{
    CGFloat r, g = 0, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blueWithColor:(UIColor *)color
{
    CGFloat r, g, b = 0, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)alphaWithColor:(UIColor *)color
{
    return CGColorGetAlpha(color.CGColor);
}


- (void)s_didMoveToIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bbui_menuViewDidMoveToIndex:)])
    {
        [self.delegate bbui_menuViewDidMoveToIndex:self.s_currentIndex];
    }
    if (self.s_buttonsItems.count < 0 || self.s_currentIndex > self.s_buttonsItems.count -1) {
        return;
    }
    BBUISlideMenuItem *item = [self.s_buttonsItems objectAtIndex:self.s_currentIndex];
    CGFloat menuViewWidth = [UIScreen mainScreen].bounds.size.width;
    if (self.s_setting.MenuViewWidth > 0)
    {
        menuViewWidth = self.s_setting.MenuViewWidth;
    }
    CGFloat offsetX = (menuViewWidth - item.s_frame.size.width)/2;
    CGRect toShowRect = CGRectMake(MAX(0, item.s_frame.origin.x - offsetX) , item.s_frame.origin.y, item.s_frame.size.width+2*offsetX, item.s_frame.size.height);
    [self.s_baseScrollView scrollRectToVisible:toShowRect animated:YES];
    
    for (NSInteger i = 0; i<self.s_buttonsItems.count; i++)
    {
        BBUISlideMenuItem *item = [self.s_buttonsItems objectAtIndex:i];
        
        if (self.s_currentIndex == i)
        {
            switch (item.s_model.ItemType)
            {
                case BBUISlideMenuItemTypeText:
                {
//                    [item.s_button setFont:self.s_setting.titleSelectFont withColor:self.s_setting.titleSelectColor];
                    
                    item.s_button.titleLabel.font = self.s_setting.titleSelectFont;
                    item.s_button.titleLabel.textColor = self.s_setting.titleSelectColor;
                    
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(1, 1);
                    item.s_button.transform = currentTransform;
                    
                }
                    break;
                case BBUISlideMenuItemTypeImage:
                {
                    item.s_button.width = item.s_itemWidth * 1.1;
                    item.s_button.centerX = item.s_frame.origin.x + item.s_frame.size.width/2.0;
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (item.s_model.ItemType)
            {
                case BBUISlideMenuItemTypeText:
                {
//                    [item.s_button setFont:self.s_setting.titleSelectFont withColor:self.s_setting.titleNormalColor];
                    
                    item.s_button.titleLabel.font = self.s_setting.titleSelectFont;
                    item.s_button.titleLabel.textColor = self.s_setting.titleSelectColor;
                    
                    UIFont *buttonTitleFont = [UIFont fontWithName:self.s_setting.titleNormalFont.fontName size:self.s_setting.titleSelectFont.pointSize];
                    item.s_button.titleLabel.font = buttonTitleFont;
                    CGAffineTransform currentTransform = CGAffineTransformMakeScale(self.s_setting.BaseScale, self.s_setting.BaseScale);
                    item.s_button.transform = currentTransform;
                    
                }
                    break;
                case BBUISlideMenuItemTypeImage:
                {
                    item.s_button.width = item.s_itemWidth;
                    item.s_button.centerX = item.s_frame.origin.x + item.s_frame.size.width/2.0;
                }
                    break;
                default:
                    break;
            }
        }
    }
}




#pragma mark - Utils methods

+ (CGFloat) heightOfMenuView
{
    return 44;
}


@end

