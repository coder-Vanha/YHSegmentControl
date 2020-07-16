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
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *menuColView;
@property (nonatomic, strong) YHSegmentIndicator *indicator;
//@property (nonatomic, strong) CAGradientLayer *progressGradientLayer;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, weak) id<YHSegmentControlDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) YHSegmentSetting *setting;

@end

@implementation YHSegmentControl

+ (YHSegmentControl *)yh_segmentControlWithModels:(NSArray<YHSegmentItmeModel *> *)models setting:(YHSegmentSetting *)setting currentSelectIndex:(NSInteger)index pageScrollView:(UIScrollView *)pageScrollView delegate:(id<YHSegmentControlDelegate>)delegate {
    YHSegmentControl *segmentControl = [YHSegmentControl new];
    [segmentControl yh_reloadDataWithSetting:setting models:models];

    segmentControl.delegate = delegate;
    [segmentControl.menuColView reloadData];
    
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
      
        self.menuColView = collectionView;
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
    
    [self.menuColView reloadData];
}


-(void)yh_reloadDataWithModels:(NSArray<YHSegmentItmeModel *> *)models {
    _dataSources = models;
     [self.menuColView reloadData];
    
}

//- (void)yh_segmentPageDidSelectedIndex:(NSInteger)index {
//
//}

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
   
    if (YES) { //
         [self scrollProgressByClickToIndex:indexPath.item animated:YES];
    }
    
    [self willChangeCurrentIndexWithIndex:indexPath.item];
   
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.dataSources.count > indexPath.item) {
        YHSegmentItmeModel *model = [self.dataSources objectAtIndex:indexPath.row];
        return CGSizeMake(roundf(model.itemSize.width), self.height - 4);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - YHSegmentProgress


- (void)yh_scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (!_s_isClickScroll)
//    {
   // if (NO) {
         [self scrollProgressByDraggingWithScrollView:scrollView];
 //   }
   
  //  }
}

- (void)yh_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
//    if (!_s_isClickScroll)
//    {
        CGFloat ratio = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
        
        NSInteger leftNodeIndex = floor(ratio);
        NSInteger rightNodeIndex = ceil(ratio);
        
        CGFloat absRatio = ratio - leftNodeIndex;
    
       
      
        if (absRatio <=0.5)
        {
            //self.currentIndex = leftNodeIndex;
            [self willChangeCurrentIndexWithIndex:leftNodeIndex];
        }
        else
        {
            //self.currentIndex = rightNodeIndex;
            [self willChangeCurrentIndexWithIndex:rightNodeIndex];
        }
        
     //  NSLog(@"😄current----Index:%ld",self.currentIndex);
       // [self s_didMoveToIndex:self.currentIndex];
  //  }
    

    
}

- (void)willChangeCurrentIndexWithIndex:(NSInteger)index{
//     YHSegmentItem *priorItem = (YHSegmentItem *)[self.menuColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
   // [priorItem setSelected:NO];
    self.currentIndex = index;
//    YHSegmentItem *currentItem = (YHSegmentItem *)[self.menuColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
   // [currentItem setSelected:YES];
    
    [self.menuColView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yh_segmentControlItemDidSelectedIndex:)]){
        [self.delegate yh_segmentControlItemDidSelectedIndex:index];
    }
    
}

- (void)scrollProgressByDraggingWithScrollView:(UIScrollView *)scrollView {
    
    CGFloat ratio = scrollView.contentOffset.x / scrollView.width;
   
    if (ratio < 0 || ratio > self.dataSources.count - 1) {
        return;
    }
    
    NSInteger leftNodeIndex = floor(ratio);
    NSInteger rightNodeIndex = ceil(ratio);
    
    // 优化
    YHSegmentItem *leftItem = (YHSegmentItem *)[self.menuColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:leftNodeIndex inSection:0]];
    YHSegmentItem *rightItem = (YHSegmentItem *)[self.menuColView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:rightNodeIndex inSection:0]];
    
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
            
            //NSLog(@"😄：------%lf",absRatio);
            
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
    
    if (ratio == leftNodeIndex && leftItem) {
        // do nothing
    } else if (ratio == rightNodeIndex && rightItem) {
        // do nothing
    } else {
        if (leftItem && rightItem) {
            CGFloat absRatio = ratio - leftNodeIndex;
            
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

- (void)scrollProgressByClickToIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index < 0 || index>= self.dataSources.count || self.dataSources.count <= 0 || _currentIndex == index) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cellItem = [self.menuColView cellForItemAtIndexPath:indexPath];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
//            self.indicator.frame = CGRectMake(cellItem.left + (cellItem.width-progress_width)/2, self.height - self.setting.indicatorHeight, progress_width, self.setting.indicatorHeight);
            
            self.indicator.left = cellItem.left + (cellItem.width-progress_width)/2;
            
        } completion:^(BOOL finished) {
            self->_currentIndex = index;
        }];
    } else {
        
        self.indicator.left = cellItem.left + (cellItem.width-progress_width)/2;
        _currentIndex = index;
    }
    
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.menuColView.frame = self.bounds;
    
}

@end
