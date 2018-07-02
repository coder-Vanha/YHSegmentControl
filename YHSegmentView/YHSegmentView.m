//
//  YHSegmentView.m
//  WorkBench
//
//  Created by wanyehua on 2017/10/26.
//  Copyright © 2017年 com.bonc. All rights reserved.
//

#import "YHSegmentView.h"
#import "YHSegmentViewConstant.h"

@interface YHSegmentView() <UIScrollViewDelegate>
/** 控制器数组 */
@property (nonatomic, strong) NSArray *viewControllersArr;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 标题Btn数组 */
@property (nonatomic, strong) NSArray *BtnArr;
/** segmentView的Size的大小 */
@property (nonatomic, assign) CGSize size;
/** 按钮title到边的间距 */
@property (nonatomic, assign) CGFloat buttonSpace;
/** 按钮宽度（用于SegmentStyle = YHSegementStyleSpace） */
@property (nonatomic, assign) CGFloat button_W;
/** 存放按钮的宽度 */
@property (nonatomic, strong) NSMutableArray *widthBtnArr;
/** segmentView头部标题视图 */
@property (nonatomic, strong) UIScrollView *segmentTitleView;
/** segmentView控制器视图 */
@property (nonatomic, strong) UIScrollView *segmentContentView;
/** 指示杆 */
@property (nonatomic, strong) UIView *indicateView;
/** 分割线View */
@property (nonatomic, strong) UIView *spaceView;
/** 当前被选中的按钮 */
@property (nonatomic, strong) UIButton *selectedButton;
/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentViewController;
/** 底部分割线 */
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, assign) CGFloat ScrollView_Y;

@end

static CGFloat Font_Default_size = 0;
static CGFloat Font_Selected_size = 0;
/**<< 默认字体大小 <<*/
#define YH_Font_Default [UIFont boldSystemFontOfSize:Font_Default_size]
/**<< 选中后大小 <<*/
#define YH_Font_Selected [UIFont boldSystemFontOfSize:Font_Selected_size]

@implementation YHSegmentView{
    yh_indexBlock _yh_resultBlock;
}

# pragma mark -- lazy

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, YH_SegmentViewHeight, _size.width, 5)];
        _bottomLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _ScrollView_Y = YH_SegmentViewHeight + 5;
    }
    return _bottomLineView;
}

- (NSMutableArray *)widthBtnArr {
    if (!_widthBtnArr) {
        _widthBtnArr = [NSMutableArray array];
    }
    return _widthBtnArr;
}

- (UIScrollView *)segmentTitleView {
    if (!_segmentTitleView) {
        _segmentTitleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _size.width, YH_SegmentViewHeight)];
        _segmentTitleView.backgroundColor = YH_SegmentBgColor;
        _segmentTitleView.showsHorizontalScrollIndicator = NO;
        _segmentTitleView.showsVerticalScrollIndicator = NO;
        self.button_W = (_size.width - YH_Space_W * (_titleArr.count -1)) / _titleArr.count;
        
    }
    return _segmentTitleView;
}

- (UIScrollView *)segmentContentView {
    if (!_segmentContentView) {
        _segmentContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _ScrollView_Y, _size.width, _size.height - _ScrollView_Y)];
        NSLog(@"ScrollViewVC_HH:%f",_size.height - _ScrollView_Y);
        _segmentContentView.delegate = self;
        _segmentContentView.showsHorizontalScrollIndicator = NO;
        _segmentContentView.pagingEnabled = YES;
        _segmentContentView.bounces = NO;
        [self addSubview:_segmentContentView];
        
        // 设置segmentScrollView的尺寸
        _segmentContentView.contentSize = CGSizeMake(_size.width * self.viewControllersArr.count, 0);
       // for (int i=0; i<self.viewControllersArr.count; i++) {
            // 默认加载第一个控制器
            UIViewController *viewController = self.viewControllersArr[0];
            viewController.view.frame = CGRectMake(_size.width * 0, 0, _size.width, _size.height-_ScrollView_Y);
            [_parentViewController addChildViewController:viewController];
            [viewController didMoveToParentViewController:_parentViewController];
            [_segmentContentView addSubview:viewController.view];
        }
   // }
    return _segmentContentView;
}

