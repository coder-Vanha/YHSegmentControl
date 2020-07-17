//
//  YHSegmentControl.m
//  YHSegmentView
//
//  Created by Vanha on 2020/7/12.
//

#import "YHSegmentControl.h"
#import "YHSegmentItem.h"
#import "YHSegmentIndicator.h"
#import "UIView+YHSize.h"

#define progress_width 14

@interface YHSegmentControl ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
//UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *titleBarColView;
@property (nonatomic, strong) YHSegmentIndicator *indicator;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, weak) id<YHSegmentControlDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) YHSegmentSetting *setting;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval progress;
@property (nonatomic, assign) NSTimeInterval lastUpdate;
@property (nonatomic, assign) NSTimeInterval totalTime;
@property (nonatomic, assign) BOOL isClickAction;

/**  */
@property (nonatomic, strong) UIScrollView *pageScrollView;

@end

@implementation YHSegmentControl

+ (YHSegmentControl *)yh_segmentControlWithModels:(NSArray<YHSegmentItmeModel *> *)models setting:(YHSegmentSetting *)setting currentSelectIndex:(NSInteger)index pageScrollView:(UIScrollView *)pageScrollView delegate:(id<YHSegmentControlDelegate>)delegate {
    YHSegmentControl *segmentControl = [YHSegmentControl new];
    segmentControl.pageScrollView = pageScrollView;
    [segmentControl yh_reloadDataWithSetting:setting models:models];

    segmentControl.delegate = delegate;
    [segmentControl.titleBarColView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [segmentControl scrollProgressByClickToIndex:index animated:NO];
    });
    
    return segmentControl;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentIndex = -1;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        self.flowLayout = flowLayout;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
       
        [collectionView registerClass:[YHSegmentItem class] forCellWithReuseIdentifier:kYHSegmentItemCellID];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
      
        self.titleBarColView = collectionView;
        [self addSubview:collectionView];
        
        YHSegmentIndicator *indicator =  [[YHSegmentIndicator alloc] init];
        indicator.clipsToBounds = YES;
        indicator.backgroundColor = [UIColor orangeColor];
        [collectionView addSubview:indicator];
        self.indicator = indicator;
        
        [collectionView bringSubviewToFront:indicator];
       

        // 测试颜色
        collectionView.backgroundColor = [UIColor grayColor];
        self.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}


#pragma mark - Interface

- (void)yh_reloadDataWithSetting:(YHSegmentSetting *)setting models:(NSArray<YHSegmentItmeModel *> *)models {
    _setting = setting;
    _dataSources = models;
    
    [self.indicator yh_setGradientColorsWithSetting:setting];
    
    [self.titleBarColView reloadData];
}


-(void)yh_reloadDataWithModels:(NSArray<YHSegmentItmeModel *> *)models {
    _dataSources = models;
     [self.titleBarColView reloadData];
    
}

- (void)yh_segmentPageDidSelectedIndex:(NSInteger)index {

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHSegmentItem *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:kYHSegmentItemCellID forIndexPath:indexPath];
    if (self.dataSources.count > indexPath.item) {
         YHSegmentItmeModel *model = [self.dataSources objectAtIndex:indexPath.row];
        [cellItem yh_refreshDataWithModel:model setting:self.setting];
    }
   
    return cellItem;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _isClickAction = YES;
    _selectedIndex = indexPath.item;
    [self scrollProgressByClickToIndex:indexPath.item animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.item) {
        YHSegmentItmeModel *model = [self.dataSources objectAtIndex:indexPath.row];
        return CGSizeMake(roundf(model.itemSize.width), self.height);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - YHSegmentProgress

- (void)scrollProgressByClickToIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.currentIndex == index || index >= self.dataSources.count) return;
    if (animated) {
        if (self.isClickAction) {
            self.lastUpdate = CACurrentMediaTime();
            self.totalTime = 0.3;
            self.progress = 0;
            [self.displayLink invalidate];
            self.displayLink = nil;
            CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(mockOffsetX:)];
            timer.frameInterval = 0.1;
            [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
            self.displayLink = timer;
        }
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewCell *item = [self.titleBarColView cellForItemAtIndexPath:indexPath];
        self.indicator.width = self.setting.indicatorSize.width;
        self.indicator.x = item.origin.x  + item.width/2.0 - self.setting.indicatorSize.width/2.0;
    }


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didSelectedIndex:index];
    });
}