- (UIView *)indicateView {
    if (!_indicateView) {
        _indicateView = [[UIView alloc] init];
        _indicateView.backgroundColor = YH_SegmentTintColor;
        _indicateView.layer.cornerRadius = YH_IndicateHeight/2;
        _indicateView.layer.masksToBounds = YES;
    }
    return _indicateView;
}

#pragma mark -- initVC

- (instancetype)initWithFrame:(CGRect)frame ViewControllersArr:(NSArray *)viewControllersArr TitleArr:(NSArray *)titleArr TitleNormalSize:(CGFloat)titleNormalSize TitleSelectedSize:(CGFloat)titleSelectedSize SegmentStyle:(YHSegementStyle)style ParentViewController:(UIViewController *)parentViewController ReturnIndexBlock:(yh_indexBlock)indexBlock {
    if (self = [super initWithFrame:frame]) {
        _viewControllersArr = viewControllersArr;
        _titleArr = titleArr;
        _size = frame.size;
        Font_Default_size = titleNormalSize;
        Font_Selected_size = titleSelectedSize;
        _buttonSpace = [self calculateSpace];
        _parentViewController = parentViewController;
        [self loadSegmentTitleViewWithSegmentStyle:style];
        [self addSubview:self.segmentContentView];
        _yh_resultBlock = indexBlock;
    }
    return self;
}


- (CGFloat)calculateSpace {
    CGFloat space = 0.f;
    CGFloat totalWidth = 0.f;
    
    for (NSString *title in _titleArr) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : YH_Font_Selected}];
        totalWidth += titleSize.width;
    }
    
    space = (_size.width - totalWidth) / _titleArr.count / 2;
    if (space > YH_MinItemSpace / 2) {
        return space;
    } else {
        return YH_MinItemSpace / 2;
    }
}

- (void)loadSegmentTitleViewWithSegmentStyle:(YHSegementStyle)style {
    [self addSubview:self.segmentTitleView];
    [self addSubview:self.bottomLineView];
    
    CGFloat item_x = 0;
    NSString *title;
    NSMutableArray *mutBtnArr = [NSMutableArray array];
    if (style == YHSegementStyleIndicate) {
        
        for (int i = 0; i < _titleArr.count; i++) {
           title = _titleArr[i];
           CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: YH_Font_Selected}];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(item_x, 0, _buttonSpace *2 + titleSize.width, YH_SegmentViewHeight);
            [button setTag:i];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:YH_NormalColor forState:UIControlStateNormal];
            [button setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentTitleView addSubview:button];
            [mutBtnArr addObject:button];
            
            [self.widthBtnArr addObject:[NSNumber numberWithDouble:CGRectGetWidth(button.frame)]];
            item_x += _buttonSpace * 2 + titleSize.width;
            if (i == 0) {
                button.selected = YES;
                _selectedButton = button;
                _selectedButton.titleLabel.font = YH_Font_Selected;
                self.indicateView.frame = CGRectMake(_buttonSpace, YH_SegmentViewHeight - YH_IndicateHeight, titleSize.width, YH_IndicateHeight);
                [_segmentTitleView addSubview:_indicateView];
            }else {
                button.titleLabel.font = YH_Font_Default;
            }
        }
       
    }else {
        _segmentTitleView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < _titleArr.count; i++) {
            title = _titleArr[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(item_x, 0, self.button_W , YH_SegmentViewHeight);
            [button setTag:i];
            if (i != _titleArr.count - 1) {
                UIView *spaceLine = [[UIView alloc] init];
                spaceLine.frame = CGRectMake(self.button_W + (self.button_W + YH_Space_W)*i , 6, YH_Space_W, YH_SegmentViewHeight - 12);
                spaceLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [_segmentTitleView addSubview:spaceLine];
            }
            
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = YH_Font_Default;
            [button setTitleColor:YH_NormalColor forState:UIControlStateNormal];
            [button setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentTitleView addSubview:button];
            [mutBtnArr addObject:button];
            
            [self.widthBtnArr addObject:[NSNumber numberWithDouble:CGRectGetWidth(button.frame)]];
            item_x += self.button_W + YH_Space_W;
            if (i == _titleArr.count - 1) {
                item_x = item_x - YH_Space_W;
            }
            
        }
        
    }
    self.BtnArr = [mutBtnArr copy];
    self.segmentTitleView.contentSize = CGSizeMake(item_x, YH_SegmentViewHeight);
}


- (CGFloat)widthAtIndex:(NSInteger)index {
    if (index < 0 || index > _titleArr.count - 1) {
        return .0;
    }
    return [[_widthBtnArr objectAtIndex:index] doubleValue];
}


- (void)didClickButton:(UIButton *)button {
    if (button != _selectedButton) {
        button.selected = YES;
        button.titleLabel.font = YH_Font_Selected;
        _selectedButton.selected = !_selectedButton.selected;
        _selectedButton.titleLabel.font = YH_Font_Default;
        _selectedButton = button;
        [self scrollIndicateView];
        [self scrollSegementView];
    }
    // 点击第几个标题加载第几个控制器
    [self loadOtherVCWith:_selectedButton.tag];
    
    if (_yh_resultBlock) {
        _yh_resultBlock(_selectedButton.tag);
       
    }
    
}

- (void)loadOtherVCWith:(NSInteger)tag {

    UIViewController *viewController = self.viewControllersArr[tag];
//    viewController.view.frame = CGRectMake(_size.width * tag, 0, _size.width, _size.height-YH_SegmentViewHeight);
    [viewController.view setFrame:CGRectMake(_size.width * tag, 0, _size.width, _size.height-_ScrollView_Y)];
    [_parentViewController addChildViewController:viewController];
    [viewController didMoveToParentViewController:_parentViewController];
    [_segmentContentView addSubview:viewController.view];
}

#pragma mark --  属性

- (void)setYh_bgColor:(UIColor *)yh_bgColor {
    _yh_bgColor = yh_bgColor;
    _segmentTitleView.backgroundColor = _yh_bgColor;
}

- (void)setYh_titleNormalColor:(UIColor *)yh_titleNormalColor {
    _yh_titleNormalColor = yh_titleNormalColor;
    for (UIButton *titleBtn in self.BtnArr) {
        [titleBtn setTitleColor:yh_titleNormalColor forState:UIControlStateNormal];
        
    }
}

- (void)setYh_titleSelectedColor:(UIColor *)yh_titleSelectedColor {
    _yh_titleSelectedColor = yh_titleSelectedColor;
    for (UIButton *titleBtn in self.BtnArr) {
        [titleBtn setTitleColor:yh_titleSelectedColor forState:UIControlStateSelected];
    }
    if (!_yh_defaultSelectIndex) {
         [self didClickButton:self.BtnArr.firstObject];
    }
   
}

- (void)setYh_segmentTintColor:(UIColor *)yh_segmentTintColor {
    _yh_segmentTintColor = yh_segmentTintColor;
    _indicateView.backgroundColor = yh_segmentTintColor;
}

- (void)setYh_defaultSelectIndex:(NSInteger)yh_defaultSelectIndex {
    _yh_defaultSelectIndex = yh_defaultSelectIndex;
    for (UIView *view in _segmentTitleView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == yh_defaultSelectIndex) {
            UIButton *button = (UIButton *)view;
            [self didClickButton:button];
        }
    }
}

/**
 根据下标更换segment标题名称
 */
- (void)changeTitleWithIndex:(NSInteger)index title:(NSString *)title {
    if (index < self.BtnArr.count) {
        UIButton *titleBtn = self.BtnArr[index];
        [titleBtn setTitle:title forState:UIControlStateNormal];
    }
}

/**
 根据选中的按钮滑动指示杆
 */