- (void)mockOffsetX:(NSTimer *)timer {
    NSTimeInterval now = CACurrentMediaTime();
    self.progress += now - self.lastUpdate;
    self.lastUpdate = now;
    if (self.progress >= self.totalTime) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.progress = self.totalTime;
    }

    CGFloat percent = self.progress / self.totalTime;
  
    [self scrollIndicatorWithPriorIndex:self.currentIndex nextIndex:self.selectedIndex absRatio:percent];
}


- (void)yh_scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isClickAction) {
         CGFloat ratio = scrollView.contentOffset.x / scrollView.width;
        [self scrollIndicatorWithRatio:ratio];
    }
}


- (void)yh_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isClickAction = NO;
}


- (void)didSelectedIndex:(NSInteger)index {
    self.currentIndex = index;
    [self.titleBarColView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(yh_segmentControlItemDidSelectedIndex:)]){
        [self.delegate yh_segmentControlItemDidSelectedIndex:index];
    }
    
}


- (void)scrollIndicatorWithPriorIndex:(NSInteger)priorIndex nextIndex:(NSInteger)nextIndex absRatio:(CGFloat)absRatio {
    // 优化
    YHSegmentItem *priorItem = (YHSegmentItem *)[self.titleBarColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:priorIndex inSection:0]];
    YHSegmentItem *nextItem = (YHSegmentItem *)[self.titleBarColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0]];
    
    CGFloat indicatorWidth = self.setting.indicatorSize.width;
    if (nextItem) {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat x = nextItem.left + nextItem.width/2.0 - indicatorWidth/2.0;
            self.indicator.left = x;
            self.indicator.width = indicatorWidth;
        }];

    }
    
    CGFloat baseScale = self.setting.BaseScale;
    CGFloat toNormalScale = self.setting.MaxZoomScale - (self.setting.MaxZoomScale - 1) * absRatio;
    CGFloat toSelectedScale = 1 + (self.setting.MaxZoomScale - 1) * absRatio;
    
    if (nextItem) {
        [nextItem yh_changeTitleColorFromColor:self.setting.titleNormalColor toColor:self.setting.titleSelectColor percent:absRatio];
        [nextItem yh_setAnimationWithItemStatus:YHSegmentItemStatusSelected absRatio:absRatio transScale:baseScale*toSelectedScale];
    }
    
    if (priorItem) {
        [priorItem yh_changeTitleColorFromColor:self.setting.titleSelectColor toColor:self.setting.titleNormalColor percent:absRatio];
        [priorItem yh_setAnimationWithItemStatus:YHSegmentItemStatusNormal absRatio:absRatio transScale:baseScale*toNormalScale];
    }
    

}