- (void)scrollIndicateView {
    NSInteger index = [self selectedAtIndex];
    CGSize titleSize = [_selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : YH_Font_Selected}];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:YH_Duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (weakSelf.yh_indicateStyle == YHSegementIndicateStyleDefault) {
            weakSelf.indicateView.frame = CGRectMake(CGRectGetMinX(weakSelf.selectedButton.frame) + weakSelf.buttonSpace, CGRectGetMinY(weakSelf.indicateView.frame), titleSize.width, YH_IndicateHeight);
        } else {
            weakSelf.indicateView.frame = CGRectMake(CGRectGetMinX(weakSelf.selectedButton.frame), CGRectGetMinY(weakSelf.indicateView.frame), [self widthAtIndex:index], YH_IndicateHeight);
        }
        
        [weakSelf.segmentContentView setContentOffset:CGPointMake(index * weakSelf.size.width, 0)];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 根据选中调整segementView的offset
 */
- (void)scrollSegementView {
    CGFloat selectedWidth = _selectedButton.frame.size.width;
    CGFloat offsetX = (_size.width - selectedWidth) / 2;
    
    if (_selectedButton.frame.origin.x <= _size.width / 2) {
        [_segmentTitleView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (CGRectGetMaxX(_selectedButton.frame) >= (_segmentTitleView.contentSize.width - _size.width / 2)) {
        [_segmentTitleView setContentOffset:CGPointMake(_segmentTitleView.contentSize.width - _size.width, 0) animated:YES];
    } else {
        [_segmentTitleView setContentOffset:CGPointMake(CGRectGetMinX(_selectedButton.frame) - offsetX, 0) animated:YES];
    }
}

#pragma mark -- index

- (NSInteger)selectedAtIndex {
    return _selectedButton.tag;
}


- (void)setSelectedItemAtIndex:(NSInteger)index {
    for (UIView *view in _segmentTitleView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == index) {
            UIButton *button = (UIButton *)view;
            [self didClickButton:button];
        }
    }
}

#pragma mark -- scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = round(scrollView.contentOffset.x / _size.width);
    self.yh_defaultSelectIndex = index;
   // [self setSelectedItemAtIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger currentIndex = [self selectedAtIndex];
    
    // 当当前的偏移量大于被选中index的偏移量的时候，就是在右侧
    CGFloat offset; // 在同一侧的偏移量
    NSInteger buttonIndex = currentIndex;
    if (offsetX >= [self selectedAtIndex] * _size.width) {
        offset = offsetX - [self selectedAtIndex] * _size.width;
        buttonIndex += 1;
    } else {
        offset = [self selectedAtIndex] * _size.width - offsetX;
        buttonIndex -= 1;
        currentIndex -= 1;
    }
    
    CGFloat originMovedX = _yh_indicateStyle == YHSegementIndicateStyleDefault? (CGRectGetMinX(_selectedButton.frame) + _buttonSpace) : CGRectGetMinX(_selectedButton.frame);
    CGFloat targetMovedWidth = [self widthAtIndex:currentIndex];//需要移动的距离
    
    CGFloat targetButtonWidth = _yh_indicateStyle == YHSegementIndicateStyleDefault? ([self widthAtIndex:buttonIndex] - 2 * _buttonSpace) : [self widthAtIndex:buttonIndex]; // 这个会影响width
    CGFloat originButtonWidth = _yh_indicateStyle == YHSegementIndicateStyleDefault? ([self widthAtIndex:[self selectedAtIndex]] - 2 * _buttonSpace) : [self widthAtIndex:[self selectedAtIndex]];
    
    
    CGFloat moved; // 移动的距离
    moved = offsetX - [self selectedAtIndex] * _size.width;
    _indicateView.frame = CGRectMake(originMovedX + targetMovedWidth / _size.width * moved, _indicateView.frame.origin.y,  originButtonWidth + (targetButtonWidth - originButtonWidth) / _size.width * offset, _indicateView.frame.size.height);
}

- (void)setYh_indicateStyle:(YHSegementIndicateStyle)yh_indicateStyle {
    _yh_indicateStyle = yh_indicateStyle;
    if (yh_indicateStyle == YHSegementIndicateStyleDefault) {
        
    }else {
         _indicateView.frame = CGRectMake(_selectedButton.frame.origin.x, YH_SegmentViewHeight - YH_IndicateHeight, [self widthAtIndex:0], YH_IndicateHeight);
    }
}

@end