- (void)scrollIndicatorWithRatio:(CGFloat)ratio {
    if (ratio < 0 || ratio > self.dataSources.count - 1) return;

       NSInteger leftNodeIndex = floor(ratio);
       NSInteger rightNodeIndex = ceil(ratio);
    
       // 优化
       YHSegmentItem *leftItem = (YHSegmentItem *)[self.titleBarColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:leftNodeIndex inSection:0]];
       YHSegmentItem *rightItem = (YHSegmentItem *)[self.titleBarColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:rightNodeIndex inSection:0]];

       CGFloat indicatorWidth = self.setting.indicatorSize.width;


       if (ratio == leftNodeIndex && leftItem) {
           CGFloat left = leftItem.left + leftItem.width/2.0 - indicatorWidth/2.0;
           self.indicator.left = left;
           self.indicator.width = indicatorWidth;
       } else if (ratio == rightNodeIndex && rightItem) {

           CGFloat left = rightItem.left + rightItem.width/2.0 - indicatorWidth/2.0;
           self.indicator.left = left;
           self.indicator.width = indicatorWidth;
       } else {
           if (leftItem && rightItem) {
               CGFloat absRatio = ratio - leftNodeIndex;
               CGFloat leftItemCenterX = leftItem.centerX;
               CGFloat rightItemCenterX = rightItem.centerX;

               if (absRatio < 0.5) {
                   CGFloat x = leftItemCenterX - indicatorWidth/2.0 *(1- absRatio/0.5);
                   CGFloat width = indicatorWidth/2.0 *(1- absRatio/0.5) + indicatorWidth/2.0 + absRatio/0.5 *(rightItemCenterX - leftItemCenterX - indicatorWidth/2.0);

                   self.indicator.left = x;
                   self.indicator.width = width;

               } else if (absRatio == 0.5) {
                   CGFloat x = leftItem.left + leftItem.width/2.0 ;
                   CGFloat width = rightItemCenterX - leftItemCenterX;

                   self.indicator.left = x;
                   self.indicator.width = width;

               } else {
                   CGFloat x = leftItemCenterX + (rightItemCenterX - leftItemCenterX - indicatorWidth/2.0) * (absRatio-0.5)/0.5;
                   CGFloat width = rightItemCenterX - x + indicatorWidth/2.0 * (absRatio-0.5)/0.5;

                   self.indicator.left = x;
                   self.indicator.width = width;
               }
           }
       }

       [self setTitleAnimationWithLeftItem:leftItem rightItem:rightItem leftNodeIndex:leftNodeIndex rightNodeIndex:rightNodeIndex ratio:ratio];
}


- (void)setTitleAnimationWithLeftItem:(YHSegmentItem *)leftItem rightItem:(YHSegmentItem *)rightItem leftNodeIndex:(NSInteger)leftNodeIndex rightNodeIndex:(NSInteger)rightNodeIndex ratio:(CGFloat)ratio {
    
    CGFloat absRatio = ratio - leftNodeIndex;
    
    if (absRatio < 0.5 && leftNodeIndex != _currentIndex) {
         [self didSelectedIndex:leftNodeIndex];
    }
    
    if (absRatio > 0.5 && rightNodeIndex != _currentIndex) {
         [self didSelectedIndex:rightNodeIndex];
    }
    
    if (ratio == leftNodeIndex && leftItem) {
        // do nothing
    } else if (ratio == rightNodeIndex && rightItem) {
        // do nothing
    } else {
        if (leftItem && rightItem) {
            [leftItem yh_changeTitleColorFromColor:self.setting.titleSelectColor toColor:self.setting.titleNormalColor percent:absRatio];
            [rightItem yh_changeTitleColorFromColor:self.setting.titleNormalColor toColor:self.setting.titleSelectColor percent:absRatio];
            
            CGFloat baseScale = self.setting.BaseScale;
            CGFloat leftZoomScale = self.setting.MaxZoomScale - (self.setting.MaxZoomScale - 1) * absRatio;
            CGFloat rightZoomScale = 1 + (self.setting.MaxZoomScale - 1) * absRatio;
            
            
            if (absRatio < 0.5 && absRatio > 0) { // >>> to right
                [leftItem yh_setAnimationWithItemStatus:YHSegmentItemStatusSelected absRatio:absRatio transScale:baseScale*leftZoomScale];
                [rightItem yh_setAnimationWithItemStatus:YHSegmentItemStatusNormal absRatio:absRatio transScale:baseScale*rightZoomScale];
                
            } else { // <<<< to left
                [leftItem yh_setAnimationWithItemStatus:YHSegmentItemStatusNormal absRatio:absRatio transScale:baseScale*leftZoomScale];
                [rightItem yh_setAnimationWithItemStatus:YHSegmentItemStatusSelected absRatio:absRatio transScale:baseScale*rightZoomScale];
            }
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleBarColView.frame = self.bounds;
    
}

@end
